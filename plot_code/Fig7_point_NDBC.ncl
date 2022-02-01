;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
;************************************************
begin
  
  NDBCtx = (/ "LaHave Bank", "East Scotia Slope", "Jordan Basin", "Massachusetts Bay", "Nantucket", \
              "Long Island", "Texas Tower", "Virginia Beach" /)
  xi = (/ 64.02, 62.0, 67.88, 70.566, 69.248, 73.164, 72.586, 74.843 /)
    xi = 360.0 - xi
  yi = (/ 42.5, 42.26, 43.491, 42.523, 40.504, 40.251, 39.568, 36.611 /)

;************************************************
; create default plot
;************************************************
  imgName = "NDBC_BuoyMap02"
  wks = gsn_open_wks("png", imgName)

  res                        = True               ; plot mods desired
  res@tiMainString           = "NDBC Observation Points"
  res@tiMainFontHeightF      = 0.016
  res@mpDataBaseVersion      = "MediumRes"
  res@mpProjection           = "LambertConformal"
  res@mpLimitMode            = "Corners"
  res@mpLeftCornerLatF       = 33.
  res@mpLeftCornerLonF       = 282.
  res@mpRightCornerLatF      = 47.
  res@mpRightCornerLonF      = 303.
  res@mpLambertParallel1F    = 30.
  res@mpLambertParallel2F    = 45.
  res@mpLambertMeridianF     = 290.
  res@mpGridLatSpacingF      = 5.
  res@mpGridLonSpacingF      = 5.
  res@tmXTLabelsOn           = False
  res@tmYRLabelsOn           = False

  res@gsnMaximize            = True
  res@mpGridAndLimbOn        = True
  res@gsnDraw                = False
  res@gsnFrame               = False
  res@mpShapeMode            = "FreeAspect"
  res@vpWidthF               = 0.6
  res@vpHeightF              = 0.4
  res@pmTickMarkDisplayMode  = "Always"
  res@tmXBLabelFontHeightF   = 0.01
  res@tmYLLabelFontHeightF   = 0.01
  res@mpGeophysicalLineThicknessF   = 3.0
  
;------------- NDBC Point Text -----------------
  txres1                       = True
  txres1@txFontHeightF         = 0.014
  txres1@txFontColor           = "black"
  txres1@txFontThicknessF      = 2.0
  
;--------- NDBC Point 1 -------------
  pmres1                       = True
  pmres1@gsMarkerColor         = "red3"
  pmres1@gsMarkerSizeF         =  0.01
  pmres1@gsMarkerThicknessF    =  4.5
  pmres1@gsMarkerIndex         =  16

;--------- NDBC Point 2 -------------
  pmres2                       = True
  pmres2@gsMarkerColor         = "black"
  pmres2@gsMarkerSizeF         =  0.01
  pmres2@gsMarkerThicknessF    =  4.5
  pmres2@gsMarkerIndex         =  16

  plot    = gsn_csm_map(wks,res)
  
  text1   = gsn_add_text(wks, plot, NDBCtx(0), xi(0)+1.3, yi(0)+0.4, txres1)
  text2   = gsn_add_text(wks, plot, NDBCtx(1:7), xi(1:7)+1.2, yi(1:7)-0.36, txres1)
  marker1 = gsn_add_polymarker(wks, plot, xi(0), yi(0), pmres1)
  marker2 = gsn_add_polymarker(wks, plot, xi(1:7), yi(1:7), pmres2)

  draw(plot)
  frame(wks)

end