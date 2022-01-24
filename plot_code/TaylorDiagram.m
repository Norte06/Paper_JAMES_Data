%% Air
set(gcf,'units','inches','position',[0,10.0,14.0,10.0]);
set(gcf,'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

label = containers.Map({'A','AW','AO.GLS','AWO.GLS'}, {'r','y','g','k'});

[hp, ht, axl] = taylor_diagram(Std(:,1),RMSD(:,1),R(:,1), ...
    'tickRMS',0.2:0.2:1.0,'rmslabelformat','%.1f', 'markerLabel', label, ...
    'colOBS','k', 'markerObs','o','titleOBS','Buoy','markerKey', 'A');

[hp, ht, axl] = taylor_diagram(Std(:,2),RMSD(:,2),R(:,2), ...
    'markerLabel', label,'markerKey', 'AW', 'overlay','on');

[hp, ht, axl] = taylor_diagram(Std(:,3),RMSD(:,3),R(:,3), ...
    'markerLabel', label,'markerKey', 'AO.GLS', 'overlay','on');

[hp, ht, axl] = taylor_diagram(Std(:,4),RMSD(:,4),R(:,4), ...
    'markerLabel', label,'markerKey', 'AWO.GLS', 'overlay','on');

%% Wave
set(gcf,'units','inches','position',[0,10.0,14.0,10.0]);
set(gcf,'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

label = containers.Map({'W','AW','AWO.GLS','WO.LMD','WO.GLS'}, {'r','y','k','c','b'});

[hp, ht, axl] = taylor_diagram(Std(:,1),RMSD(:,1),R(:,1), ...
    'tickRMS',0.2:0.2:0.8,'rmslabelformat','%.1f', 'markerLabel', label, ...
    'colOBS','k', 'markerObs','o','titleOBS','Buoy','markerKey', 'W');

[hp, ht, axl] = taylor_diagram(Std(:,2),RMSD(:,2),R(:,2), ...
    'markerLabel', label,'markerKey', 'AW', 'overlay','on');

[hp, ht, axl] = taylor_diagram(Std(:,3),RMSD(:,3),R(:,3), ...
    'markerLabel', label,'markerKey', 'AWO.GLS', 'overlay','on');

[hp, ht, axl] = taylor_diagram(Std(:,4),RMSD(:,4),R(:,4), ...
    'markerLabel', label,'markerKey', 'WO.LMD', 'overlay','on');

[hp, ht, axl] = taylor_diagram(Std(:,5),RMSD(:,5),R(:,5), ...
    'markerLabel', label,'markerKey', 'WO.GLS', 'overlay','on');

%% Air
set(gcf,'units','inches','position',[0,10.0,9.0,7.0]);
set(gcf,'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

label = containers.Map({'AWO','AO'}, {'r','b'});

[hp, ht, axl] = taylor_diagram(Std(:,1),RMSD(:,1),R(:,1), ...
    'tickRMS',0.2:0.2:1.0,'rmslabelformat','%.1f', 'markerLabel', label, ...
    'colOBS','k', 'markerObs','o','titleOBS','Buoy','markerKey', 'AWO');

[hp, ht, axl] = taylor_diagram(Std(:,2),RMSD(:,2),R(:,2), ...
    'markerLabel', label,'markerKey', 'AO', 'overlay','on');
