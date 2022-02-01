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

;************************************************
;  File Loop
;************************************************
  do ifil = 3, 4, 1
  ; do ifil = 1, numFILES-1, 1
    fName = FILES(ifil)+".nc"
    in = addfile(fName,"r")

    dims = getfiledimsizes(in)
    lat  = in->XLAT(0,:,0)
    lon  = in->XLONG(0,0,:)
    lev  = wrf_user_getvar(in,"pressure",0)
    time = wrf_user_getvar(in,"times",-1)
    TimeChar := in->Times
    timestr  := wrf_times_c(TimeChar,3)

;************************************************
; Date Loop
;************************************************
    do i=0, dims(0)-1, 3
      MSLP = (/ wrf_user_getvar(in,"slp",i) /)
        MSLP!0 = "lat"
        MSLP!1 = "lon"
        MSLP&lat  = lat
        MSLP&lon  = lon
      U    = wrf_user_getvar(in,"U10",i)
      V    = wrf_user_getvar(in,"V10",i)
      Wind = sqrt(U^2+V^2)
        copy_VarCoords(MSLP, Wind)
        Wind@long_name = "Wind Speed at 10m height"
        Wind@units = "m/s"
    
;************************************************
; create default plot
;************************************************
      imgName = "img/OWA.MYNN.GLS_Wind2_" + timestr(i)
      wks_type                   = "png"
      wks_type@wkHeight          = 960
      wks_type@wkWidth           = 960
      wks = gsn_open_wks(wks_type, imgName)
      gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")

      res                        = True
      res@tiMainString           = "Surface Wind Height (AWO,MYNN,GLS)"
      res@tiMainFontHeightF      = 0.018
      res@mpDataBaseVersion      = "MediumRes"
      res@mpProjection           = "LambertConformal"
      res@mpLimitMode            = "Corners"
      res@mpLeftCornerLatF       = 24.
      res@mpLeftCornerLonF       = 277.
      res@mpRightCornerLatF      = 50.
      res@mpRightCornerLonF      = 316.
      res@mpLambertParallel1F    = 30.
      res@mpLambertParallel2F    = 45.
      res@mpLambertMeridianF     = 295.
      res@pmTickMarkDisplayMode  = "Always"
      res@tmXTOn                 = False
      res@tmYROn                 = False

      res@mpGridAndLimbOn        = True
      res@gsnCenterString        = timestr(i)
      res@mpShapeMode            = "FreeAspect"
      res@vpWidthF               = 0.6
      res@vpHeightF              = 0.5
      res@gsnAddCyclic           = False
      res@tiMainOffsetYF         = -0.0
      res@mpGeophysicalLineThicknessF   = 2.5
      res@gsnCenterStringFontHeightF    = 0.016
      res@gsnCenterStringOrthogonalPosF = 0.018
  
;------------- For Wave Height -----------------
      opts1                       = res
      opts1@gsnDraw               = False
      opts1@gsnFrame              = False
      opts1@gsnRightString        = ""
      opts1@gsnLeftString         = ""
      opts1@cnFillOn              = True
      opts1@cnLinesOn             = False
      opts1@gsnMaximize           = True
      opts1@gsnSpreadColors       = True
      opts1@tmXBLabelFontHeightF  = 0.012
      opts1@tmYLLabelFontHeightF  = 0.012
      opts1@pmLabelBarHeightF     = 0.08
      opts1@pmLabelBarWidthF      = 0.4
      opts1@cnLevelSelectionMode  = "ManualLevels"
      opts1@cnLevelSpacingF       = 0.5
      opts1@cnMaxLevelValF        = 35.0
      opts1@cnMinLevelValF        = 5.0
      opts1@pmLabelBarParallelPosF   = 0.4
      opts1@pmLabelBarOrthogonalPosF = 0.04
      opts1@lbLabelFontHeightF       = 0.013
      opts1@lbLabelStride            = 5
      opts1@lbTitleString            = Wind@long_name + " [" + Wind@units + "]"
      opts1@lbTitleFontHeightF       = 0.015
      opts1@lbBoxSeparatorLinesOn    = False
    
;------------- For Wave Direction -----------------
      opts2                       = True
      opts2@gsnDraw               = False
      opts2@gsnFrame              = False
      opts2@gsnMaximize           = True
      opts2@tmXBLabelFontHeightF  = 0.01
      opts2@tmYLLabelFontHeightF  = 0.01
      opts2@gsnRightString        = ""
      opts2@gsnLeftString         = ""
      opts2@vcFillArrowWidthF     = 0.2
      opts2@vcRefAnnoOn           = True
      opts2@vcMinMagnitudeF       = 10.0
      opts2@vcRefLengthF          = 0.03
      opts2@vcRefMagnitudeF       = 25.0
      opts2@vcRefAnnoString1      = "25 m/s"
      opts2@vcRefAnnoString2      = "Direction"
      opts2@vcRefAnnoOrthogonalPosF    = -0.13
      opts2@vcRefAnnoParallelPosF      = 0.9
    
;------------- For Pressure -----------------
      opts3                       = True
      opts3@gsnDraw               = False
      opts3@gsnFrame              = False
      opts3@cnFillOn              = False
      opts3@cnLinesOn             = True
      opts3@gsnRightString        = ""
      opts3@gsnLeftString         = ""
      opts3@cnLineColor           = "black"
      opts3@cnLineThicknessF      = 3.0
      opts3@cnLevelSelectionMode  = "ManualLevels"
      opts3@cnLevelSpacingF       = 4.0
      ; opts3@cnMaxLevelValF        = 1020.0
      ; opts3@cnMinLevelValF        = 960.0
      opts3@cnHighLabelsOn        = True
      opts3@cnLowLabelsOn         = True
      opts3@cnInfoLabelOn         = False
      opts3@cnLineLabelFontHeightF        = 0.01
      opts3@cnHighLabelBackgroundColor    = -1
      opts3@cnHighLabelFontHeightF        = 0.012
      opts3@cnLowLabelBackgroundColor     = -1
      opts3@cnLowLabelFontHeightF         = 0.012
      
      plot    = gsn_csm_contour_map(wks,Wind,opts1)
      plot2   = gsn_csm_vector(wks,U(::24,::24),V(::24,::24),opts2)
      plot3   = gsn_csm_contour(wks,MSLP,opts3)
      overlay(plot,plot2)
      overlay(plot,plot3)

      print("i=" + i + ";  time: UTC " + timestr(i))
      draw(plot)
      frame(wks)

    end do
  end do

end
