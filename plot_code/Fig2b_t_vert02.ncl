;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir = "./Data/2018/"
  FILES  = systemfunc (" ls -1 " + Dir + "hycom_glbv_2018????12_t0??_ts3z.nc")
  numFILES = dimsizes(FILES)

  L    = 12*8
  LAT  = 39.0
  LON  = 299.0
  LON2 = 360 - LON
  do f = 3, 3, 1                 ; ***** Begin File Loop *****
  ; do f = 0, numFILES-1, 1                 ; ***** Begin File Loop *****
    fName1 = FILES(f)+".nc"
    in1    = addfile(fName1,"r")

    dims = getfiledimsizes(in1)
    time = in1->time
    lat  = in1->lat
    lon  = in1->lon
    depth  = in1->depth

    xi = ind_nearest_coord(LON, lon, 0)
    yi = ind_nearest_coord(LAT, lat, 0)

    T   := short2flt(in1->water_temp(0,:,yi-L:yi+L,xi))
      T@units = "~S~o~N~C"
    itime = cd_calendar(time, -3)

;************************************************
; create default plot
;************************************************
    wks_type                   = "png"
    wks_type@wkHeight          = 960
    wks_type@wkWidth           = 960
    imgName = "img/GOFS_t_vert(lon" + LON2 + "W)_" + itime
    wks = gsn_open_wks(wks_type, imgName)
    gsn_define_colormap(wks,"NCV_jet")

    res                        = True
    res@tiMainString           = "GOFS: Temp Profile UTC" + itime
    res@tiMainFontHeightF      = 0.016
    res@pmTickMarkDisplayMode  = "Always"
    res@pmLabelBarHeightF      = 0.06
    res@pmLabelBarWidthF       = 0.48

    res@gsnCenterString        = "Center: " + sprintf("%4.1f", LON2) + "W " + sprintf("%5.1f", LON) + "E"
    res@vpWidthF               = 0.6
    res@vpHeightF              = 0.4
    res@gsnAddCyclic           = False
    res@gsnMaximize            = True
    res@gsnSpreadColors        = True
    res@tiXAxisString          = "Latitude"
    res@tiYAxisString          = "Depth[m]"
    res@trYReverse             = True
    res@trYMaxF                = 300.0
    res@trYMinF                = 0.0
    res@tmXBLabelFontHeightF   = 0.01
    res@tmYLLabelFontHeightF   = 0.01
    res@tiXAxisFontHeightF     = 0.012
    res@tiYAxisFontHeightF     = 0.012
    res@tiXAxisOffsetYF        = 0.16
    res@gsnXAxisIrregular2Linear       = True
    res@gsnYAxisIrregular2Linear       = True
    res@gsnCenterStringFontHeightF     = 0.014

;------------- For Current Speed -----------------
    opts1                       = res
    opts1@gsnDraw               = False
    opts1@gsnFrame              = False
    opts1@gsnRightString        = ""
    opts1@gsnLeftString         = ""
    opts1@cnFillOn              = True
    opts1@cnLinesOn             = False
    opts1@cnLevelSelectionMode  = "ManualLevels"
    opts1@cnLevelSpacingF       = 0.5
    opts1@cnMaxLevelValF        = 30.0
    opts1@cnMinLevelValF        = 0.0
    opts1@lbLabelFontHeightF    = 0.011
    opts1@lbLabelStride         = 6
    opts1@lbTitleString         = T@long_name + " [" + T@units + "]"
    opts1@lbTitleFontHeightF    = 0.013
    opts1@lbBoxSeparatorLinesOn         = False
    opts1@pmLabelBarParallelPosF        = 0.5
    opts1@pmLabelBarOrthogonalPosF      = 0.07

    plot    = gsn_csm_contour(wks,T,opts1)
    print("  UTC " + itime)
    draw(plot)
    frame(wks)

  end do
end
