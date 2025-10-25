% === Copyright (c) 2025 Takashi NAKAMURA  =====

% env_vprof_file = '../Projects/pelagic_bentic/output/test01-env_vprof_0240.csv';
sedeco_his_file = '../Projects/pelagic_bentic/output/test01-sedeco_his_0240.csv';

% vprof  = readtable(env_vprof_file);
sedeco = readtable(sedeco_his_file);

N_plot=4;

%% 

% figure('PaperSize',[20 30],...
%     'OuterPosition',[0 0 900 900]);
%     'GraphicsSmoothing','off',...
%     'Color',[1 1 1],...

%% 
iplot=1;

subplot(3, N_plot, iplot); 
plot(sedeco.O2(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('DO (umol/L)')
axis([0 220  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.NO3(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NO_3 (umol/L)')
axis([0 0.1  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.NH4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('NH_4 (umol/L)')
axis([0 100  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.PO4(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('PO_4 (umol/L)')
axis([0 10  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.Mn2(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('Mn^2^+ (umol/L)')
axis([0 1e3  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.Fe2(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('Fe^2^+ (umol/L)')
axis([0 1e2  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.H2S(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('H_2S (umol/L)')
axis([0 2e-6  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.TA(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('TA (umol/kg)')
axis([0 4e3  0 20])
%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.DIC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
ylabel('Sediment depth (cm)')
xlabel('DIC (umol/kg)')
axis([0 3e3  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.LPOC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('LPOC [nmol/g(DW)]')
axis([0 1.5e3  0 20])

%% 
iplot=iplot+1;

subplot(3, N_plot, iplot);
plot(sedeco.RPOC(2:21), sedeco.zr(2:21), '-or');
ax = gca; 
ax.YDir = 'reverse';
xlabel('RPOC [nmol/g(DW)]')
axis([0 3e6  0 20])


%% 
fontname("Arial")
fontsize(10,"points")
