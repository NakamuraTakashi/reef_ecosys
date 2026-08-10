% === Copyright (c) 2017 Takashi NAKAMURA  =====

zh1_file = '.././output/N18_33oC/eco5-zphot1_his.csv';
zh2_file = '.././output/N18_33oC_nTdPI/eco5-zphot1_his.csv';
zh3_file = '.././output/N18_33oC_nPI/eco5-zphot1_his.csv';

xmin=5; xmax=6;
PFDmax =1600;

zh1 = readtable(zh1_file,'Delimiter',',', 'ReadVariableNames', true);
zh2 = readtable(zh2_file,'Delimiter',',', 'ReadVariableNames', true);
zh3 = readtable(zh3_file,'Delimiter',',', 'ReadVariableNames', true);
zh4 = readtable(zh4_file,'Delimiter',',', 'ReadVariableNames', true);
% ch1 = readtable(ch1_file,'Delimiter',',', 'ReadVariableNames', true);

figure('PaperSize',[20 30],...
    'OuterPosition',[0 0 240 600]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

hold off
subplot(3,1,1); 
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0],'LineWidth',1);
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
legend('E')

hold off
subplot(3,1,2);
hold on
plot(zh1.time, zh1.Fv_Fm,'b','LineWidth',1);
plot(zh2.time, zh2.Fv_Fm,'Color', [0 0.7 0],'LineWidth',1);
plot(zh3.time, zh3.Fv_Fm,'r','LineWidth',1);
axis([xmin xmax  0 1])
ylabel('Fv/Fm')
legend('27oC','33oC')

hold off
subplot(3,1,3);
hold on
plot(zh1.time, zh1.Yield,'b','LineWidth',1);
plot(zh2.time, zh2.Yield,'Color', [0 0.7 0],'LineWidth',1);
plot(zh3.time, zh3.Yield,'r','LineWidth',1);
axis([xmin xmax  0 1])
hold on
ylabel('Yield')
legend('27oC','33oC')

samexaxis('abc','xmt','on','ytac','join','yld',1)


figure('PaperSize',[20 30],...
    'OuterPosition',[240 0 240 600]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

hold off
subplot(3,1,1); 
hold on
plot(zh1.time, zh1.J_ep_in,'b','LineWidth',1);
plot(zh1.time, zh1.J_ep,'Color', [0 0.7 1],'LineWidth',1);
plot(zh2.time, zh2.J_ep_in,'Color', [0 0.7 0],'LineWidth',1);
plot(zh2.time, zh2.J_ep,'Color', [0 1 0.5],'LineWidth',1);
plot(zh3.time, zh3.J_ep_in,'r','LineWidth',1);
plot(zh3.time, zh3.J_ep,'Color', [1 0.6 0.6],'LineWidth',1);
axis([xmin xmax  0 0.0015])
ylabel('Je- (pmol cell^-^1)')
ax = gca; ax.YColor = 'k';
legend('JPSII','JP','JPSII','JP','JPSII','JP')

hold off
subplot(3,1,2);
hold on
plot(zh1.time, zh1.Pg,'b','LineWidth',1);
plot(zh2.time, zh2.Pg,'Color', [0 0.7 0],'LineWidth',1);
plot(zh3.time, zh3.Pg,'r','LineWidth',1);
axis([xmin xmax  0 0.00032])
ylabel('Pg (pmolC cell-^1 s^-^1)','LineWidth',1)
legend('27oC','33oC')

hold off
subplot(3,1,3);
hold on
plot(zh1.time, zh1.F_ROS,'b','LineWidth',1);
plot(zh2.time, zh2.F_ROS,'Color', [0 0.7 0],'LineWidth',1);
plot(zh3.time, zh3.F_ROS,'r','LineWidth',1);
axis([xmin xmax  0 2.4e-4])
ylabel('FROS (pmol cell^-^1 s^-^1)')
legend('27oC','33oC')

samexaxis('abc','xmt','on','ytac','join','yld',1)
