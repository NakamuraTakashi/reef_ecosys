% === Copyright (c) 2025 Takashi NAKAMURA  =====

env_vprof0_file  = '../Projects/pelagic_bentic/output/test01-env_vprof_0000.csv';
env_vprof_file   = '../Projects/pelagic_bentic/output/test01-env_vprof_0240.csv';
sedeco_his0_file = '../Projects/pelagic_bentic/output/test01-sedeco_his_0000.csv';
sedeco_his_file  = '../Projects/pelagic_bentic/output/test01-sedeco_his_0240.csv';

vprof0  = readtable(env_vprof0_file);
vprof   = readtable(env_vprof_file);
sedeco0 = readtable(sedeco_his0_file);
sedeco  = readtable(sedeco_his_file);

N_plot=6;

%% Fugure 1 ===================================================
figure
iplot=1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
% yyaxis right
plot(vprof0.CPOC, vprof0.Depth, '-*b');
hold on
plot(vprof.CPOC, vprof.Depth, '-or');
ax = gca; 
% ax.YColor = 'k';
ax.YDir = 'reverse';
ylabel('Water depth (m)')
axis([0 1.5  0 10])

hold off
subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.CPOC(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.CPOC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('CPOC [nmol/g(DW)]')

axis([0 1.5  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.LPOC, vprof0.Depth, '-*b');
hold on
plot(vprof.LPOC, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.2  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.LPOC(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.LPOC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('LPOC [nmol/g(DW)]')

axis([0 1.5e3  0 20])
hold off


%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.RPOC, vprof0.Depth, '-*b');
hold on
plot(vprof.RPOC, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.3  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.RPOC(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.RPOC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('RPOC [nmol/g(DW)]')

axis([0 3e6  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.DIC, vprof0.Depth, '-*b');
hold on
plot(vprof.DIC, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 3e3  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.DIC(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.DIC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('DIC (umol/kg)')

axis([0 3e3  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
tmp=vprof0.PhyC1+vprof0.PhyC2+vprof0.PhyC3+vprof0.PhyC4;
plot(tmp, vprof0.Depth, '-*b');
hold on
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
hold off

% axis([0 30  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.ZooC1, vprof0.Depth, '-*b');
hold on
plot(vprof.ZooC1, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.5  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('ZooC (umol/L)')
hold off

% axis([0 30  0 20])

%% 
fontname("Arial")
fontsize(10,"points")

%% Fugure 2 ===================================================
figure
iplot=1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
% yyaxis right
plot(vprof0.CPOC_13C, vprof0.Depth, '-*b');
hold on
plot(vprof.CPOC_13C, vprof.Depth, '-or');
ax = gca; 
% ax.YColor = 'k';
ax.YDir = 'reverse';
ylabel('Water depth (m)')
axis([0 1.5  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.CPOC_13C(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.CPOC_13C(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('CPO^1^3C [nmol/g(DW)]')

axis([0 1.5  0 20])
hold off
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.LPOC_13C, vprof0.Depth, '-*b');
hold on
plot(vprof.LPOC_13C, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 5e-4  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.LPOC_13C(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.LPOC_13C(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('LPO^1^3C [nmol/g(DW)]')

axis([0 3  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.RPOC_13C, vprof0.Depth, '-*b');
hold on
plot(vprof.RPOC_13C, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 2e-4  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.RPOC_13C(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.RPOC_13C(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('RPO^1^3C [nmol/g(DW)]')

axis([0 3  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.DIC_13C, vprof0.Depth, '-*b');
hold on
plot(vprof.DIC_13C, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 7e-2  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.DIC_13C(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.DIC_13C(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('DI^1^3C (umol/kg)')

axis([0 5e-1  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
tmp=vprof0.PhyC1_13C+vprof0.PhyC2_13C+vprof0.PhyC3_13C+vprof0.PhyC4_13C;
plot(tmp, vprof0.Depth, '-*b');
hold on
tmp=vprof.PhyC1_13C+vprof.PhyC2_13C+vprof.PhyC3_13C+vprof.PhyC4_13C;
plot(tmp, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 3e-4  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('Phy^1^3Ctot (umol/L)')
hold off

% axis([0 30  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.ZooC1_13C, vprof0.Depth, '-*b');
hold on
plot(vprof.ZooC1_13C, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 1e-5  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('Zoo^1^3C (umol/L)')
hold off

% axis([0 30  0 20])

%% 
fontname("Arial")
fontsize(10,"points")

%% Fugure 3 ===================================================
figure
iplot=1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
% yyaxis right
plot(vprof0.DO, vprof0.Depth, '-*b');
hold on
plot(vprof.DO, vprof.Depth, '-or');
ax = gca; 
% ax.YColor = 'k';
ax.YDir = 'reverse';
ylabel('Water depth (m)')
axis([0 250  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.O2(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.O2(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('DO (umol/L)')

axis([0 250  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.NO3, vprof0.Depth, '-*b');
hold on
plot(vprof.NO3, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.1  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.NO3(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.NO3(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NO_3 (umol/L)')

axis([0 0.1  0 20])
hold off

%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.NH4, vprof0.Depth, '-*b');
hold on
plot(vprof.NH4, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 1  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.NH4(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.NH4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NH_4 (umol/L)')

axis([0 100  0 20])
hold off
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.PO4, vprof0.Depth, '-*b');
hold on
plot(vprof.PO4, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.1  0 10])
hold off

subplot(3, N_plot, 2*N_plot+iplot);
plot(sedeco0.PO4(2:21), sedeco0.zr(2:21), '-*b');
hold on
plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('PO_4 (umol/L)')

axis([0 10  0 20])
hold off
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
tmp=vprof0.PhyC1+vprof0.PhyC2+vprof0.PhyC3+vprof0.PhyC4;
plot(tmp, vprof0.Depth, '-*b');
hold on
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
hold off

% axis([0 30  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, [iplot N_plot+iplot]); 
plot(vprof0.ZooC1, vprof0.Depth, '-*b');
hold on
plot(vprof.ZooC1, vprof.Depth, '-or');
ax = gca; 
ax.YDir = 'reverse';
axis([0 0.5  0 10])

% subplot(3, N_plot, 2*N_plot+iplot);
% plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
% ax = gca; 
% ax.YDir = 'reverse';
xlabel('ZooC (umol/L)')
hold off

% axis([0 30  0 20])

%% 
fontname("Arial")
fontsize(10,"points")
