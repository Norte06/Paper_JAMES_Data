;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir1  = "./outputs_cpl_ow.gls/"
  Dir2  = "./outputs_frc_croco.gls/"
  ; Dir2  = "./outputs_cpl_owa.gls.no-aw/"
  FILES1  = systemfunc (" ls -1 " + Dir1 + "croco_his.0???.nc")
  FILES2  = systemfunc (" ls -1 " + Dir2 + "croco_his.0???.nc")
  numFILES = dimsizes(FILES1)

  fName = Dir1 + "croco_his.0000.nc"
  in = addfile(fName, "r")

  dims0   = getfiledimsizes(in)
  lat_rho = in->lat_rho(:,0)
  lon_rho = in->lon_rho(0,:)
  h       = in->h
  hc      = in->hc
  cff1    = in->Cs_r
  cff1w   = in->Cs_w
  sc      = in->sc_r
  scw     = in->sc_w
  cff2    = sc
    cff2  = sc + 1.0
  cff2w   = scw
    cff2w = scw + 1.0
  zeta    = in->zeta(0,:,:)

  LAT = 39.0
  LON = 292.0
  ilat = ind_nearest_coord(LAT,lat_rho,0)
  jlon = ind_nearest_coord(LON,lon_rho,0)
  ; N  = (numFILES-1)*dims(7) + 1
  N  = 4 * dims0(7)

  depth   = new((/ dims0(5) /), "float")
  hhc = h(ilat,jlon) + hc
  do k = 0, dims0(5)-1, 1
    z0 = hc * sc(k) + cff1(k)*h(ilat,jlon)
    depth(dims0(5)-k-1) = z0 * h(ilat,jlon) / hhc - zeta(ilat,jlon) * (1.0 + z0/hhc)
  end do
  depth_w = new((/ dims0(6) /), "float")
  do k = 0, dims0(6)-1, 1
    z0 = hc * scw(k) + cff1w(k)*h(ilat,jlon)
    depth_w(dims0(6)-k-1) = z0 * h(ilat,jlon) / hhc - zeta(ilat,jlon) * (1.0 + z0/hhc)
  end do

;************************************************
;  File Loop
;************************************************
  t = 0
  do ifil = 2, 5, 1
  ; do ifil = 0, numFILES-1, 1
    fName1 = FILES1(ifil)
    fName2 = FILES2(ifil)
    in1 = addfile(fName1, "r")
    in2 = addfile(fName2, "r")
    
    dims := getfiledimsizes(in1)
    time := in1->time
      time@units = "seconds since 2010-01-01 00:00:00"
    AKv1 := in1->AKv(:,::-1,ilat,jlon)
    AKv2 := in2->AKv(:,::-1,ilat,jlon)
    T1  := in1->temp(:,::-1,ilat,jlon)
    T2  := in2->temp(:,::-1,ilat,jlon)
    S1  := in1->salt(:,::-1,ilat,jlon)
    S2  := in2->salt(:,::-1,ilat,jlon)
    ; hbl1 := in1->hbl(:,ilat,jlon)
    ; hbl2 := in2->hbl(:,ilat,jlon)

    if (t .eq. 0) then
      Nt = dims(6) ;dims(7)
      date  = new(N, "double")
      MLD1  = new(N, "float")
      MLD2  = new(N, "float")
      AKv_profile = new((/ dims(5), N /), "float")
        copy_VarAtts(AKv1, AKv_profile)
    else
      Nt = dims(6)
    end if
    
    Rho1  = new((/dims(6),dims(4)/),"float")
    Rho2  = new((/dims(6),dims(4)/),"float")
    tmp1 = new((/dims(6),1/),"float")
    tmp2 = new((/dims(6),1/),"float")
    tmp3 = new((/dims(6),1/),"float")
    do k = 0, dims(4)-1, 1
      tmp1(:,0) = T1(:,k)
      tmp2(:,0) = S1(:,k)
      tmp3 = rho_mwjf(tmp1,tmp2,-depth(k))
      Rho1(:,k) = tmp3(:,0)
      tmp1(:,0) = T2(:,k)
      tmp2(:,0) = S2(:,k)
      tmp3 = rho_mwjf(tmp1,tmp2,-depth(k))
      Rho2(:,k) = tmp3(:,0)
    end do

    hours := time_to_newtime(time, "hours since 2018-01-03 00:00:00")
    do i=0, Nt-1, 1                 ; ***** Begin Data Loop *****
      date(t) = hours(i)
      AKv_profile(:,t) = (/ AKv1(i,:) - AKv2(i,:) /)

      diff = center_finite_diff(Rho1(i,:)*1000.,depth,False,0)
      indm = minind(diff(0:20))
      MLD1(t) = depth(indm(0))
      diff = center_finite_diff(Rho2(i,:)*1000.,depth,False,0)
      indm = minind(diff(0:20))
      MLD2(t) = depth(indm(0))
      ; MLD1(t) = (/ -1.0 * hbl1(i) /)
      ; MLD2(t) = (/ -1.0 * hbl2(i) /)
      t = t + 1
    end do
  end do
  
  AKv_profile!0 = "depth"
  AKv_profile!1 = "time"
  AKv_profile&depth = depth_w
  AKv_profile&time  = date
  AKv_profile@long_name = "Eddy Viscosity Difference"
  AKv_profile@units = "m~S~2~N~/s"
  ; printVarSummary(AKv_profile)

