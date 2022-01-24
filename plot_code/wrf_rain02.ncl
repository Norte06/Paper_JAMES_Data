;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  ; Dir   = "./outputs_frc_wrf/"
  Dir   = "./outputs_cpl_oa.gls/"
  FILES = systemfunc (" ls -1 " + Dir + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES)

  lats = (/ 24., 48. /)
  lons = (/ -85., -55. /)

;------------- Map Attributes -----------------
  pltres  = True
  ; pltres@NoTitles               = True
  
  mpres0  = True
  mpres0@mpGeophysicalLineColor = "Black"
  mpres0@mpDataBaseVersion      = "MediumRes"
  mpres0@mpNationalLineColor    = "Black"
  mpres0@mpUSStateLineColor     = "Black"
  mpres0@mpGeophysicalLineThicknessF = 2.5
  
;************************************************
;  File Loop
;************************************************
  t = 0
  istep = 3
  ; do ifil = 4, numFILES-1, 1
  do ifil = 3, 4, 1
    fName = FILES(ifil)+".nc"
    in = addfile(fName,"r")

    dims = getfiledimsizes(in)
    lat  = in->XLAT(0,:,:)
    lon  = in->XLONG(0,:,:)
    lev  = wrf_user_getvar(in,"pressure",0)
    time = wrf_user_getvar(in,"times",-1)
    TimeChar := in->Times
    timestr  := wrf_times_c(TimeChar,3)
  
;************************************************
; Date Loop
;************************************************
    do i=0, dims(0)-1, istep
      if (t .eq. 0) then
        t = t + 1
        continue
      end if
      loc  = wrf_user_ll_to_ij(in, lons, lats, True)
      MSLP = wrf_user_getvar(in,"slp",i)

      Rain = in->RAINNC(i,:,:)
      if (i .ne. 0 ) then
        RainP = in->RAINNC(i-1,:,:)
      end if

      Rain = Rain - RainP

;************************************************
; create default plot
;************************************************
      imgName = "img/OA.MYNN.GLS_Rain_" + timestr(i)
      wks_type                   = "png"
      wks_type@wkHeight          = 960
      wks_type@wkWidth           = 960
      wks = gsn_open_wks(wks_type, imgName)
      gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")

      res                        = True
      res@MainTitle              = "Precipitation (AO,MYNN,GLS)"
      res@TimeLabel              = time(i)
      res@vpWidthF               = 0.6
      res@vpHeightF              = 0.5
      res@gsnMaximize            = True
      res@Footer                 = False
      res@PlotLevelID            = True
    
      mpres0@ZoomIn              = True
      mpres0@Xstart              = loc(0,0)
      mpres0@Xend                = loc(0,1)
      mpres0@Ystart              = loc(1,0)
      mpres0@Yend                = loc(1,1)

;------------- For Precipitation -----------------
      opts1                       = res
      opts1@cnFillOn              = True
      opts1@cnLinesOn             = False
      opts1@tmXBLabelFontHeightF  = 0.01
      opts1@tmYLLabelFontHeightF  = 0.01
      opts1@pmLabelBarHeightF     = 0.2
      opts1@pmLabelBarWidthF      = 0.45
      opts1@cnLevelSelectionMode  = "ExplicitLevels"
      opts1@cnLevels              = (/ 1,2,3,5,10,15,20,25,30 /)
      opts1@pmLabelBarParallelPosF    = 0.5
      opts1@pmLabelBarOrthogonalPosF  = -0.1
      opts1@lbLabelFontHeightF        = 0.012
      opts1@lbLabelStride             = 1
      opts1@lbTitleString             = "Total Precipitation [mm]"
      opts1@lbTitleFontHeightF        = 0.013
      opts1@lbBoxSeparatorLinesOn     = False
    
;------------- For Pressure -----------------
      opts2                       = res
      opts2@cnFillOn              = False
      opts2@cnLinesOn             = True
      opts2@cnLineColor           = "black"
      opts2@cnLineThicknessF      = 2.0
      opts2@cnLevelSelectionMode  = "ManualLevels"
      opts2@cnLevelSpacingF       = 4.0
      ; opts2@cnMaxLevelValF        = 1020.0
      ; opts2@cnMinLevelValF        = 960.0
      opts2@cnHighLabelsOn        = True
      opts2@cnLowLabelsOn         = True
      opts2@cnInfoLabelOn         = False
      opts2@cnLineLabelFontHeightF        = 0.007
      opts2@cnHighLabelBackgroundColor    = -1
      opts2@cnHighLabelFontHeightF        = 0.01
      opts2@cnLowLabelBackgroundColor     = -1
      opts2@cnLowLabelFontHeightF         = 0.01

      plot1 = wrf_contour(in,wks,Rain(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),opts1)
      plot2 = wrf_contour(in,wks,MSLP(loc(1,0):loc(1,1),loc(0,0):loc(0,1)),opts2)
      
      print("time: " + time(i))
      plot = wrf_map_overlays(in,wks,(/plot1, plot2/),pltres,mpres0)

      t = t + 1

    end do

    RainP = in->RAINNC(dims(0)-1,:,:)

  end do

end