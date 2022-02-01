;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir = "./Data/2018/"
  FILES  = systemfunc (" ls -1 " + Dir + "hycom_glbv_2018????12_t0??_ts3z.nc")
  FILES2 = systemfunc (" ls -1 " + Dir + "hycom_glbv_2018????12_t0??_uv3z.nc")
  numFILES = dimsizes(FILES)
  
  k = 0
  z = 0
  ; do f = 4, 4, 1                 ; ***** Begin File Loop *****
  do f = 3, numFILES-1, 1                 ; ***** Begin File Loop *****
    fName1 = FILES(f)+".nc"
    fName2 = FILES2(f)+".nc"
    in1    = addfile(fName1,"r")
    in2    = addfile(fName2,"r")

    dims = getfiledimsizes(in1)
    time = in1->time
    lat  = in1->lat
    lon  = in1->lon
    depth  = in1->depth
    T   := short2flt(in1->water_temp(0,z,:,:))
      T@long_name = "Water Temperature"
      T@units = "C"
    U   := short2flt(in2->water_u(0,z,:,:))
    V   := short2flt(in2->water_v(0,z,:,:))
    ; printVarSummary(U)

    itime = cd_calendar(time, -3)

    Cur = sqrt(U^2 + V^2)
      copy_VarAtts(U, Cur)
      copy_VarCoords(U, Cur)
      Cur@long_name = "Current Speed"

;************************************************
; create default plot
;************************************************
    wks_type                   = "png"
    wks_type@wkHeight          = 960
    wks_type@wkWidth           = 960
    imgName = "img/GOFS_t_uv" + itime
    wks = gsn_open_wks(wks_type, imgName)
    gsn_define_colormap(wks,"NCV_jet")

    res                        = True
    res@tiMainString           = "GOFS: SST, Current"
    res@tiMainFontHeightF      = 0.016
    res@mpDataBaseVersion      = "MediumRes"
    res@mpProjection           = "LambertConformal"
    res@mpLimitMode            = "Corners"
    res@mpLeftCornerLatF       = 22.
    res@mpLeftCornerLonF       = -85.
    res@mpRightCornerLatF      = 53.
    res@mpRightCornerLonF      = -23.
    res@mpLambertParallel1F    = 25.
    res@mpLambertParallel2F    = 45.
    res@mpLambertMeridianF     = -70.
    res@pmTickMarkDisplayMode  = "Always"
    res@tmXBLabelFontHeightF   = 0.01
    res@tmYLLabelFontHeightF   = 0.01
    res@pmLabelBarHeightF      = 0.06
    res@pmLabelBarWidthF       = 0.48
    res@tmXTLabelsOn           = False
    res@tmYRLabelsOn           = False

    res@mpGridAndLimbOn        = True
    res@gsnCenterString        = "UTC " + itime
    res@mpShapeMode            = "FreeAspect"
    res@vpWidthF               = 0.6
    res@vpHeightF              = 0.5
    res@gsnAddCyclic           = False
    res@gsnMaximize            = True
    res@gsnSpreadColors        = True
    res@gsnCenterStringFontHeightF    = 0.014
    res@mpGeophysicalLineThicknessF   = 3.0

;------------- For Current Speed -----------------
    opts1                       = res
    opts1@gsnDraw               = False
    opts1@gsnFrame              = False
    opts1@gsnRightString        = ""
    opts1@gsnLeftString         = ""
    opts1@cnFillOn              = True
    opts1@cnLinesOn             = False
    opts1@tiXAxisString         = ""
    opts1@tiYAxisString         = ""
    opts1@cnLevelSelectionMode  = "ManualLevels"
    opts1@cnLevelSpacingF       = 1.0
    opts1@cnMaxLevelValF        = 30.0
    opts1@cnMinLevelValF        = 0.0
    opts1@cnFillOpacityF        = 0.6
    opts1@pmLabelBarParallelPosF   = 0.4
    opts1@pmLabelBarOrthogonalPosF = 0.02
    opts1@lbLabelFontHeightF       = 0.011
    opts1@lbLabelStride            = 3
    opts1@lbTitleString            = T@long_name + " [" + T@units + "]"
    opts1@lbTitleFontHeightF       = 0.013
    opts1@lbBoxSeparatorLinesOn    = False

;------------- For Current Vector -----------------
    opts2                       = True
    opts2@gsnDraw               = False
    opts2@gsnFrame              = False
    opts2@gsnRightString        = ""
    opts2@gsnLeftString         = ""
    opts2@vcFillArrowWidthF     = 0.2
    opts2@vcLevelSelectionMode  = "ManualLevels"
    opts2@vcMinMagnitudeF       = 0.4
    opts2@vcRefMagnitudeF       = 1.0
    opts2@vcRefAnnoString1      = "1.0 m/s"
    opts2@vcRefLengthF          = 0.025
    opts2@vcGlyphStyle          = "LineArrow"
    opts2@vcLineArrowColor      = "black"
    opts2@vcLineArrowThicknessF = 2.0
    opts2@vcRefAnnoArrowUseVecColor  = False
    opts2@vcRefAnnoOrthogonalPosF    = -0.12
    opts2@vcRefAnnoParallelPosF      = 0.97
    opts2@vcRefAnnoString2           = "Current"

    plot    = gsn_csm_contour_map(wks,T,opts1)
    plot2   = gsn_csm_vector(wks,U(::12,::12),V(::12,::12),opts2)
    overlay(plot,plot2)

    print("k=" + k + ";  UTC " + itime)
    draw(plot)
    frame(wks)

    k = k + 1
  end do

end