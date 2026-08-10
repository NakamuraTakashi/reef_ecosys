% === Copyright (c) 2017 Takashi NAKAMURA  =====

xmin=0; xmax=14;
PFDmax =1600;

zh1_file = '.././output/N18_27oC/eco5-zoo1_his.csv';
zh2_file = '.././output/N18_27oC_50Sd/eco5-zoo1_his.csv';
zh3_file = '.././output/N18_27oC_75Sd/eco5-zoo1_his.csv';
zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 400 450]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...
hold off
subplot(2,1,1);
hold on
plot(zh3.time, zh3.dens, 'r','LineWidth',1);
axis([xmin xmax  0 2.5e6])
plot(zh2.time, zh2.dens, 'Color', [0 0.7 0],'LineWidth',1);
plot(zh1.time, zh1.dens, 'b','LineWidth',1);
axis([xmin xmax  0 2.5e6])
ylabel('Zoox. density (cell cm^-^2)')
legend('27oC,75S','27oC,50S','27oC,NS')

%% 

zh1_file = '.././output/N18_33oC/eco5-zoo1_his.csv';
zh2_file = '.././output/N18_33oC_50Sd/eco5-zoo1_his.csv';
zh3_file = '.././output/N18_33oC_75Sd/eco5-zoo1_his.csv';
zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);


% hold off
subplot(2,1,2);
plot(zh3.time, zh3.dens, 'r','LineWidth',1);
hold on
plot(zh2.time, zh2.dens, 'Color', [0 0.7 0],'LineWidth',1);
plot(zh1.time, zh1.dens, 'b','LineWidth',1);
axis([xmin xmax  0 2.5e6])
ylabel('Zoox. density (cell cm^-^2)')
legend('33oC,75S','33oC,50S','33oC,NS')

samexaxis('abc','xmt','on','ytac','join','yld',1)
