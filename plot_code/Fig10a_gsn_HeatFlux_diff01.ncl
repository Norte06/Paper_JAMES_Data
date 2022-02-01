;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir1  = "./outputs_cpl_aw/"
  FILES1 = systemfunc (" ls -1 " + Dir1 + "wrfout_d01_2018-01-*00 ")
  ; Dir2  = "./outputs_cpl_oa.gls/"
  Dir2 = "./outputs_frc_wrf/"
  FILES2 = systemfunc (" ls -1 " + Dir2 + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES1)

;************************************************
;  File Loop
;************************************************
  do ifil = 3, 4, 1
  ; do ifil = 1, numFILES-1, 1
    fName1 = FILES1(ifil)+".nc"
    fName2 = FILES2(ifil)+".nc"
    in1 = addfile(fName1,"r")
    in2 = addfile(fName2,"r")

    dims = getfiledimsizes(in1)
    lat  = in1->XLAT(0,:,0)
    lon  = in1->XLONG(0,0,:)
    lev  = wrf_user_getvar(in1,"pressure",0)
    time = wrf_user_getvar(in1,"times",-1)
    TimeChar := in1->Times
    timestr  := wrf_times_c(TimeChar,3)
  
;************************************************
; Date Loop
;************************************************
    do i=0, dims(0)-1, 3
      MSLP = (/ wrf_user_getvar(in1,"slp",i) /)
        MSLP!0 = "lat"
        MSLP!1 = "lon"
        MSLP&lat  = lat
        MSLP&lon  = lon
      LH1  = in1->LH(i,:,:)
      SH1  = in1->HFX(i,:,:)
      LH2  = in2->LH(i,:,:)
      SH2  = in2->HFX(i,:,:)
    
      Heat_diff = (LH1+SH1) - (LH2+SH2)
      ; Heat_diff = LH1 - LH2
        copy_VarCoords(MSLP, Heat_diff)
        copy_VarAtts(MSLP, Heat_diff)
        Heat_diff@long_name = "Latent & Sensible Heat Difference"
        Heat_diff@units = "W/m~S~2~N~"
    
;************************************************
; create default plot
;************************************************
      imgName = "img/AW-A.MYNN_Heat_" + timestr(i)
      wks_type                   = "png"
      wks_type@wkHeight          = 960
      wks_type@wkWidth           = 960
      wks = gsn_open_wks(wks_type, imgName)
      gsn_define_colormap(wks,"MPL_PuOr")
      gsn_reverse_colormap(wks)

      res                        = True
      res@tiMainString           = "AW-A: HeatFlux Difference (MYNN)"
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
      opts1@cnLevelSpacingF       = 50.
      opts1@cnMaxLevelValF        = 500.0
      opts1@cnMinLevelValF        = -500.0
      opts1@pmLabelBarParallelPosF   = 0.5
      opts1@pmLabelBarOrthogonalPosF = -0.0
      opts1@lbLabelFontHeightF       = 0.013
      opts1@lbLabelStride            = 5
      opts1@lbTitleString            = Heat_diff@long_name + " [" + Heat_diff@units + "]"
      opts1@lbTitleFontHeightF       = 0.015
      opts1@lbBoxSeparatorLinesOn    = False
    
;------------- For Pressure -----------------
      opts2                       = True
      opts2@gsnDraw               = False
      opts2@gsnFrame              = False
      opts2@cnFillOn              = False
      opts2@cnLinesOn             = True
      opts2@gsnRightString        = ""
      opts2@gsnLeftString         = ""
      opts2@cnLineColor           = "black"
      opts2@cnLineThicknessF      = 3.0
      opts2@cnLevelSelectionMode  = "ManualLevels"
      opts2@cnLevelSpacingF       = 4.0
      ; opts2@cnMaxLevelValF        = 1020.0
      ; opts2@cnMinLevelValF        = 960.0
      opts2@cnHighLabelsOn        = True
      opts2@cnLowLabelsOn         = True
      opts2@cnInfoLabelOn         = False
      opts2@cnLineLabelFontHeightF        = 0.01
      opts2@cnHighLabelBackgroundColor    = -1
      opts2@cnHighLabelFontHeightF        = 0.012
      opts2@cnLowLabelBackgroundColor     = -1
      opts2@cnLowLabelFontHeightF         = 0.012
      
      plot    = gsn_csm_contour_map(wks,Heat_diff,opts1)
      plot2   = gsn_csm_contour(wks,MSLP,opts2)
      overlay(plot,plot2)

      print("i=" + i + ";  time: UTC " + timestr(i))
      draw(plot)
      frame(wks)

    end do
  end do

end
