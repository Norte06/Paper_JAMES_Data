;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir   = "outputs_cpl_ow.gls/"
  ; Dir   = "outputs_frc_croco.gls/"
  FILES  = systemfunc (" ls -1 " + Dir + "croco_his.0???.nc")
  ; numFILES = 9
  numFILES = dimsizes(FILES)

  fName = Dir + "croco_his.0000.nc"
  in = addfile(fName, "r")

  dims0   = getfiledimsizes(in)
  lat_rho = in->lat_rho(:,0)
  lon_rho = in->lon_rho(0,:)
  h       = in->h
  hc      = in->hc
  cff1    = in->Cs_r
  sc      = in->sc_r
  cff2    = sc
    cff2  = sc + 1.0

  LAT = 39.0
  LON = 292.0
  ilat = ind_nearest_coord(LAT,lat_rho,0)
  jlon = ind_nearest_coord(LON,lon_rho,0)
  ; N  = (numFILES-1)*dims(7) + 1
  N  = 4 * dims0(7) 

;************************************************
;  File Loop
;************************************************
  t = 0
  do ifil = 2, 5, 1
  ; do ifil = 0, numFILES-1, 1
    fName1 = FILES(ifil)
    in1 = addfile(fName1, "r")
    
    dims := getfiledimsizes(in1)
    time := in1->time
      time@units = "seconds since 2010-01-01 00:00:00"
    S := in1->salt(:,::-1,ilat,jlon)
    T := in1->temp(:,::-1,ilat,jlon)

    if (t .eq. 0) then
      zeta   = in1->zeta(0,:,:)
      depth := cff1
      do k = 0, dims0(5)-1, 1
        z0 = hc * sc(k) + cff1(k)*h(ilat,jlon)
        depth(dims0(5)-k-1) = z0 * h(ilat,jlon) / (h(ilat,jlon)+hc) + zeta(ilat,jlon) * (1.0 + z0/(h(ilat,jlon)+hc))
      end do
        depth!0     = "depth"
        depth&depth = depth

      Nt = dims(6) ;dims(7)
      date = new(N, "double")
      MLD  = new(N, "float")
      T_profile = new((/ dims(4), N /), "float")
        copy_VarAtts(T, T_profile)
    else
      Nt = dims(6)
    end if
    
    Rho  = new((/dims(6),dims(4)/),"float")
    tmp1 = new((/dims(6),1/),"float")
    tmp2 = new((/dims(6),1/),"float")
    tmp3 = new((/dims(6),1/),"float")
    do k = 0, dims(4)-1, 1
      tmp1(:,0) = T(:,k)
      tmp2(:,0) = S(:,k)
      tmp3 = rho_mwjf(tmp1,tmp2,-depth(k))
      Rho(:,k) = tmp3(:,0)
    end do

    hours := time_to_newtime(time, "hours since 2018-01-03 00:00:00")
    do i=0, Nt-1, 1                 ; ***** Begin Data Loop *****
      date(t) = hours(i)
      diff = center_finite_diff(Rho(i,:)*1000.,depth,False,0)
      indm = minind(diff(0:20))
      MLD(t) = depth(indm(0))

      T_profile(:,t) = (/ T(i,:) /)
      t = t + 1
    end do
  end do
  
  T_profile!0 = "depth"
  T_profile!1 = "time"
  T_profile&depth = depth
  T_profile&time  = date
  T_profile@long_name = "Potential Temperature"
  T_profile@units = "C"
  ; printVarSummary(T_profile)

;************************************************
; create default plot
;************************************************
  imgName = "img/OW.GLS_oTemp_vert-time(lat" + LAT + "-lon" + LON + ")"
  wks_type                   = "png"
  wks_type@wkHeight          = 640
  wks_type@wkWidth           = 960
  wks = gsn_open_wks(wks_type, imgName)
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")

  res                        = True
  res@tiMainString           = "Potential Temperature (WO,GLS)"
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
  opts1@cnLevelSpacingF       = 0.25
  opts1@cnMaxLevelValF        = 15.0
  opts1@cnMinLevelValF        = 10.0
  opts1@gsnYAxisIrregular2Linear = True
  opts1@pmLabelBarParallelPosF   = 0.5
  opts1@pmLabelBarOrthogonalPosF = 0.1
  opts1@lbLabelFontHeightF       = 0.014
  opts1@lbLabelStride            = 4
  opts1@lbTitleString            = T_profile@long_name + " [" + T_profile@units + "]"
  opts1@lbTitleFontHeightF       = 0.016
  opts1@lbBoxSeparatorLinesOn    = False
  
;------------- For Polylines -----------------
  resl                        = True
  resl@gsLineColor            = "black"
  resl@gsLineThicknessF       = 3.0
  resl@gsLineLabelString      = ""
  resl@gsLineDashPattern      = 1
  resl@gsLineLabelFontHeightF = 0.02
  resl@gsLineLabelFontColor   = "black"

  plot    = gsn_csm_contour(wks,T_profile(0:21,:),opts1)
  line    = gsn_add_polyline(wks,plot,date,MLD,resl)
  print("Case: " + Dir)
  print("Point: lat" + LAT + "N,  lon" + LON + "E")
  draw(plot)
  frame(wks)
  
end
