% === Copyright (c) 2017 Takashi NAKAMURA  =====

zh1_file = '.././output/N18_33oC/eco5-zoo1_his.csv';
zh2_file = '.././output/N18_33oC_nTdPI/eco5-zoo1_his.csv';
zh3_file = '.././output/N18_33oC_nPI/eco5-zoo1_his.csv';

ch1_file = '.././output/N18_33oC/eco5-crl1_his.csv';
ch2_file = '.././output/N18_33oC_nTdPI/eco5-crl1_his.csv';
ch3_file = '.././output/N18_33oC_nPI/eco5-crl1_his.csv';

xmin=0; xmax=14;
PFDmax =1600;

zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);
ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);
ch2 = readtable(ch2_file,'Delimiter',',', 'ReadVariableNames', true);
ch3 = readtable(ch3_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 400 450]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

hold off
subplot(2,1,1);
plot(zh3.time, zh3.dens,'Color', [0.7 0 0],'LineWidth',1);
axis([xmin xmax  0 2.5e6])
hold on
plot(zh2.time, zh2.dens,'Color', [1 0 0],'LineWidth',1);
plot(zh1.time, zh1.dens,'Color', [1 0.7 0.7],'LineWidth',1);
ylabel('Zoox. density (cell cm^-^2)')
legend('33oC,nPI','33oC,nTPI','33oC,C')

zh1_file = '.././output/N18_27oC/eco5-zoo1_his.csv';
zh2_file = '.././output/N18_27oC_nTdPI/eco5-zoo1_his.csv';
zh3_file = '.././output/N18_27oC_nPI/eco5-zoo1_his.csv';
zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);

% hold off
subplot(2,1,2);
plot(zh3.time, zh3.dens, 'Color', [0 0 1],'LineWidth',1);
axis([xmin xmax  0 2.5e6])
hold on
plot(zh2.time, zh2.dens, 'Color', [0 0.8 1],'LineWidth',1);
plot(zh1.time, zh1.dens, 'Color', [0 1 1],'LineWidth',1);
ylabel('Zoox. density (cell cm^-^2)')
legend('27oC,nPI','27oC,nTPI','27oC,C')

samexaxis('abc','xmt','on','ytac','join','yld',1)