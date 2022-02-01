%% Wind vs Cd
figure('color','w','Position',[200 600 450 300]);
errorbar(Wind,A(:,1),A(:,2),'LineWidth',1.5); hold on;
errorbar(Wind,AW(:,1),AW(:,2),'LineWidth',1.5);
plot(Wind,A(:,1), Wind,AW(:,1),'LineWidth',3.0);

xlabel('Wind Speed[m/s]','FontSize',13.0); ylabel('Cd','FontSize',13.0);
% title('Friction Velocity','FontSize',15.0,'FontWeight','demi');
set(findobj('FontSize',11.0),'FontSize',12.0);
legend('A','AW','FontSize',13.0,'Location','northwest');
grid on
