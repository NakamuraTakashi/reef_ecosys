% === Copyright (c) 2017 Takashi NAKAMURA  =====

% zph1_file = '../Projects/coral/output/eco5-zphot1_his.csv';
zph1_file = '../Projects/coral_exp_T04/output/Pre_2w-zphot1_his.csv';

xmin=0; xmax=7;
PFDmax =2000;

zh1 = readtable(zph1_file,'Delimiter',',', 'ReadVariableNames', true);

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
plot(zh1.time, zh1.QAo,'b');
plot(zh1.time, zh1.QAr,'-r');
plot(zh1.time, zh1.QAi,'-g');
axis([xmin xmax  0 2.5e-6])
ylabel('RCII (pmol cell^-^1)')
ax = gca; ax.YColor = 'k';
legend('QAo','QAr','QAi','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,2);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.Fv_Fm,'b');
plot(zh1.time, zh1.kr,'-r');
plot(zh1.time, zh1.s_ab,'-g');
ax = gca; ax.YColor = 'k';
axis([xmin xmax  0 1.0])
ylabel('Fv/Fm, Rubisco act., reapir')
ax = gca; ax.YColor = 'k';
legend('Fv/Fm','kr','s_ab','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,3);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.Y_II_,'b');
axis([xmin xmax  0 1.2])
hold on
ylabel('Y(II)')
ax = gca; ax.YColor = 'k';
legend('Y(II)','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,4);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.Pg,'b');
axis([xmin xmax  0 0.001])
hold on
ylabel('Pg (pmolC cell-^1 s^-^1)')
ax = gca; ax.YColor = 'k';
legend('Pg','E', 'Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,5);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.J_ea,'b');
plot(zh1.time, zh1.J_ep,'-r');
plot(zh1.time, zh1.J_ee,'-g');
plot(zh1.time, zh1.J_ep_in,'-c');
axis([xmin xmax  0 0.002])
ylabel('Je- (pmol cell^-^1)')
ax = gca; ax.YColor = 'k';
legend('Jea','Jep','Jee','Jepin','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,6);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.F_ROS, 'b');
axis([xmin xmax  0 1e-3])
hold on
ylabel('FROS (pmol cell^-^1 s^-^1)')
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
plot(zh1.time, zh1.Ji2a,'b');
plot(zh1.time, zh1.Ja2i,'-r');
axis([xmin xmax  0 1e-10])
ylabel('JRCII (pmol cell^-^1)')
ax = gca; ax.YColor = 'k';
legend('Ji2a','Ja2i','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')

hold off
subplot(4,2,8);
yyaxis right
plot(zh1.time, zh1.PFD, 'Color', [1 0.6 0]);
ax = gca; ax.YColor = 'k';
ylabel('E (umol m^-^2 s^-^1)')
axis([xmin xmax  0 PFDmax])
yyaxis left
hold on
plot(zh1.time, zh1.kr,'b');
plot(zh1.time, zh1.Chl,'-r');
axis([xmin xmax  0 5e3])
ylabel('k (s^-^1)')
ax = gca; ax.YColor = 'k';
legend('kr','Chl','E', 'Location','southoutside','Location','southoutside','Orientation','horizontal')


