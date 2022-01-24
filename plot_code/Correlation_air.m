%% Correlation:  NDBC-Observation vs Model Wind Data
R(1:5,1)={'Obs'; 'A'; 'AW';'AO';'AWO'};
%%
%load('/Users/kita/Documents/Observation/NDBC/Data/LongIsland_201801.mat','Air');
Air.dateV(:,5:6)=0;
obs_startID=find(datenum([2018,1,1,0,0,0])==datenum(Air.dateV));
obs_endID=find(datenum([2018,1,10,0,0,0])==datenum(Air.dateV));
%date_sel=datenum(Air.date(obs_startID:obs_endID));
%% Wind Speed
j=1; m=18;
for i=1:217
    tmp=find(date(i)==datenum(Air.dateV(obs_startID:obs_endID,:)));
    if (~isempty(tmp))
        timeID(j)=i;
        Wind_obs(j,1)=Air.Wind(obs_startID+tmp);
        date_sel(j,1)=Air.date(obs_startID+tmp);
        j=j+1;
    end
end
Wind_A_sel=Wind5_A(timeID,m);
Wind_AW_sel=Wind5_AW(timeID,m);
Wind_OA_sel=Wind5_OA(timeID,m);
Wind_OWA_sel=Wind5_OWA(timeID,m);
clear timeID tmp i j m

%
x=[date_sel, Wind_obs, Wind_A_sel, Wind_AW_sel, Wind_OA_sel, Wind_OWA_sel];
% x=[date_sel, Wind_obs, Wind_A_sel, Wind_AW_sel, Wind_OWA_sel];
x=sortrows(x,2);
index=find(x(:,2)>0); en=index(end); be=index(1); x=x(be:en,:);  % exclude NaN

x=sortrows(x,1);
%x(:,2)=x(:,2)*(10/5)^(1/7);
r=corrcoef(x(:,2:6));  STD=std(x(:,2:6));
diff=[x(:,3)-x(:,2), x(:,4)-x(:,2), x(:,5)-x(:,2), x(:,6)-x(:,2)]; RMS=rms(diff);  Bias=mean(diff);
Mean=mean(x(:,2:6));
%R(4,2)=num2cell(r(1,2));
x_nor=(x(:,2:6)-Mean(1))/STD(1); STD_nor=std(x_nor);
diff_nor=[x_nor(:,2)-x_nor(:,1), x_nor(:,3)-x_nor(:,1), x_nor(:,4)-x_nor(:,1), x_nor(:,5)-x_nor(:,1)]; RMS_nor=rms(diff_nor); 

Nc=4; tb=zeros(Nc,5);
tb(:,1)=r(1,2:Nc+1)'; tb(:,2)=Bias'; tb(:,3)=RMS'; tb(:,4)=STD(2:Nc+1)'; tb(:,5)=Mean(2:Nc+1)';

tb_nor=zeros(Nc,5);
tb_nor(:,1)=r(1,2:Nc+1)'; tb_nor(:,2)=Bias'; tb_nor(:,3)=RMS_nor'; tb_nor(:,4)=STD_nor(2:Nc+1)'; tb_nor(:,5)=Mean(2:Nc+1)';

clear en be index 

%% Air Temperature
j=1; m=18;
for i=1:217
    tmp=find(date(i)==datenum(Air.dateV(obs_startID:obs_endID,:)));
    if (~isempty(tmp))
        timeID(j)=i;
        T_obs(j,1)=Air.Temp(obs_startID+tmp);
        date_sel(j,1)=Air.date(obs_startID+tmp);
        j=j+1;
    end
end
T_A_sel=T2_A(timeID,m);
T_AW_sel=T2_AW(timeID,m);
T_OA_sel=T2_OA(timeID,m);
T_OWA_sel=T2_OWA(timeID,m);
clear timeID tmp i j m

%
x=[date_sel, T_obs, T_A_sel, T_AW_sel, T_OA_sel, T_OWA_sel];
x=sortrows(x,2);
index=find(x(:,2)>-100); en=index(end); be=index(1); x=x(be:en,:);  % exclude NaN

