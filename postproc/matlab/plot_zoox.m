% === Copyright (c) 2017 Takashi NAKAMURA  =====

zh1_file = '.././output/eco5-zoo1_his.csv';
ch1_file = '.././output/eco5-crl1_his.csv';
% zh1_file = '.././output/eco5-zoo2_his.csv';

xmin=0; xmax=7;
PFDmax =2000;

zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
ch1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 1000 1050]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

subplot(4,2,1); 
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.Pg-zh1.R,'b');
plot(zh1.time, zh1.F_Csec,'-r');
plot(zh1.time, zh1.C_repro,'-g');
axis([xmin xmax  -0.1e-3 5e-4])
ylabel('Pn, Fs, Fr (pmol cell^-^1 s^-^1)')
ax = gca; ax.YColor = 'k';
legend('Pn','FZsec','FZrepro','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,2);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.QC,'b');
ax = gca; ax.YColor = 'k';
axis([xmin xmax  0 200])
ylabel('QCz (pmol cell^-^1)')
ax = gca; ax.YColor = 'k';
legend('QC','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,3);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.dens,'b');
axis([xmin xmax  0 3.5e6])
hold on
ylabel('Zoox. density (cell cm^-^2)')
ax = gca; ax.YColor = 'k';
legend('Zoox. dens','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,4);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.F_Zexpul,'b');
axis([xmin xmax  0 100])
hold on
ylabel('Zoox. release (cell cm^-^2 s^-^1)')
ax = gca; ax.YColor = 'k';
legend('Zoox. release','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,5);
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(ch1.time, ch1.ROS,'b');
axis([xmin xmax  0 50])
hold on
ylabel('ROS (uM)')
ax = gca; ax.YColor = 'k';
legend('ROS','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,6);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(ch1.time, ch1.F_ROS*1e3, 'b');
axis([xmin xmax  0 1e0])
hold on
ylabel('FROS (pmol cm^-^2 s^-^1)')
ax = gca; ax.YColor = 'k';
legend('FROS','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,7);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.C_repro,'b');
axis([xmin xmax  0 0.00005])
hold on
ylabel('repro (pmol cell^-^1 s^-1)')
ax = gca; ax.YColor = 'k';
legend('repro','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,8);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.Repro*3600*24,'b');
axis([xmin xmax  0 0.05])
hold on
ylabel('Repro (d^-^1)')
ax = gca; ax.YColor = 'k';
legend('Repro','E', 'Location','southoutside','Orientation','horizontal')


