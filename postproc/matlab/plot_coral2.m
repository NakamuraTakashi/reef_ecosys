% === ver 2017/03/09   Copyright (c) 2017 Takashi NAKAMURA  =====

% evn_file = '.././output/site05-ch1_his.csv';
% ch1_file = '.././output/site05-crl1_his.csv';
% evn_file = '.././output/site10-ch1_his.csv';
% ch1_file = '.././output/site10-crl2_his.csv';
% ch2_file = '.././output/site06-crl2_his.csv';
evn_file = '.././output/eco5-ch1_his.csv';
ch1_file = '.././output/eco5-crl1_his.csv';
% ch1_file = '.././output/eco5-crl2_his.csv';

xmin=0; ymin=7;
PFDmax =2000;

ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);
% ch2 = readtable(ch2_file,'Delimiter',',', 'ReadVariableNames', true);
% ca1 = readtable(ca1_file,'Delimiter',',', 'ReadVariableNames', true);
% ca2 = readtable(ca2_file,'Delimiter',',', 'ReadVariableNames', true);


figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 1000 1050]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

subplot(4,2,1); 
plot(ch1.time, ch1.Pn,'b');
hold on
plot(ch1.time, ch1.G, 'r');
axis([xmin ymin  -0.15 0.25])
ylabel('G, Pn (nmol cm^-^2 s^-^1)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Pn','G','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,2);
plot(ch1.time, ch1.pHcal,'r');
axis([xmin ymin  7 10])
hold on
plot(ch1.time, ch1.pHcoe, 'g');
plot(ch1.time, ch1.pHamb, 'b');
ylabel('pH')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('pHcal','pHcoe','pHamb','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,3);
plot(ch1.time, ch1.R,'b');
axis([xmin ymin  0 0.6])
hold on
plot(ch1.time, ch1.Pg, 'r');
ylabel('Pg, R (nmol cm^-^2 s^-^1)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('R','Pg','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,4);
plot(ch1.time, ch1.DOcoe, 'g');
axis([xmin ymin  0 800])
hold on
plot(ch1.time, ch1.DOamb, 'b');
ylabel('DO (umol kg^-^1)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('DOcoe','DOamb','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,5);
plot(ch1.time, ch1.TAcal,'r');
axis([xmin ymin  1000 5000])
hold on
plot(ch1.time, ch1.TAcoe, 'g');
plot(ch1.time, ch1.TAamb, 'b');
ylabel('TA (umol kg^-^1)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('TAcal','TAcoe','TAamb','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,6);
plot(ch1.time, ch1.Wacal,'r');
axis([xmin ymin  0 20])
hold on
plot(ch1.time, ch1.Waamb, 'b');
ylabel('Omega arg')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('Wcal','Wcoe','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,7);
plot(ch1.time, ch1.growth*24*60*60,'r');
axis([xmin ymin  0 3e-3])
hold on
plot(ch1.time, ch1.mort*24*60*60, 'b');
ylabel('rate (cm^2 cm^-^2 d^-^1)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('growth','mort','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,8);
plot(ch1.time, ch1.QC,'g');
axis([xmin ymin  100 200])
hold on
ylabel('QC_C (umol cm^-^2)')
yyaxis right
plot(ch1.time, ch1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin ymin  0 PFDmax])
legend('CH2O','E', 'Location','southoutside','Orientation','horizontal')
