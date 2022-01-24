%% Load Data: WRF Point
fname1='data/Point-NDBC_WRF_A.MYNN.nc'; nc1=ncdataset(fname1);
Wind_A=nc1.data('Wind'); MSLP_A=nc1.data('MSLP'); T2_A=nc1.data('T2'); UST_A=nc1.data('UST');
T2_A=T2_A-273.15;
Wind5_A=Wind_A-UST_A/0.4*log(10/5);

fname2='data/Point-NDBC_WRF_AW.MYNN.nc'; nc2=ncdataset(fname2);
Wind_AW=nc2.data('Wind'); MSLP_AW=nc2.data('MSLP'); T2_AW=nc2.data('T2'); UST_AW=nc2.data('UST');
T2_AW=T2_AW-273.15;
Wind5_AW=Wind_AW-UST_AW/0.4*log(10/5);

fname3='data/Point-NDBC_WRF_OWA.MYNN.GLS.nc'; nc3=ncdataset(fname3);
Wind_OWA=nc3.data('Wind'); MSLP_OWA=nc3.data('MSLP'); T2_OWA=nc3.data('T2'); UST_OWA=nc3.data('UST');
T2_OWA=T2_OWA-273.15;
Wind5_OWA=Wind_OWA-UST_OWA/0.4*log(10/5);

fname4='data/Point-NDBC_WRF_AO.MYNN.GLS.nc'; nc4=ncdataset(fname4);
Wind_OA=nc4.data('Wind'); MSLP_OA=nc4.data('MSLP'); T2_OA=nc4.data('T2'); UST_OA=nc4.data('UST');
T2_OA=T2_OA-273.15;
Wind5_OA=Wind_OA-UST_OA/0.4*log(10/5);

%% Load Data: CROCO Point
fname0='data/CROCO_LaHaveBank201801_o.gls.nc'; nc0=ncdataset(fname0);
cur_O=nc0.data('cur'); temp_O=nc0.data('temp'); salt_O=nc0.data('salt');
depth=nc0.data('depth');

fname1='data/CROCO_LaHaveBank201801_ow.gls.nc'; nc1=ncdataset(fname1);
cur_OW=nc1.data('cur'); temp_OW=nc1.data('temp'); salt_OW=nc1.data('salt');

fname2='data/CROCO_LaHaveBank201801_oa.gls.nc'; nc2=ncdataset(fname2);
cur_OA=nc2.data('cur'); temp_OA=nc2.data('temp'); salt_OA=nc2.data('salt');

fname3='data/CROCO_LaHaveBank201801_owa.gls.nc'; nc3=ncdataset(fname3);
cur_OWA=nc3.data('cur'); temp_OWA=nc3.data('temp'); salt_OWA=nc3.data('salt');

%% Load Data: WW3 Point
Point = 'LongIsland';
fname1=['data/WW3_',Point,'_W.nc']; nc1=ncdataset(fname1);
Hs_W=nc1.data('ww3_Hs'); T0m1_W=nc1.data('ww3_T0m1'); %T01=nc1.data('ww3_T01');
time=nc1.data('time');
date = datenum(time+datenum(1990,1,1)); dateV=datevec(date);

fname2=['data/WW3_',Point,'_AW.nc']; nc2=ncdataset(fname2);
Hs_AW=nc2.data('ww3_Hs'); T0m1_AW=nc2.data('ww3_T0m1');

fname3=['data/WW3_',Point,'_AWO.GLS.nc']; nc3=ncdataset(fname3);
Hs_OWA=nc3.data('ww3_Hs'); T0m1_OWA=nc3.data('ww3_T0m1');

fname4=['data/WW3_',Point,'_WO.LMD.nc']; nc4=ncdataset(fname4);
Hs_OWl=nc4.data('ww3_Hs'); T0m1_OWl=nc4.data('ww3_T0m1');

fname5=['data/WW3_',Point,'_WO.GLS.nc']; nc5=ncdataset(fname5);
Hs_OWg=nc5.data('ww3_Hs'); T0m1_OWg=nc5.data('ww3_T0m1');

%% Load Data: CFSR
fname_CFSR='/Users/kita/Documents/Observation/NDBC/Data/CFSR_LaHaveBank_Point.nc';
nc_CFSR=ncdataset(fname_CFSR);
U10=nc_CFSR.data('U10'); V10=nc_CFSR.data('V10');
T2_CFSR=nc_CFSR.data('T2'); T2_CFSR=T2_CFSR-273.15;
timeV_CFSR=nc_CFSR.data('time'); time_CFSR=datenum(double(timeV_CFSR));
Wind_CFSR=sqrt(U10.^2+V10.^2);
clear U10 V10