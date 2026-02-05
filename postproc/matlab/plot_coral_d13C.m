% === ver 2017/03/09   Copyright (c) 2017 Takashi NAKAMURA  =====

% evn_file = '.././output/site04-env_his.csv';
% ch1_file = '.././output/site04-crl1_his.csv';
% evn_file = '.././output/site10-env_his.csv';
% ch1_file = '.././output/site10-crl2_his.csv';
% ch2_file = '.././output/site06-crl2_his.csv';
evn_file = '.././output/eco5-env_his.csv';
ch1_file = '.././output/eco5-crl1_his.csv';
% ch1_file = '.././output/eco5-crl2_his.csv';

xmin=6; ymin=9;
PFDmax =2000;

env = readtable(evn_file,'Delimiter',',', 'ReadVariableNames', true);
ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);
% ch2 = readtable(ch2_file,'Delimiter',',', 'ReadVariableNames', true);
% ca1 = readtable(ca1_file,'Delimiter',',', 'ReadVariableNames', true);
% ca2 = readtable(ca2_file,'Delimiter',',', 'ReadVariableNames', true);


figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 1000 1050]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

subplot(4,2,3); 
plot(ch1.time, ch1.d13C_DICcal,'r');
axis([xmin ymin  -7 7])
hold on
plot(ch1.time, ch1.d13C_DICcoe, 'g');
plot(ch1.time, ch1.d13C_DICamb, 'b');
ylabel('d13C-DIC (per mill)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('d13C-DICcal','d13C-DICcoe','d13C-DICamb','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,4);
plot(ch1.time, ch1.d13C_QC,'g');
axis([xmin ymin  -17 -12])
hold on
ylabel('d13C-CH2O (per mill)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('d13C-CH2O','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,5);
plot(ch1.time, ch1.d13C_CO2aqcal,'r');
axis([xmin ymin  -15 5])
hold on
plot(ch1.time, ch1.d13C_HCO3cal, 'g');
plot(ch1.time, ch1.d13C_CO3cal, 'b');
ylabel('d13Ccal (per mill)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('d13C-CO2aq','d13C-HCO3','d13C-CO3','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,6);
plot(ch1.time, ch1.d13C_arg,'r');
axis([xmin ymin  -12 7])
hold on
ylabel('d13C-Arg (per mill)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('d13C-Arg', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,7);
plot(ch1.time, ch1.d13C_CO2aqcoe,'r');
axis([xmin ymin  -15 10])
hold on
plot(ch1.time, ch1.d13C_HCO3coe, 'g');
plot(ch1.time, ch1.d13C_CO3coe, 'b');
ylabel('d13Ccoe (per mill)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('d13C-CO2aq','d13C-HCO3','d13C-CO3','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,8);
plot(ch1.time, ch1.Wacal,'r');
axis([xmin ymin  0 20])
hold on
plot(ch1.time, ch1.Waamb, 'b');
ylabel('Omega arg')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Wcal','Wcoe','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,1);
plot(ch1.time, ch1.DICcal,'r');
axis([xmin ymin  500 4000])
hold on
plot(ch1.time, ch1.DICcoe, 'g');
plot(ch1.time, ch1.DICamb, 'b');
ylabel('DIC (umol kg^-^1)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('DICcal','DICcoe','DICamb','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,2);
plot(ch1.time, ch1.QC,'g');
axis([xmin ymin  0 25])
hold on
ylabel('CH2O (umol cm^-^2)')
yyaxis right
plot(env.time, env.PFDsurf, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('CH2O','E', 'Location','southoutside','Orientation','horizontal')
