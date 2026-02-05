% === Copyright (c) 2017 Takashi NAKAMURA  =====

zh1_file = '.././output/N18_recover/eco5-zoo1_his.csv';
ch1_file = '.././output/N18_recover/eco5-crl1_his.csv';
% zh1_file = '.././output/eco5-zoo2_his.csv';

xmin=0; xmax=120;
PFDmax =2000;

zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 400 450]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...
hold off
subplot(2,1,1);
hold on
plot(zh1.time, zh1.dens,'b','LineWidth',1);
axis([xmin xmax  0 2.2e6])
ylabel('Zoox. density (cell cm^-^2)')
legend('Zoox. dens')

hold off
subplot(2,1,2);
plot(ch1.time, ch1.growth*24*60*60,'r','LineWidth',1);
axis([xmin xmax  0 3e-3])
hold on
plot(ch1.time, ch1.mort*24*60*60, 'b','LineWidth',1);
ylabel('rate (cm^2 cm^-^2 d^-^1)')
yyaxis right
plot(ch1.time, ch1.QC,'Color', [0 0.7 0],'LineWidth',1);
ax = gca; ax.YColor = 'k';
ylabel('QC_C (umol cm^-^2)')
axis([xmin xmax  80 200])
% legend('growth','mort','QC', 'Location','southoutside','Orientation','horizontal')
legend('growth','mort','QC')

samexaxis('abc','xmt','on','ytac','join','yld',1)