;************************************************
; create default plot
;************************************************
  imgName = "img/OW-O.GLS_AKv_vert-time(lat" + LAT + "-lon" + LON + ")"
  wks_type                   = "png"
  wks_type@wkHeight          = 640
  wks_type@wkWidth           = 960
  wks = gsn_open_wks(wks_type, imgName)
  gsn_define_colormap(wks,"MPL_PuOr")
  gsn_reverse_colormap(wks)

  res                        = True
  res@tiMainString           = "WO-O: Eddy Viscosity (GLS)"
  res@tiMainFontHeightF      = 0.016
  res@tiMainOffsetYF         = -0.01
  res@gsnCenterString        = "lat:" + LAT + ", lon:" + LON
  res@vpWidthF               = 0.6
  res@vpHeightF              = 0.36
  res@gsnMaximize            = True
  res@gsnAddCyclic           = False
  res@tiXAxisString          = "hours since 2018-01-03 0:00"
  res@tiYAxisString          = "depth[m]"
  res@tiXAxisFontHeightF     = 0.015
  res@tiYAxisFontHeightF     = 0.015
  res@tiXAxisOffsetYF        = 0.15
  res@tmXBLabelFontHeightF   = 0.014
  res@tmYLLabelFontHeightF   = 0.014
  res@gsnCenterStringFontHeightF    = 0.015
  res@gsnCenterStringOrthogonalPosF = 0.018
    
;------------- For Temperature -----------------
  opts1                       = res
  opts1@gsnDraw               = False
  opts1@gsnFrame              = False
  opts1@gsnRightString        = ""
  opts1@gsnLeftString         = ""
  opts1@cnFillOn              = True
  opts1@cnLinesOn             = False
  opts1@pmLabelBarHeightF     = 0.06
  opts1@pmLabelBarWidthF      = 0.46
  opts1@cnLevelSelectionMode  = "ManualLevels"
  opts1@cnLevelSpacingF       = 0.08
  opts1@cnMaxLevelValF        = 0.8
  opts1@cnMinLevelValF        = -0.8
  opts1@gsnYAxisIrregular2Linear = True
  opts1@pmLabelBarParallelPosF   = 0.5
  opts1@pmLabelBarOrthogonalPosF = 0.1
  opts1@lbLabelFontHeightF       = 0.014
  opts1@lbLabelStride            = 5
  opts1@lbTitleString            = AKv_profile@long_name + " [" + AKv_profile@units + "]"
  opts1@lbTitleFontHeightF       = 0.016
  opts1@lbBoxSeparatorLinesOn    = False
  
;------------- For Polylines1 -----------------
  resl1                        = True
  resl1@gsLineColor            = "black"
  resl1@gsLineThicknessF       = 3.0
  resl1@gsLineLabelString      = ""
  ; resl1@gsLineLabelString      = "MLD(WO)"
  resl1@gsLineDashPattern      = 1
  resl1@gsLineLabelFontHeightF = 0.02
  resl1@gsLineLabelFontColor   = "black"

;------------- For Polylines2 -----------------
  resl2                        = True
  resl2@gsLineColor            = "green4"
  resl2@gsLineThicknessF       = 3.0
  resl2@gsLineLabelString      = ""
  ; resl2@gsLineLabelString      = "MLD(O)"
  resl2@gsLineDashPattern      = 1
  resl2@gsLineLabelFontHeightF = 0.02
  resl2@gsLineLabelFontColor   = "green4"

  plot    = gsn_csm_contour(wks,AKv_profile(0:21,:),opts1)
  line1   = gsn_add_polyline(wks,plot,date,MLD1,resl1)
  line2   = gsn_add_polyline(wks,plot,date,MLD2,resl2)
  print("Point: lat" + LAT + "N,  lon" + LON + "E")
  draw(plot)
  frame(wks)
  
end
