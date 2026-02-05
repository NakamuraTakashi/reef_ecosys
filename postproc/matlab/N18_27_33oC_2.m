% === Copyright (c) 2017 Takashi NAKAMURA  =====

zh1_file = '.././output/N18_27oC/eco5-zoo1_his.csv';
zh2_file = '.././output/N18_29oC/eco5-zoo1_his.csv';
zh3_file = '.././output/N18_31oC/eco5-zoo1_his.csv';
zh4_file = '.././output/N18_33oC/eco5-zoo1_his.csv';

ch1_file = '.././output/N18_27oC/eco5-crl1_his.csv';
ch2_file = '.././output/N18_29oC/eco5-crl1_his.csv';
ch3_file = '.././output/N18_31oC/eco5-crl1_his.csv';
ch4_file = '.././output/N18_33oC/eco5-crl1_his.csv';

xmin=0; xmax=3;
PFDmax =1600;

zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);
zh4 = readtable(zh4_file,'Delimiter',',', 'ReadVariableNames', true);
ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);
ch2 = readtable(ch2_file,'Delimiter',',', 'ReadVariableNames', true);
ch3 = readtable(ch3_file,'Delimiter',',', 'ReadVariableNames', true);
ch4 = readtable(ch4_file,'Delimiter',',', 'ReadVariableNames', true);

%% 

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 300 600]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...
hold off
subplot(3,1,1); 
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0],'LineWidth',1);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
% legend('E')

hold off
subplot(3,1,2);
hold on
plot(ch1.time, ch1.ROS,'b','LineWidth',1);
plot(ch4.time, ch4.ROS, 'r','LineWidth',1);
axis([xmin xmax  0 4.5])
ylabel('ROS (uM)')
% ax = gca; ax.YColor = 'k';
legend('27oC','33oC')


% hold off
% subplot(5,1,3);
% % subplot(5,1,4);
% hold on
% plot(zh1.time, zh1.F_Zexpul,'b','LineWidth',1);
% plot(zh4.time, zh4.F_Zexpul,'r','LineWidth',1);
% axis([xmin xmax  0 3e2])
% ylabel('Zoox. release (cell cm^-^2 s^-^1)')
% % ax = gca; ax.YColor = 'k';
% legend('27oC','33oC')


hold off
subplot(3,1,3);
hold on
plot(zh1.time, zh1.dens,'b','LineWidth',1);
plot(zh4.time, zh4.dens,'r','LineWidth',1);
axis([xmin xmax  0 2.2e6])
ylabel('Zoox. density (cell cm^-^2)')
% ax = gca; ax.YColor = 'k';
legend('27oC','33oC')


samexaxis('abc','xmt','on','ytac','join','yld',1)