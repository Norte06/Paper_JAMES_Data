%% Wave Height
figure('color','w'); m=1;
plot(date,Hs_W(:,m), date,Hs_AW(:,m), date,Hs_OWA(:,m),'LineWidth',2.0);
startDate = datenum([2018,1,1,0,0,0]); endDate = datenum([2018,1,10,0,0,0]);
xDate = linspace(startDate,endDate,9);
hold on;

plot(Wave.date, Wave.Height, '.','MarkerSize',16);
set(gca,'XGrid','on','YGrid','on','xTick',xDate);
datetick('x','ddHH','keepticks')

xlabel('Date','FontSize',13.0); ylabel('Wave height[m]','FontSize',13.0);
title('Hs at Virginia Beach (2018/01)','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('W','AW','OWA','Buoy');
clear m startDate endDate xDate

%% Wave Period
figure('color','w'); m=1;
plot(date,T0m1_A(:,m), date,T0m1_AW(:,m), date,T0m1_OWA(:,m),'LineWidth',2.0);
startDate = datenum([2018,1,2,0,0,0]); endDate = datenum([2018,1,10,0,0,0]);
xDate = linspace(startDate,endDate,9);
hold on;

plot(Wave.date, Wave.Period, '.','MarkerSize',16);
set(gca,'XGrid','on','YGrid','on','xTick',xDate);
datetick('x','ddHH','keepticks')
ylim([4 18])

xlabel('Date','FontSize',13.0); ylabel('Wave Periodt[sec]','FontSize',13.0);
title('Tm at LaHave Bank (2018/01)','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('A','AW','OWA','Buoy');
clear m startDate endDate xDate
