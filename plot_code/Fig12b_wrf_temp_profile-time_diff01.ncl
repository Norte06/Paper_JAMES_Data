;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir1   = "./outputs_cpl_owa.gls/"
  Dir2   = "./outputs_cpl_oa.gls/"
  FILES1 = systemfunc (" ls -1 " + Dir1 + "wrfout_d01_2018-01-*00 ")
  FILES2 = systemfunc (" ls -1 " + Dir2 + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES1)

;------------- Reading Text Data -----------------
  Nc = 43
  cyclone_file1 = Dir1 + "Cyclone_center.txt"
  cyclone_file2 = Dir2 + "Cyclone_center.txt"
  
  CC1  = new((/Nc,2/), "float")
  CC2  = new((/Nc,2/), "float")
  tmp := readAsciiTable(cyclone_file1, 3, "float", 1)
  CC1  = tmp(:,1:2)
  tmp := readAsciiTable(cyclone_file2, 3, "float", 1)
  CC2  = tmp(:,1:2)

  Ph = fspan(1000.,600.,41)

  Nt = 37
  j  = 0
  L1 = 32
  step = 1
  do ifil = 3, 4, 1
    fName1 = FILES1(ifil)+".nc"
    fName2 = FILES2(ifil)+".nc"
    in1 = addfile(fName1,"r")
    in2 = addfile(fName2,"r")

    dims = getfiledimsizes(in1)
    lat  = in1->XLAT(0,:,:)
    lon  = in1->XLONG(0,:,:)
    time = wrf_user_getvar(in1,"times",-1)
    TimeChar := in1->Times
    timestr  := wrf_times_c(TimeChar,3)

    if (j .eq. 0) then
      Profile = new((/ 41, Nt /), "float")
    end if

    do i=0, dims(0)-1, step
      center := wrf_user_ll_to_ij(in1, CC1(j,0), CC1(j,1), True)
      ew1 = max((/ center(0)-L1, 0 /))
      ew2 = min((/ center(0)+L1, dims(2)-1 /))
      sn1 = max((/ center(1)-L1, 0 /))
      sn2 = min((/ center(1)+L1, dims(3)-1 /))

      p    = wrf_user_getvar(in1,"pressure",i)
      ETH  = wrf_user_getvar(in1,"eth",i)
      Pc1  = p(:,center(1),center(0))
      ETH_avg1 = dim_avg_n(ETH(:,sn1:sn2,ew1:ew2),(/1,2/))

      center := wrf_user_ll_to_ij(in2, CC2(j,0), CC1(j,1), True)
      ew1 = max((/ center(0)-L1, 0 /))
      ew2 = min((/ center(0)+L1, dims(2)-1 /))
      sn1 = max((/ center(1)-L1, 0 /))
      sn2 = min((/ center(1)+L1, dims(3)-1 /))

      p    = wrf_user_getvar(in2,"pressure",i)
      ETH  = wrf_user_getvar(in2,"eth",i)
      Pc2  = p(:,center(1),center(0))
      ETH_avg2 = dim_avg_n(ETH(:,sn1:sn2,ew1:ew2),(/1,2/))

      Profile(:,j) = linint1(Pc1,ETH_avg1,False,Ph,0) - linint1(Pc2,ETH_avg2,False,Ph,0)

      if (j .eq. Nt-1) then
        break
      end if
      j = j + 1
    end do
  end do

  Profile!0 = "height"
  Profile!1 = "time"
  Profile&height = Ph
  Profile&time   = fspan(0,Nt-1,Nt)
  Profile@long_name = ETH@description
  Profile@units = ETH@units
  Profile@_FillValues = default_fillvalue("float")
    var_size = dimsizes(Profile)

  Profile1D := ndtooned(Profile)
  chk := ind(Profile1D .gt. 200.)
  if (.not. any(ismissing(chk))) then
    do k=0, dimsizes(chk)-1, 1
      Profile1D(chk(k)) = default_fillvalue("float")
    end do
  end if
  Profile = onedtond(Profile1D, var_size)

;************************************************
; create default plot
;************************************************
  imgName = "img/OWA-OA.MYNN_ETH_Time-profile-center"
  wks_type                   = "png"
  wks_type@wkHeight          = 800
  wks_type@wkWidth           = 960
  wks = gsn_open_wks(wks_type, imgName)
  gsn_define_colormap(wks,"temp_diff_18lev")

  res                        = True
  res@tiMainString           = "AWO-AO: Temperature Profile (MYNN,GLS)"
  res@tiMainFontHeightF      = 0.017
  res@tiMainOffsetYF         = -0.01
  res@vpWidthF               = 0.45
  res@vpHeightF              = 0.6
  res@gsnMaximize            = True
  res@gsnAddCyclic           = False
  res@trYReverse             = True
  res@trXMinF                = 0.
  res@trXMaxF                = 36.
  res@trYMinF                = 600.
  res@trYMaxF                = 1000.
  res@gsnCenterStringFontHeightF    = 0.014
  res@gsnCenterStringOrthogonalPosF = 0.018

  res@tmXMajorGrid           = True
  res@tmYMajorGrid           = True
  res@tmXMajorGridThicknessF = 1.0
  res@tmYMajorGridThicknessF = 1.0
  res@tmXBMode               = "Manual"
  res@tmXBTickStartF         = 0
  res@tmXBTickEndF           = 36
  res@tmXBTickSpacingF       = 12
  res@gsnCenterString        = "Around Center"
  res@tiXAxisString          = "hours since 2018-01-04 0:00"
  res@tiYAxisString          = "Pressure[hPa]"
  res@tiXAxisFontHeightF     = 0.016
  res@tiYAxisFontHeightF     = 0.017
  res@tiXAxisOffsetYF        = 0.15
  res@tmXBLabelFontHeightF   = 0.015
  res@tmYLLabelFontHeightF   = 0.015
  res@tmXMajorGridLineDashPattern   = 2
  res@tmYMajorGridLineDashPattern   = 2

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
  opts1@cnLevelSpacingF       = 0.5
  opts1@cnMaxLevelValF        = 4.5
  opts1@cnMinLevelValF        = -4.5
  opts1@pmLabelBarParallelPosF   = 0.5
  opts1@pmLabelBarOrthogonalPosF = 0.1
  opts1@lbLabelFontHeightF       = 0.015
  opts1@lbLabelStride            = 3
  opts1@lbTitleString            = "Equivalent Potential Temperature Difference [K]"
  opts1@lbTitleFontHeightF       = 0.017
  opts1@lbBoxSeparatorLinesOn    = False

  plot  = gsn_csm_contour (wks,Profile,opts1)
  draw(plot)
  frame(wks)

end
