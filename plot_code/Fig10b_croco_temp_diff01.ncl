;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
  Dir1  = "./outputs_cpl_owa.gls/"
  Dir2  = "./outputs_cpl_oa.gls/"
  ; Dir2  = "./outputs_frc_croco.gls/"
  FILES1  = systemfunc (" ls -1 " + Dir1 + "croco_his.0???.nc")
  FILES2  = systemfunc (" ls -1 " + Dir2 + "croco_his.0???.nc")
  numFILES = dimsizes(FILES1)

  FILES_wrf = systemfunc (" ls -1 " + Dir1 + "wrfout_d01_2018-01-*00 ")

  fName = Dir1 + "croco_his.0000.nc"
  in = addfile(fName, "r")

  dims = getfiledimsizes(in)
  lat_rho = in->lat_rho(:,0)
  lon_rho = in->lon_rho(0,:)
  s_rho   = in->s_rho

;************************************************
;  File Loop
;************************************************
  ; do ifil = 0, numFILES-1, 1
  do ifil = 3, 4, 1
    fName1 = FILES1(ifil)
    fName2 = FILES2(ifil)
    in1 = addfile(fName1, "r")
    in2 = addfile(fName2, "r")
    print("fName1:" + fName1)
    print("fName2:" + fName2)

    fName_wrf = FILES_wrf(ifil)+".nc"
    in_wrf  = addfile(fName_wrf,"r")
    lat_wrf = in_wrf->XLAT(0,:,0)
    lon_wrf = in_wrf->XLONG(0,0,:)

    time := in2->time
      time@units = "seconds since 2010-01-01 00:00:00"
    T1   := in1->temp
    T2   := in2->temp
    
    date = cd_calendar(time, -3)
    s    = 44
    do i=0, dims(7)-1, 2                 ; ***** Begin Data Loop *****
      j = i * 3
      itime = date(i)
      iT1 := T1(i,s,:,:)
        iT1&eta_rho = lat_rho
        iT1&xi_rho  = lon_rho
      iT2 := T2(i,s,:,:)
      T_diff = iT1 - iT2
        copy_VarCoords(iT1, T_diff)
        T_diff@long_name = "SST difference"
        T_diff@units = "C"

      iMSLP = (/ wrf_user_getvar(in_wrf,"slp",j) /)
        iMSLP!0 = "lat"
        iMSLP!1 = "lon"
        iMSLP&lat  = lat_wrf
        iMSLP&lon  = lon_wrf
        iMSLP@long_name = "Sea Level Pressure"
        iMSLP@unist = "hPa"

;************************************************
; create default plot
;************************************************
      imgName = "img/OWA-OA.MYNN.GLS_SST_" + itime
      wks_type                   = "png"
      wks_type@wkHeight          = 960
      wks_type@wkWidth           = 960
      wks = gsn_open_wks(wks_type, imgName)
      gsn_define_colormap(wks,"NCV_blue_red")

      res                        = True
      res@tiMainString           = "AWO-AO: SST (MYNN,GSL)"
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
      res@mpGeophysicalLineThicknessF   = 2.5
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
      opts1@cnLevelSpacingF       = 0.05
      opts1@cnMaxLevelValF        = 0.6
      opts1@cnMinLevelValF        = -0.6
      opts1@pmLabelBarParallelPosF   = 0.5
      opts1@pmLabelBarOrthogonalPosF = 0.04
      opts1@lbLabelFontHeightF       = 0.013
      opts1@lbLabelStride            = 6
      opts1@lbTitleString            = T_diff@long_name + " [" + T_diff@units + "]"
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

      plot    = gsn_csm_contour_map(wks,T_diff,opts1)
      plot2   = gsn_csm_contour(wks,iMSLP,opts2)
      overlay(plot,plot2)

      print("i=" + i + "; time: UTC " + itime)
      draw(plot)
      frame(wks)

    end do
  end do
  
end
