%% Wind Speed Plot
figure('color','w'); m=18;
plot(date,Wind5_A(1:217,m), date,Wind5_AW(1:217,m), date,Wind5_OA(1:217,m), date,Wind5_OWA(1:217,m),'LineWidth',1.5);
startDate = datenum([2018,1,1,0,0,0]); endDate = datenum([2018,1,10,0,0,0]);
xData = linspace(startDate,endDate,9);
set(gca,'XGrid','on','YGrid','on','xTick',xData);
hold on;
% plot(time_CFSR(1:241), Wind_CFSR(1:241),'LineWidth',1.5);
% set(gca,'XGrid','on','xTick',xData);
% datetick('x','dd','keepticks')

plot(Air.date, Air.Wind, '.','MarkerSize',12);
set(gca,'XGrid','on','YGrid','on','xTick',xData);
datetick('x','ddHH','keepticks')

xlabel('Date','FontSize',13.0); ylabel('Wind[m/s]','FontSize',13.0);
title('Wind Speed at Virginia Beach (2018/01)','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('A','AW','AO.GLS','AWO.GLS','Buoy');
clear m startDate endDate xDate

%% Air Temperature
figure('color','w'); m=18;
plot(date,T2_A(1:217,m), date,T2_AW(1:217,m), date,T2_OA(1:217,m), date,T2_OWA(1:217,m),'LineWidth',1.5);
startDate = datenum([2018,1,1,0,0,0]); endDate = datenum([2018,1,10,0,0,0]);
xData = linspace(startDate,endDate,9);
set(gca,'XGrid','on','xTick',xData);
hold on;
% plot(time_CFSR(1:241), T2_CFSR(1:241),'LineWidth',1.5);
% set(gca,'XGrid','on','xTick',xData);
% datetick('x','dd','keepticks')

plot(Air.date, Air.Temp, '.','MarkerSize',12);
set(gca,'XGrid','on','YGrid','on','xTick',xData);
datetick('x','ddHH','keepticks')

xlabel('Date','FontSize',13.0); ylabel('Temp[C]','FontSize',13.0);
title('Air Temp at Virginia Beach (2018/01)','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('A','AW','AO.GLS','AWO.GLS','Buoy');
clear m startDate endDate xDate

%% Surface Pressure
figure('color','w'); m=18;
plot(date,MSLP_A(1:217,m), date,MSLP_AW(1:217,m), date,MSLP_OA(1:217,m), date,MSLP_OWA(1:217,m),'LineWidth',1.5);
startDate = datenum([2018,1,1,0,0,0]); endDate = datenum([2018,1,10,0,0,0]);
xData = linspace(startDate,endDate,9);
set(gca,'XGrid','on','xTick',xData);
hold on;

plot(Air.date, Air.SLP, '.','MarkerSize',12);
set(gca,'XGrid','on','YGrid','on','xTick',xData);
datetick('x','ddHH','keepticks')

xlabel('Date','FontSize',13.0); ylabel('SLP[hPa]','FontSize',13.0);
title('SLP at Virginia Beach (2018/01)','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('A','AW','AO.GLS','AWO.GLS','Buoy');
clear m startDate endDate xDate
