;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir   = "./outputs_cpl_owa.gls/"
  ; Dir   = "./outputs_frc_wrf/"
  FILES = systemfunc (" ls -1 " + Dir + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES)

;------------- Reading Text Data -----------------
  Nc = 43
  cyclone_file1 = Dir + "Cyclone_center.txt"
  
  CC1  = new((/Nc,2/), "float")
  tmp := readAsciiTable(cyclone_file1, 3, "float", 1)
  CC1  = tmp(:,1:2)

  Ph = fspan(1000.,600.,41)

  Nc = 37
  j  = 0
  L1 = 32
  step = 1
  do ifil = 3, 4, 1
    fName = FILES(ifil)+".nc"
    in = addfile(fName,"r")

    dims = getfiledimsizes(in)
    lat  = in->XLAT(0,:,:)
    lon  = in->XLONG(0,:,:)
    time = wrf_user_getvar(in,"times",-1)
    TimeChar := in->Times
    timestr  := wrf_times_c(TimeChar,3)

    if (j .eq. 0) then
      Profile = new((/ 41, Nc /), "float")
    end if

    do i=0, dims(0)-1, step
      center := wrf_user_ll_to_ij(in, CC1(j,0), CC1(j,1), True)
      ew1 = max((/ center(0)-L1, 0 /))
      ew2 = min((/ center(0)+L1, dims(2)-1 /))
      sn1 = max((/ center(1)-L1, 0 /))
      sn2 = min((/ center(1)+L1, dims(3)-1 /))

      p    = wrf_user_getvar(in,"pressure",i)
      ETH  = wrf_user_getvar(in,"eth",i)
      Pc1  = p(:,center(1),center(0))
      ETH_avg = dim_avg_n(ETH(:,sn1:sn2,ew1:ew2),(/1,2/))
      Profile(:,j) = linint1(Pc1,ETH_avg,False,Ph,0)

      if (j .eq. Nc-1) then
        break
      end if
      j = j + 1
    end do
  end do

  Profile!0 = "height"
  Profile!1 = "time"
  Profile&height = Ph
  Profile&time   = fspan(0,Nc-1,Nc)
  Profile@long_name = ETH@description
  Profile@units = ETH@units
  Profile@_FillValues = default_fillvalue("float")

;************************************************
; create default plot
;************************************************
  imgName = "img/OWA.MYNN.GLS_ETH_Time-profile-center"
  wks_type                   = "png"
  wks_type@wkHeight          = 800
  wks_type@wkWidth           = 960
  wks = gsn_open_wks(wks_type, imgName)
  gsn_define_colormap(wks,"NCV_jet")

  res                        = True
  res@tiMainString           = "Temperature Profile (AWO,MYNN,GLS)"
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
  res@tiXAxisString          = "hours since 2018-01-04 00:00"
  res@tiYAxisString          = "Pressure[hPa]"
  res@tiXAxisFontHeightF     = 0.017
  res@tiYAxisFontHeightF     = 0.017
  res@tiXAxisOffsetYF        = 0.15
  res@tmXBLabelFontHeightF   = 0.015
  res@tmYLLabelFontHeightF   = 0.015
  res@gsnCenterStringFontHeightF    = 0.015
  res@gsnCenterStringOrthogonalPosF = 0.018
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
  opts1@cnLevelSpacingF       = 2.0
  opts1@cnMaxLevelValF        = 320.0
  opts1@cnMinLevelValF        = 290.0
  opts1@pmLabelBarParallelPosF   = 0.5
  opts1@pmLabelBarOrthogonalPosF = 0.1
  opts1@lbLabelFontHeightF       = 0.015
  opts1@lbLabelStride            = 5
  opts1@lbTitleString            = Profile@long_name + " [" + Profile@units + "]"
  opts1@lbTitleFontHeightF       = 0.017
  opts1@lbBoxSeparatorLinesOn    = False

  plot  = gsn_csm_contour (wks,Profile,opts1)
  print("Case: " + Dir)
  draw(plot)
  frame(wks)

end
