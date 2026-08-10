% === Copyright (c) 2017 Takashi NAKAMURA  =====
ch1_file = '.././output/N18_27oC/eco5-crl1_his.csv';
ch2_file = '.././output/N18_29oC/eco5-crl1_his.csv';
ch3_file = '.././output/N18_31oC/eco5-crl1_his.csv';
ch4_file = '.././output/N18_33oC/eco5-crl1_his.csv';

xmin=0; xmax=14;
PFDmax =2000;

ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);
ch4 = readtable(ch4_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 400 450]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...
hold off
subplot(2,1,1);
hold on
plot(ch1.time, ch1.growth*24*60*60,'r','LineWidth',1);
plot(ch1.time, ch1.mort*24*60*60, 'b','LineWidth',1);
axis([xmin xmax  0 3e-3])
ylabel('rate (cm^2 cm^-^2 d^-^1)')
yyaxis right
plot(ch1.time, ch1.QC,'Color', [0 0.7 0],'LineWidth',1);
ax = gca; ax.YColor = 'k';
ylabel('QC_C (umol cm^-^2)')
axis([xmin xmax  80 200])
% legend('growth','mort','QC', 'Location','southoutside','Orientation','horizontal')
legend('growth','mort','QC')

hold off
subplot(2,1,2);
hold on
plot(ch4.time, ch4.growth*24*60*60,'r','LineWidth',1);
plot(ch4.time, ch4.mort*24*60*60, 'b','LineWidth',1);
axis([xmin xmax  0 3e-3])
ylabel('rate (cm^2 cm^-^2 d^-^1)')
yyaxis right
plot(ch4.time, ch4.QC,'Color', [0 0.7 0],'LineWidth',1);
ax = gca; ax.YColor = 'k';
ylabel('QC_C (umol cm^-^2)')
axis([xmin xmax  80 200])
% legend('growth','mort','QC', 'Location','southoutside','Orientation','horizontal')
legend('growth','mort','QC')

samexaxis('abc','xmt','on','ytac','join','yld',1)

