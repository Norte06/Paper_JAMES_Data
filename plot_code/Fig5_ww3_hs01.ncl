;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir = "./outputs_cpl_owa.gls/"
  ; Dir = "./outputs_frc_ww3/"
  fName = Dir + "ww3.201801.nc"
  in = addfile(fName, "r")
  fName_wrf = Dir + "wrfout_d01_2018-01-04_00:00:00_ww3grid.nc"
  in_wrf = addfile(fName_wrf, "r")
  ifil = 3
  
  dims = getfiledimsizes(in)
  time = in->time
  lat  = in->latitude
  lon  = in->longitude
  Hs   = in->hs
  Dp   = in->dp
  ; printVarSummary(Hs)
  
  j = 0
  ids  = ifil*24
  ide  = (ifil+1)*24-1
  PI   = acos(-1)
  date = cd_calendar(time, -3)
  do i=ids, ide, 3                 ; ***** Begin Data Loop *****
  ; do i=72, 108, 3                 ; ***** Begin Data Loop *****
    itime = date(i)
    iHs := Hs(i,:,:)
      iHs@long_name = "Significant Wave Height"
    iDp := Dp(i,:,:)
    iMSLP := in_wrf->MSLP(j,:,:)
      copy_VarCoords(iDp, iMSLP)
      copy_VarMeta(iDp, iMSLP)
      iMSLP@long_name = "Sea Level Pressure"
      iMSLP@unist = "hPa"

    iDpx = iDp
    ; iDpx = -10.0 * cos((iDp-90.0)/180.*PI)
    iDpx = 10.0 * cos((270.0-iDp)/180.*PI)
    iDpy = iDp
    ; iDpy = 10.0 * sin((iDp-90.0)/180.*PI)
    iDpy = 10.0 * sin((270.0-iDp)/180.*PI)

;************************************************
; create default plot
;************************************************
    imgName = "img/OWA.MYNN.GLS_Hs_" + itime
    wks_type                   = "png"
    wks_type@wkHeight          = 960
    wks_type@wkWidth           = 960
    wks = gsn_open_wks(wks_type, imgName)
    gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")

    res                        = True
    res@tiMainString           = "Wave Height (AWO,MYNN,GLS)"
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
    res@gsnCenterString        = itime
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
    opts1@cnMaxLevelValF        = 15.0
    opts1@cnMinLevelValF        = 1.0
    opts1@pmLabelBarParallelPosF   = 0.4
    opts1@pmLabelBarOrthogonalPosF = 0.04
    opts1@lbLabelFontHeightF       = 0.013
    opts1@lbLabelStride            = 4
    opts1@lbTitleString            = iHs@long_name + " [" + iHs@units + "]"
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
    opts2@vcRefLengthF          = 0.015
    opts2@vcRefAnnoOn           = True
    opts2@vcRefAnnoString1      = ""
    opts2@vcRefAnnoString2      = "Peak Dir"
    opts2@vcRefAnnoOrthogonalPosF    = -0.10
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
    
    plot    = gsn_csm_contour_map(wks,iHs,opts1)
    plot2   = gsn_csm_vector(wks,iDpx(::24,::24),iDpy(::24,::24),opts2)
    plot3   = gsn_csm_contour(wks,iMSLP,opts3)
    overlay(plot,plot2)
    overlay(plot,plot3)

    print("i=" + i + ";  time: UTC " + itime)
    draw(plot)
    frame(wks)
    j = j + 1
    
  end do
  
end
