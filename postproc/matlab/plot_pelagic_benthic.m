% === Copyright (c) 2025 Takashi NAKAMURA  =====

env_vprof_file = '../Projects/pelagic_bentic/output/test01-env_vprof_0240.csv';
sedeco_his_file = '../Projects/pelagic_bentic/output/test01-sedeco_his_0240.csv';

vprof  = readtable(env_vprof_file);
sedeco = readtable(sedeco_his_file);

N_plot=8;

%% 

% figure('PaperSize',[20 30],...
%     'OuterPosition',[0 0 900 900]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

%% 
iplot=1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
% yyaxis right
plot(vprof.DO, vprof.Depth, '-or');
ax = gca; 
% ax.YColor = 'k';
ax.YDir = 'reverse';
ylabel('Water depth (m)')
axis([0 250  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.O2(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('DO (umol/L)')

axis([0 250  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.DIC, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 4e3  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.DIC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('DIC (umol/kg)')

axis([0 4e3  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.TA, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 4e3  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.TA(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('TA (umol/kg)')

axis([0 4e3  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.NO3, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.1  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.NO3(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NO_3 (umol/L)')

axis([0 0.1  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.NH4, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 1  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.NH4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NH_4 (umol/L)')

axis([0 100  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.PO4, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.1  0 10])

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('PO_4 (umol/L)')

axis([0 10  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
tmp=vprof.PhyC1+vprof.PhyC2+vprof.PhyC3+vprof.PhyC4;
plot(tmp, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 20  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('PhyCtot (umol/L)')

% axis([0 30  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof.ZooC1, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.5  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('ZooC (umol/L)')

% axis([0 30  0 20])

%% 
fontname("Arial")
fontsize(10,"points")
