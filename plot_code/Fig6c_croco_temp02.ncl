;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir   = "./outputs_cpl_owa.gls/"
  FILES  = systemfunc (" ls -1 " + Dir + "croco_his.0???.nc")
  numFILES = dimsizes(FILES)
  fName_wrf = Dir + "wrfout_d01_2018-01-05_00:00:00_crocogrid.nc"
  in_wrf = addfile(fName_wrf, "r")
  ifilA = 4

  fName1 = Dir + "croco_his.0000.nc"
  in1 = addfile(fName1, "r")

  dims = getfiledimsizes(in1)
  lat_rho = in1->lat_rho(:,0)
  lon_rho = in1->lon_rho(0,:)
  s_rho   = in1->s_rho

;************************************************
;  File Loop
;************************************************
  j = 0
  ; do ifil = 0, numFILES-1, 1
  do ifil = ifilA, ifilA, 1
    fName2 = FILES(ifil)
    in2 = addfile(fName2, "r")
  
    time := in2->time
      time@units = "seconds since 2010-01-01 00:00:00"
    T    := in2->temp
    
    date = cd_calendar(time, -3)
    s    = 31
    do i=0, dims(7)-1, 1                 ; ***** Begin Data Loop *****
      itime = date(i)
      iT := T(i,s,:,:)
        iT&eta_rho = lat_rho
        iT&xi_rho  = lon_rho

      iMSLP := in_wrf->MSLP(j,:,:)
        copy_VarCoords(iT, iMSLP)
        iMSLP@long_name = "Sea Level Pressure"
        iMSLP@unist = "hPa"

;************************************************
; create default plot
;************************************************
      imgName = "img/OWA.MYNN.GLS_SST_" + itime
      wks_type                   = "png"
      wks_type@wkHeight          = 960
      wks_type@wkWidth           = 960
      wks = gsn_open_wks(wks_type, imgName)
      gsn_define_colormap(wks,"BlueWhiteOrangeRed")

      res                        = True
      res@tiMainString           = "SST (AWO,MYNN,GLS)"
      res@tiMainFontHeightF      = 0.016
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
      
      res@mpGridAndLimbOn        = True
      res@gsnCenterString        = itime
      res@mpShapeMode            = "FreeAspect"
      res@vpWidthF               = 0.6
      res@vpHeightF              = 0.5
      res@gsnAddCyclic           = False
      res@tiMainOffsetYF         = -0.01
      res@mpGeophysicalLineThicknessF   = 3.0
      res@gsnCenterStringFontHeightF    = 0.014
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
      opts1@tmXBLabelFontHeightF  = 0.01
      opts1@tmYLLabelFontHeightF  = 0.01
      opts1@pmLabelBarHeightF     = 0.06
      opts1@pmLabelBarWidthF      = 0.46
      opts1@cnLevelSelectionMode  = "ManualLevels"
      opts1@cnLevelSpacingF       = 0.5
      opts1@cnMaxLevelValF        = 27.0
      opts1@cnMinLevelValF        = 1.0
      opts1@pmLabelBarParallelPosF   = 0.5
      opts1@pmLabelBarOrthogonalPosF = 0.06
      opts1@lbLabelFontHeightF       = 0.01
      opts1@lbLabelStride            = 8
      opts1@lbTitleString            = iT@long_name + " [" + iT@units + "]"
      opts1@lbTitleFontHeightF       = 0.012
      opts1@lbBoxSeparatorLinesOn    = False
    
;------------- For Pressure -----------------
      opts2                       = True
      opts2@gsnDraw               = False
      opts2@gsnFrame              = False
      opts2@cnFillOn              = False
      opts2@cnLinesOn             = True
      opts2@gsnRightString        = ""
      opts2@gsnLeftString         = ""
      opts2@cnLineColor           = "darkgreen"
      opts2@cnLineThicknessF      = 2.0
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

      plot    = gsn_csm_contour_map(wks,iT,opts1)
      plot2   = gsn_csm_contour(wks,iMSLP,opts2)
      overlay(plot,plot2)

      print("i=" + i + "; time: UTC " + itime)
      draw(plot)
      frame(wks)
      j = j + 1

    end do
  end do
  
end
