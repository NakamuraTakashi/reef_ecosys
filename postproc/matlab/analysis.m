% === ver 2017/03/09   Copyright (c) 2017 Takashi NAKAMURA  =====

dat_file = '.././input/G_Pn_site4-7.txt';

xmin=4; ymin=5;
PFDmax =2000;

dat = readtable(dat_file,'Delimiter','tab', 'ReadVariableNames', true);

t_exp = (2+45/60)/24;  % day
t_stp = 3/24;      % day

%% 
eco_file = '.././output/site04-ecosys_his.csv';
eco = readtable(eco_file,'Delimiter',',', 'ReadVariableNames', true);

tot_Pn = eco.coral1_Pn + eco.sedeco_Pn;
tot_G  = eco.coral1_G  + eco.sedeco_G ;
for i=1:8
    t_min = 4 + t_stp*(i-1);
    t_max = 4 + t_stp*(i-1) +t_exp;
    Pn(i) = mean(tot_Pn(t_min<eco.time & eco.time<t_max));
    G (i) = mean(tot_G (t_min<eco.time & eco.time<t_max));
end
%% 

eco_file = '.././output/site05-ecosys_his.csv';
eco = readtable(eco_file,'Delimiter',',', 'ReadVariableNames', true);

tot_Pn = eco.coral1_Pn + eco.sedeco_Pn;
tot_G  = eco.coral1_G  + eco.sedeco_G ;
for i=1:8
    t_min = 4 + t_stp*(i-1);
    t_max = 4 + t_stp*(i-1) +t_exp;
    Pn(8+i) = mean(tot_Pn(t_min<eco.time & eco.time<t_max));
    G (8+i) = mean(tot_G (t_min<eco.time & eco.time<t_max));
end

eco_file = '.././output/site06-ecosys_his.csv';
eco = readtable(eco_file,'Delimiter',',', 'ReadVariableNames', true);

tot_Pn = eco.coral1_Pn + eco.sedeco_Pn;
tot_G  = eco.coral1_G  + eco.sedeco_G ;
for i=1:8
    t_min = 4 + t_stp*(i-1);
    t_max = 4 + t_stp*(i-1) +t_exp;
    Pn(16+i) = mean(tot_Pn(t_min<eco.time & eco.time<t_max));
    G (16+i) = mean(tot_G (t_min<eco.time & eco.time<t_max));
end

eco_file = '.././output/site07-ecosys_his.csv';
eco = readtable(eco_file,'Delimiter',',', 'ReadVariableNames', true);

tot_Pn = eco.coral1_Pn + eco.sedeco_Pn;
tot_G  = eco.coral1_G  + eco.sedeco_G ;
for i=1:8
    t_min = 4 + t_stp*(i-1);
    t_max = 4 + t_stp*(i-1) +t_exp;
    Pn(24+i) = mean(tot_Pn(t_min<eco.time & eco.time<t_max));
    G (24+i) = mean(tot_G (t_min<eco.time & eco.time<t_max));
end
%% Model skill
Xm = Pn(:);     % Model output
Xo = dat.Pn(:); % Observed data
tmp = abs(Xm-mean(Xo)) + abs(Xo-mean(Xo));
Pn_Skill = 1-(Xm-Xo).'*(Xm-Xo)/(tmp.'*tmp)

Xm =G(:);     % Model output
Xo = dat.G(:); % Observed data
tmp = abs(Xm-mean(Xo)) + abs(Xo-mean(Xo));
G_Skill = 1-(Xm-Xo).'*(Xm-Xo)/(tmp.'*tmp)
%%


figure('Position',[50 50 400 400]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

scatter(Pn(1:8), dat.Pn(1:8),'filled','^');
hold on
scatter(Pn(9:16), dat.Pn(9:16),'filled','s');
scatter(Pn(17:24), dat.Pn(17:24),'filled','d');
scatter(Pn(25:32), dat.Pn(25:32),'filled','o');
fplot(@(x) x)
axis([-15,25,-15,25])
axis square
ylabel('Measured (mmol m^-^2 h^-^1)')
xlabel('Estimated (mmol m^-^2 h^-^1)')
legend('Site 4','Site 5','Site 6', 'Site 7','Location','southeast')

figure('Position',[500 50 400 400]);
scatter(G(1:8), dat.G(1:8),'filled','^');
hold on
scatter(G(9:16), dat.G(9:16),'filled','s');
scatter(G(17:24), dat.G(17:24),'filled','d');
scatter(G(25:32), dat.G(25:32),'filled','o');
fplot(@(x) x)
axis([-2,18,-2,18])
axis square
ylabel('Measured (mmol m^-^2 h^-^1)')
xlabel('Estimated (mmol m^-^2 h^-^1)')
legend('Site 4','Site 5','Site 6', 'Site 7','Location','southeast')

