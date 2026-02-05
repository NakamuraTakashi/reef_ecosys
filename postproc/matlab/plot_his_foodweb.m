% === ver 2017/03/09   Copyright (c) 2017 Takashi NAKAMURA  =====

% evn_file = '.././output/site05-env_his.csv';
% eco_file = '.././output/site05-ecosys_his.csv';
% evn_file = '.././output/eco5-env_his.csv';
% eco_file = '.././output/eco5-ecosys_his.csv';
evn_file = '../Projects/foodweb/foodweb-env_his.csv';
eco_file = '../Projects/foodweb/foodweb-ecosys_his.csv';

xmin=3; ymin=5;
PFDmax =2000;

env = readtable(evn_file,'Delimiter',',', 'ReadVariableNames', true);
eco = readtable(eco_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

% tot_Pn = eco.coral1_Pn + eco.coral2_Pn + eco.sedeco_Pn;
% tot_G  = eco.coral1_G + eco.coral2_G  + eco.sedeco_G ;

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 1000 1050]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

subplot(4,2,1); 
plot(eco.time, eco.coral1_Pn,'b');
axis([xmin ymin  -15.0 20.0])
hold on
plot(eco.time, eco.coral1_G, 'r');
ylabel('Coral G, Pn (mmol m^-^2 h^-^1)')
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Pn','G','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,2);
plot(env.time, env.TA,'b');
axis([xmin ymin  1900 2300])
ylabel('TA (umol kg^-^1)')
hold on
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('TA','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,3);
plot(eco.time, eco.sedeco_Pn,'b');
axis([xmin ymin  -15.0 20.0])
hold on
plot(eco.time, eco.sedeco_G, 'r');
ylabel('Sand G, Pn (mmol m^-^2 h^-^1)')
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Pn','G','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,4);
plot(env.time, env.DIC,'b');
axis([xmin ymin  1500 2000])
ylabel('DIC (umol kg^-^1)')
hold on
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('DIC','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,5);
plot(eco.time, tot_Pn,'b');
% axis([xmin ymin  -15.0 20.0])
axis([xmin ymin  -5.0 5.0])
hold on
plot(eco.time, tot_G, 'r');
ylabel('Total G, Pn (mmol m^-^2 h^-^1)')
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Pn','G','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,6);
plot(env.time, env.DO,'b');
axis([xmin ymin  100 500])
ylabel('DO (umol kg^-^1)')
hold on
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('DO','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,7);
plot(eco.time, eco.pH,'b');
axis([xmin ymin  7.5 8.5])
ylabel('pH')
hold on
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('pH','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,8);
plot(eco.time, eco.Warg,'b');
axis([xmin ymin  2 5])
ylabel('Omega arg')
hold on
yyaxis right
plot(eco.time, eco.PFDbott, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Warg','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

