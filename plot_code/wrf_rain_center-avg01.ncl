;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
;************************************************
begin
  Dir   = "./outputs_cpl_oa.gls/"
  ; Dir   = "./outputs_frc_wrf/"
  FILES = systemfunc (" ls -1 " + Dir + "wrfout_d01_2018-01-*00 ")
  numFILES = dimsizes(FILES)
;------------- Reading Text Data -----------------
  Nc = 49
  cyclone_file = Dir + "Cyclone_center.txt"
  
  CC   = new((/Nc,2/), "float")
  tmp := readAsciiTable(cyclone_file, 3, "float", 1)
  CC   = tmp(:,1:2)

;************************************************
;  File Loop
;************************************************
  j  = 0
  L1 = 32
  L2 = 100
  step = 1
  print("Case:" + Dir)
  do ifil = 3, 4, 1
  ; do ifil = 1, numFILES-1, 1
    fName = FILES(ifil)+".nc"
    in = addfile(fName,"r")

    dims = getfiledimsizes(in)
    lat  = in->XLAT(0,:,:)
    lon  = in->XLONG(0,:,:)
    time = wrf_user_getvar(in,"times",-1)
    TimeChar := in->Times
    timestr  := wrf_times_c(TimeChar,3)

;************************************************
; Date Loop
;************************************************
    do i=0, dims(0)-1, step
      RAINCV  = in->RAINCV(i,:,:)
        RAINCV@_FillValue = default_fillvalue("float")
      var_size = dimsizes(RAINCV)

      ; XLAND := ndtooned(in->XLAND(i,:,:))
      ; Var1D := ndtooned(RAINNC)
      ; chk := ind(XLAND.lt.1.5)
      ; if (.not. any(ismissing(chk))) then
      ;   do k=0, dimsizes(chk)-1, 1
      ;     Var1D(chk(k)) = default_fillvalue("float")
      ;   end do
      ; end if
      ; RAINNC = onedtond(Var1D, var_size)

      RAIN = RAINCV ;+ RAINNCV

      center = wrf_user_ll_to_ij(in, CC(j,0), CC(j,1), True)
      ew1 = max((/ center(0)-L1, 0 /))
      ew2 = min((/ center(0)+L1, dims(2)-1 /))
      sn1 = max((/ center(1)-L1, 0 /))
      sn2 = min((/ center(1)+L1, dims(3)-1 /))

      ; RAINa = sum(RAIN(sn1:sn2,ew1:ew2))
      RAINa = avg(RAIN(sn1:sn2,ew1:ew2)) * 120.

      print("time:" + timestr(i) + ",  Average-Precipitation:" + RAINa)

      if (j .eq. Nc-1) then
        break
      end if
      j = j + step
    end do
  end do

end
