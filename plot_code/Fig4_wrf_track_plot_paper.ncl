;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir1   = "./outputs_cpl_oa.gls/"
  FILES1 = systemfunc (" ls -1 " + Dir1 + "wrfout_d01_2018-01-*00 ")
  Dir2   = "./outputs_cpl_owa.gls/"
  FILES2 = systemfunc (" ls -1 " + Dir2 + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES1)

;------------- Map Attributes -----------------
  pltres  = True
  ; pltres@NoTitles               = True
  
  mpres0  = True
  mpres0@mpGeophysicalLineColor = "Black"
  mpres0@mpNationalLineColor    = "Black"
  mpres0@mpUSStateLineColor     = "Black"
  mpres0@mpGeophysicalLineThicknessF = 2.5

;------------- Reading Text Data -----------------
  Nc = 49
  cyclone_file1 = Dir1 + "Cyclone_center.txt"
  cyclone_file2 = Dir2 + "Cyclone_center.txt"
  cyclone_cfsr  = "cfsr_cyclone.txt"
  
  CC1  = new((/Nc,2/), "float")
  CC2  = new((/Nc,2/), "float")
  CCF  = new((/Nc,3/), "float")

  tmp := readAsciiTable(cyclone_file1, 3, "float", 1)
  CC1  = tmp(:,1:2)
  tmp := readAsciiTable(cyclone_file2, 3, "float", 1)
  CC2  = tmp(:,1:2)
  tmp := readAsciiTable(cyclone_cfsr, 4, "float", 1)
  CCF  = tmp(:,1:3)

;************************************************
;  File Loop
;************************************************
  j = 0
  Track1 = new((/Nc, 3/), "float")
  Track2 = new((/Nc, 3/), "float")
  TrackF = new((/Nc, 3/), "float")
  do ifil = 2, 4, 1
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

;************************************************
; Date Loop
;************************************************
    do i=0, dims(0)-1, 1
      if (ifil.eq.2 .and. i.eq.0) then
        i = 18
      end if
      iMSLP1 = wrf_user_getvar(in1,"slp",i)
      lmin_v = rcm2points(lat,lon,iMSLP1, CC1(j,1),CC1(j,0),0)
      Track1(j,:) = (/ lmin_v, CC1(j,0), CC1(j,1) /)

      iMSLP2 = wrf_user_getvar(in2,"slp",i)
      lmin_v = rcm2points(lat,lon,iMSLP2, CC2(j,1),CC2(j,0),0)
      Track2(j,:) = (/ lmin_v, CC2(j,0), CC2(j,1) /)

      TrackF(j,:) = (/ CCF(j,0), CCF(j,1), CCF(j,2) /)

      if (j .eq. Nc-1) then
        break
      end if
      j = j + 1
    end do
  end do

;************************************************
; create default plot
;************************************************
  imgName = "img/Cyclone201801_Track_AWO_paper"
  wks_type                   = "png"
  wks_type@wkHeight          = 960
  wks_type@wkWidth           = 960
  wks = gsn_open_wks(wks_type, imgName)

  res                        = True
  ; res@gsnDraw                = False
  res@gsnFrame               = False
  res@tfPolyDrawOrder        = "PostDraw"
  res@tiMainString           = "Cyclone Track (201801)"
  res@tiMainFontHeightF      = 0.016
  res@gsnMaximize            = True
  res@mpDataBaseVersion      = "MediumRes"
  res@mpProjection           = "LambertConformal"
  res@mpLimitMode            = "Corners"
  res@mpLeftCornerLatF       = 25.
  res@mpLeftCornerLonF       = 278.
  res@mpRightCornerLatF      = 52.
  res@mpRightCornerLonF      = 303.
  res@mpLambertParallel1F    = 30.
  res@mpLambertParallel2F    = 50.
  res@mpLambertMeridianF     = 280.
  res@mpGridLatSpacingF      = 5.
  res@mpGridLonSpacingF      = 5.
  res@pmTickMarkDisplayMode  = "Always"
  
  res@mpGridAndLimbOn        = True
  res@mpShapeMode            = "FreeAspect"
  res@vpWidthF               = 0.4
  res@vpHeightF              = 0.6
  res@tiMainOffsetYF         = -0.01
  res@mpGeophysicalLineThicknessF   = 3.0

  map = gsn_csm_map(wks,res)
     
;--------- Cyclone Center Track -------------
  plres1                      = True
  plres1@gsLineColor          = "red2"
  plres1@gsLineThicknessF     =  5.0
  pmres1                      = True
  pmres1@gsMarkerColor        = "red2"
  pmres1@gsMarkerSizeF        =  0.02
  pmres1@gsMarkerThicknessF   =  4.5
  pmres1@gsMarkerIndex        =  1
;--------- Cyclone Center Track -------------
  plres2                      = True
  plres2@gsLineColor          = "blue2"
  plres2@gsLineThicknessF     =  5.0
  pmres2                      = True
  pmres2@gsMarkerColor        = "blue2"
  pmres2@gsMarkerSizeF        =  0.02
  pmres2@gsMarkerThicknessF   =  4.5
  pmres2@gsMarkerIndex        =  1
;--------- Cyclone Center Track -------------
  plresF                      = True
  plresF@gsLineColor          = "black"
  plresF@gsLineThicknessF     =  5.0
  pmresF                      = True
  pmresF@gsMarkerColor        = "black"
  pmresF@gsMarkerSizeF        =  0.02
  pmresF@gsMarkerThicknessF   =  4.5
  pmresF@gsMarkerIndex        =  1

;***********************************************
; legend resources
;***********************************************
  lgres                    = True
  lgres@lgLineColors       = (/"red2","blue2","black"/)
  lgres@lgItemOrder        = (/2,1,0/)
  lgres@vpWidthF           = 0.15
  lgres@vpHeightF          = 0.10
  lgres@lgPerimOn          = True
  lgres@lgLabelFontHeightF = 0.06
  lgres@lgLineThicknessF   = 4.0
  lgres@lgMonoDashIndex    = True
  lgres@lgPerimFill        = 0

  gsn_polymarker(wks, map, Track1(0:44,1), Track1(0:44,2), pmres1)
  gsn_polyline(wks, map, Track1(0:44,1), Track1(0:44,2), plres1)
  gsn_polymarker(wks, map, Track2(0:44,1), Track2(0:44,2), pmres2)
  gsn_polyline(wks, map, Track2(0:44,1), Track2(0:44,2), plres2)
  gsn_polymarker(wks, map, TrackF(0:44,1), TrackF(0:44,2), pmresF)
  gsn_polyline(wks, map, TrackF(0:44,1), TrackF(0:44,2), plresF)

  gsn_legend_ndc(wks,3,(/"AWO","AO","CFSv2"/),0.25,0.85,lgres)
  ; draw(map)
  frame(wks)

end
