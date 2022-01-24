;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir1  = "./outputs_cpl_ow.gls/"
  Dir2  = "./outputs_frc_croco.gls/"
  fName1 = Dir1 + "croco_density.nc"
  fName2 = Dir2 + "croco_density.nc"
  in1 = addfile(fName1, "w")
  in2 = addfile(fName2, "w")
  in_CFSR = addfile("prmsl.gdas.201801.grb","r")
  
  dims = getfiledimsizes(in1)
  depth = in1->depth
  lat_rho = in1->lat_rho
  lon_rho = in1->lon_rho

  do i=0, dims(0)-1, 2                 ; ***** Begin Data Loop *****
    time  := in1->time(i)
    itime  = cd_calendar(time, -3)
    mld1  := in1->mld(i,:,:)
      mld1&lat_rho = lat_rho
      mld1&lon_rho = lon_rho
    mld2  := in2->mld(i,:,:)
    mld_diff := mld1
      mld_diff = mld_diff - mld2
      mld_diff@long_name = "MLD Difference"
      mld_diff@units = "m"
    
    ic  = 12 + i/2
    icf = mod(i,2) * 3
    iMSLP = in_CFSR->PRMSL_GDS0_MSL(ic,icf,:,:)
      iMSLP = iMSLP / 100.

;************************************************
; create default plot
;************************************************
    imgName = "img/OW-O.GLS_MLD_" + itime
    wks_type                   = "png"
    wks_type@wkHeight          = 960
    wks_type@wkWidth           = 960
    wks = gsn_open_wks(wks_type, imgName)
    gsn_define_colormap(wks,"MPL_PiYG")
    gsn_reverse_colormap(wks)

    res                        = True
    res@tiMainString           = "WO-O: Mixed Layer Depth (GLS)"
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
    res@tiMainOffsetYF         = -0.01
    res@mpGeophysicalLineThicknessF   = 3.0
    res@gsnCenterStringFontHeightF    = 0.016
    res@gsnCenterStringOrthogonalPosF = 0.018
  
;------------- For Temperature -----------------
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
    opts1@pmLabelBarWidthF      = 0.46
    opts1@cnLevelSelectionMode  = "ManualLevels"
    opts1@cnLevelSpacingF       = 8.0
    opts1@cnMaxLevelValF        = 32.0
    opts1@cnMinLevelValF        = -32.0
    opts1@pmLabelBarParallelPosF   = 0.5
    opts1@pmLabelBarOrthogonalPosF = 0.04
    opts1@lbLabelFontHeightF       = 0.013
    opts1@lbLabelStride            = 2
    opts1@lbTitleString            = mld_diff@long_name + " [" + mld_diff@units + "]"
    opts1@lbTitleFontHeightF       = 0.015
    opts1@lbBoxSeparatorLinesOn    = False
  
;------------- For Pressure -----------------
    opts2                       = True
    opts2@gsnDraw               = False
    opts2@gsnFrame              = False
    opts2@gsnRightString        = ""
    opts2@gsnLeftString         = ""
    opts2@cnFillOn              = False
    opts2@cnLinesOn             = True
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

    plot    = gsn_csm_contour_map(wks,mld_diff,opts1)
    plot2   = gsn_csm_contour(wks,iMSLP,opts2)
    overlay(plot,plot2)
    
    print("i=" + i + "; time: UTC " + itime)
    draw(plot)
    frame(wks)

  end do
  
end