x=sortrows(x,1);
%x(:,2)=x(:,2)*(10/5)^(1/7);
r=corrcoef(x(:,2:6));  STD=std(x(:,2:6));
diff=[x(:,3)-x(:,2), x(:,4)-x(:,2), x(:,5)-x(:,2), x(:,6)-x(:,2)]; RMS=rms(diff);  Bias=mean(diff);
Mean=mean(x(:,2:6));
%R(4,2)=num2cell(r(1,2));
x_nor=(x(:,2:6)-Mean(1))/STD(1); STD_nor=std(x_nor);
diff_nor=[x_nor(:,2)-x_nor(:,1), x_nor(:,3)-x_nor(:,1), x_nor(:,4)-x_nor(:,1), x_nor(:,5)-x_nor(:,1)]; RMS_nor=rms(diff_nor); 

Nc=4; tb=zeros(Nc,5);
tb(:,1)=r(1,2:Nc+1)'; tb(:,2)=Bias'; tb(:,3)=RMS'; tb(:,4)=STD(2:Nc+1)'; tb(:,5)=Mean(2:Nc+1)';

tb_nor=zeros(Nc,5);
tb_nor(:,1)=r(1,2:Nc+1)'; tb_nor(:,2)=Bias'; tb_nor(:,3)=RMS_nor'; tb_nor(:,4)=STD_nor(2:Nc+1)'; tb_nor(:,5)=Mean(2:Nc+1)';

clear en be index 

%% Sea Level Pressure
j=1; m=18;
for i=1:217
    tmp=find(date(i)==datenum(Air.dateV(obs_startID:obs_endID,:)));
    if (~isempty(tmp))
        timeID(j)=i;
        MSLP_obs(j,1)=Air.SLP(obs_startID+tmp);
        date_sel(j,1)=Air.date(obs_startID+tmp);
        j=j+1;
    end
end
MSLP_A_sel=MSLP_A(timeID,m);
MSLP_AW_sel=MSLP_AW(timeID,m);
MSLP_OA_sel=MSLP_OA(timeID,m);
MSLP_OWA_sel=MSLP_OWA(timeID,m);
clear timeID tmp i j m

%
x=[date_sel, MSLP_obs, MSLP_A_sel, MSLP_AW_sel, MSLP_OA_sel, MSLP_OWA_sel];
x=sortrows(x,2);
index=find(x(:,2)>800); en=index(end); be=index(1); x=x(be:en,:);  % exclude NaN

x=sortrows(x,1);
%x(:,2)=x(:,2)*(10/5)^(1/7);
r=corrcoef(x(:,2:6));  STD=std(x(:,2:6));
diff=[x(:,3)-x(:,2), x(:,4)-x(:,2), x(:,5)-x(:,2), x(:,6)-x(:,2)]; RMS=rms(diff);  Bias=mean(diff);
Mean=mean(x(:,2:6));
%R(4,2)=num2cell(r(1,2));
x_nor=(x(:,2:6)-Mean(1))/STD(1); STD_nor=std(x_nor);
diff_nor=[x_nor(:,2)-x_nor(:,1), x_nor(:,3)-x_nor(:,1), x_nor(:,4)-x_nor(:,1), x_nor(:,5)-x_nor(:,1)]; RMS_nor=rms(diff_nor); 

Nc=4; tb=zeros(Nc,5);
tb(:,1)=r(1,2:Nc+1)'; tb(:,2)=Bias'; tb(:,3)=RMS'; tb(:,4)=STD(2:Nc+1)'; tb(:,5)=Mean(2:Nc+1)';

tb_nor=zeros(Nc,5);
tb_nor(:,1)=r(1,2:Nc+1)'; tb_nor(:,2)=Bias'; tb_nor(:,3)=RMS_nor'; tb_nor(:,4)=STD_nor(2:Nc+1)'; tb_nor(:,5)=Mean(2:Nc+1)';

clear en be index 
