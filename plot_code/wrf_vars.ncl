;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir = "./outputs_cpl_owa.gls/"
  fName = Dir + "wrfout_d01_2018-01-01_00:00:00"
  ; fName = Dir + "wrfout_d01_2018-01-05_00:00:00_ww3grid.nc"
  
  f = addfile(fName, "r")
  varnames = getfilevarnames(f)
  file_atts = getvaratts(f)
  dims = getfiledimsizes(f)
  
  print(dims)
  if(.not.any(ismissing(file_atts))) then
    do i=0,dimsizes(file_atts)-1
      print("Attribute " + file_atts(i) + " = " + f@$file_atts(i)$)
   end do
  end if
  
  print (varnames)
  if(.not.any(ismissing(varnames))) then
    do i=0,dimsizes(varnames)-1
      printFileVarSummary (f,varnames(i))
    end do
  end if

  ; lon  = f->XLONG(0,100,0:10)
  ; print(lon)

  ; times   = f->Times
  ; times_s = chartostring( times )
  ; print(times_s(0))
  ; timestr = wrf_times_c(times(0:1,:), 3)
  ; print(timestr)
end
