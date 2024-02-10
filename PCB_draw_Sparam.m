% Plot S11, S21 parameters from OpenEMS results.
%
% To be run with GNU Octave or MATLAB.
% FreeCAD to OpenEMS plugin by Lubomir Jagos,
% see https://github.com/LubomirJagos/FreeCAD-OpenEMS-Export
%
% This file has been automatically generated by Lubomir Jagos plugin and manually changed by lowpon
%

close all
clear
clc

%% Change the current folder to the folder of this m-file.
if(~isdeployed)
  mfile_name          = mfilename('fullpath');
  [pathstr,name,ext]  = fileparts(mfile_name);
  cd(pathstr);
end

%% constants
physical_constants;
unit    = 0.001; % Model coordinates and lengths will be specified in mm.
fc_unit = 0.001; % STL files are exported in FreeCAD standard units (mm).

Sim_Path = 'simulation_output';
currDir = strrep(pwd(), '\', '\\');
display(currDir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COORDINATE SYSTEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = InitCSX('CoordSystem', 0); % Cartesian coordinate system.
mesh.x = []; % mesh variable initialization (Note: x y z implies type Cartesian).
mesh.y = [];
mesh.z = [];
CSX = DefineRectGrid(CSX, unit, mesh); % First call with empty mesh to set deltaUnit attribute.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXCITATION Step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATERIALS AND GEOMETRY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = AddMetal( CSX, 'PEC' );

%% MATERIAL - Air
CSX = AddMaterial(CSX, 'Air');
CSX = SetMaterialProperty(CSX, 'Air', 'Epsilon', 1);

%% MATERIAL - FR4
CSX = AddMaterial(CSX, 'FR4');
CSX = SetMaterialProperty(CSX, 'FR4', 'Epsilon', 4.2, 'Mue', 1, 'Kappa', 0.0001);

%% MATERIAL - PEC
CSX = AddMetal(CSX, 'PEC');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRID LINES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% GRID - XYZ - Box (Fixed Distance)
mesh.x = [ mesh.x (-15:1.5:15) ];
mesh.y = [ mesh.y (-5:0.1:5) ];
mesh.z = [ mesh.z (-60:1.5:60) ];
CSX = DefineRectGrid(CSX, unit, mesh);

xmin = -15;
xmax = 15;
ymin = -5;
ymax = 5;
zmin = -60;
zmax = 60;
mesh.x = [ -15, -14.2857, -13.5714, -12.8571, -12.1429, -11.4286, -10.7143, -10, -9.31818, -8.63636, -7.95455, -7.27273, -6.59091, -5.90909, -5.22727, -4.54545, -3.86364, -3.18182, -2.5, -1.85, -1.35, -0.9, -0.45, 0, 0.45, 0.9, 1.35, 1.85, 2.5, 3.18182, 3.86364, 4.54545, 5.22727, 5.90909, 6.59091, 7.27273, 7.95455, 8.63636, 9.31818, 10, 10.7143, 11.4286, 12.1429, 12.8571, 13.5714, 14.2857, 15 ]
CSX = DefineRectGrid(CSX, unit, mesh);

xmin = -15;
xmax = 15;
ymin = -5;
ymax = 5;
zmin = -60;
zmax = 60;
mesh.z = [ -60, -59.2857, -58.5714, -57.8571, -57.1429, -56.4286, -55.7143, -55, -54.3917, -53.7833, -53.175, -52.5667, -51.9583, -51.35, -50.675, -50, -49.325, -48.65, -47.9512, -47.2524, -46.5537, -45.8549, -45.1561, -44.4573, -43.7585, -43.0598, -42.361, -41.6622, -40.9634, -40.2646, -39.5659, -38.8671, -38.1683, -37.4695, -36.7707, -36.072, -35.3732, -34.6744, -33.9756, -33.2768, -32.578, -31.8793, -31.1805, -30.4817, -29.7829, -29.0841, -28.3854, -27.6866, -26.9878, -26.289, -25.5902, -24.8915, -24.1927, -23.4939, -22.7951, -22.0963, -21.3976, -20.6988, -20, -19.2857, -18.5714, -17.8571, -17.1429, -16.4286, -15.7143, -15, -14.2857, -13.5714, -12.8571, -12.1429, -11.4286, -10.7143, -10, -9.28571, -8.57143, -7.85714, -7.14286, -6.42857, -5.71429, -5, -4.28571, -3.57143, -2.85714, -2.14286, -1.42857, -0.714286, 0, 0.705072, 1.41014, 2.11522, 2.82029, 3.52536, 4.23043, 4.93551, 5.64058, 6.34565, 7.05072, 7.7558, 8.46087, 9.16594, 9.87101, 10.5761, 11.2812, 11.9862, 12.6913, 13.3964, 14.1014, 14.8065, 15.5116, 16.2167, 16.9217, 17.6268, 18.3319, 19.037, 19.742, 20.4471, 21.1522, 21.8572, 22.5623, 23.2674, 23.9725, 24.6775, 25.3826, 26.0877, 26.7928, 27.4978, 28.2029, 28.908, 29.613, 30.3181, 31.0232, 31.7283, 32.4333, 33.1384, 33.8435, 34.5486, 35.2536, 35.9587, 36.6638, 37.3688, 38.0739, 38.779, 39.4841, 40.1891, 40.8942, 41.5993, 42.3043, 43.0094, 43.7145, 44.4196, 45.1246, 45.8297, 46.5348, 47.2399, 47.9449, 48.65, 49.325, 50, 50.675, 51.35, 51.9583, 52.5667, 53.175, 53.7833, 54.3917, 55, 55.7143, 56.4286, 57.1429, 57.8571, 58.5714, 59.2857, 60 ]
CSX = DefineRectGrid(CSX, unit, mesh);

xmin = -15;
xmax = 15;
ymin = -5;
ymax = 5;
zmin = -60;
zmax = 60;
mesh.y = [ -5, -4.47072, -3.84144, -3.21216, -2.58289, -1.95361, -1.46151, -1.0767, -0.775775, -0.540454, -0.356434, -0.212531, -0.1, 0, 0.375, 0.75, 1.125, 1.5, 1.6, 1.71253, 1.85643, 2.04045, 2.27578, 2.5767, 2.96151, 3.45361, 4.08289, 4.71216, 5 ]
CSX = DefineRectGrid(CSX, unit, mesh);

%% GRID - Y1pcb - Sub (Fixed Count)
mesh.y(mesh.y >= 0 & mesh.y <= 1.5) = [];
mesh.y = [ mesh.y linspace(0,1.5,0) ];
CSX = DefineRectGrid(CSX, unit, mesh);

%% GRID - Ypcb - Sub (Fixed Count)
mesh.y(mesh.y >= 0 & mesh.y <= 1.5) = [];
mesh.y = [ mesh.y linspace(0,1.5,6) ];
CSX = DefineRectGrid(CSX, unit, mesh);

%% GRID - XYZ_smooth - Top (Smooth Mesh)
%% GRID - XYZ_smooth - Bottom (Smooth Mesh)
%% GRID - XYZ_smooth - Port1 (Smooth Mesh)
%% GRID - XYZ_smooth - Port2 (Smooth Mesh)
smoothMesh = {};
mesh.x(mesh.x >= -10 & mesh.x <= 10) = [];
smoothMesh.x = [-10.0, -2.2, -1.2, -1.2, 1.2, 1.2, 2.2, 10.0];
smoothMesh.x = AutoSmoothMeshLines(smoothMesh.x, 0.5);
mesh.x = [mesh.x smoothMesh.x];
mesh.y(mesh.y >= -0.1 & mesh.y <= 1.6) = [];
smoothMesh.y = [-0.1, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 1.6];
smoothMesh.y = AutoSmoothMeshLines(smoothMesh.y, 0.5);
mesh.y = [mesh.y smoothMesh.y];
mesh.z(mesh.z >= -55 & mesh.z <= 55) = [];
smoothMesh.z = [-55.0, -50.0, -50.0, -49.0, 49.0, 50.0, 50.0, 55.0];
smoothMesh.z = AutoSmoothMeshLines(smoothMesh.z, 0.5);
mesh.z = [mesh.z smoothMesh.z];
CSX = DefineRectGrid(CSX, unit, mesh);

%% GRID - Z_port - Port1 (Fixed Count)
mesh.z(mesh.z >= 49 & mesh.z <= 50) = [];
mesh.z = [ mesh.z linspace(49,50,5) ];
CSX = DefineRectGrid(CSX, unit, mesh);

%% GRID - Z_port - Port2 (Fixed Count)
mesh.z(mesh.z >= -50 & mesh.z <= -49) = [];
mesh.z = [ mesh.z linspace(-50,-49,5) ];
CSX = DefineRectGrid(CSX, unit, mesh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MINIMAL GRIDLINES SPACING, removing gridlines which are closer as defined in GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh.x = sort(mesh.x);
mesh.y = sort(mesh.y);
mesh.z = sort(mesh.z);

for k = 1:length(mesh.x)-1
  if (mesh.x(k) ~= inf && abs(mesh.x(k+1)-mesh.x(k)) <= 0.01)
    display(["Removing line at x: " num2str(mesh.x(k+1))]);
    mesh.x(k+1) = inf;
   end
end

for k = 1:length(mesh.y)-1
  if (mesh.y(k) ~= inf && abs(mesh.y(k+1)-mesh.y(k)) <= 0.01)
    display(["Removing line at y: " num2str(mesh.y(k+1))]);
    mesh.y(k+1) = inf;
   end
end

for k = 1:length(mesh.z)-1
  if (mesh.z(k) ~= inf && abs(mesh.z(k+1)-mesh.z(k)) <= 0.01)
    display(["Removing line at z: " num2str(mesh.z(k+1))]);
    mesh.z(k+1) = inf;
   end
end

mesh.x(isinf(mesh.x)) = [];
mesh.y(isinf(mesh.y)) = [];
mesh.z(isinf(mesh.z)) = [];

CSX = DefineRectGrid(CSX, unit, mesh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PORTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
portNamesAndNumbersList = containers.Map();

%% PORT - Port_1 - Port1
portStart = [ -1.2, 0, 49 ];
portStop  = [ 1.2, 1.5, 50 ];
portR = 50;
portUnits = 1;
portExcitationAmplitude = 1.0;
portDirection = [0 1 0]*portExcitationAmplitude;
[CSX port{1}] = AddLumpedPort(CSX, 9900, 1, portR*portUnits, portStart, portStop, portDirection, true);
portNamesAndNumbersList("Port1") = 1;


%% PORT - Port_2 - Port2
portStart = [ -1.2, 0, -50 ];
portStop  = [ 1.2, 1.5, -49 ];
portR = 50;
portUnits = 1;
portExcitationAmplitude = 1.0;
portDirection = [0 1 0]*portExcitationAmplitude;
[CSX port{2}] = AddLumpedPort(CSX, 10000, 2, portR*portUnits, portStart, portStop, portDirection);
portNamesAndNumbersList("Port2") = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POST-PROCESSING AND FREQUENCY DOMAIN PLOT GENERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq = linspace( 0, 20e9, 1601 );
port = calcPort( port, Sim_Path, freq, 'RefImpedance', 50);

s11 = port{1}.uf.ref./ port{1}.uf.inc;
s21 = port{2}.uf.ref./ port{1}.uf.inc;

s11_dB = 20*log10(s11);
s21_dB = 20*log10(s21);

figure
plot(freq/1e9, s11_dB, 'b-', 'LineWidth', 2);
hold on;
grid on;
grid minor on;
plot(freq/1e9, s21_dB, 'r-','LineWidth',2);
legend('S_{11}','S_{21}');
ylabel('S-Parameter (dB)','FontSize',12);
xlabel('frequency (GHz) \rightarrow','FontSize',12);
ylim([-40 2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POST-PROCESSING AND TIME DOMAIN PLOT GENERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U1 = ReadUI('port_ut1',Sim_Path, freq);
I1 = ReadUI('port_it1',Sim_Path, freq);
Z1 = U1.TD{1}.val./I1.TD{1}.val;
t1 = U1.TD{1}.t;

%U2 = ReadUI('port_ut2',Sim_Path);
%I2 = ReadUI('port_it2',Sim_Path);
%Z2 = U2.TD{1}.val./I2.TD{1}.val;
%t2 = U2.TD{1}.t;

figure
plot( 1e9*t1, Z1, 'b-', 'Linewidth', 2 );
grid on;
grid minor on;
title( 'Impedance vs Time' );
xlabel( 'Time (nS)' );
ylabel( 'Impedance (ohm)' );
legend( 'port 1','port 2');
xlim([0 2]);
ylim([0 120]);

figure
plot( 1e9*port{1}.ut.time, port{1}.ut.tot, 'b-', 'Linewidth', 2 );
hold on;
grid on;
grid minor on;
plot( 1e9*port{2}.ut.time, port{2}.ut.tot, 'r-', 'Linewidth', 2 );

title( 'Voltage vs Time' );
xlabel( 'Time (nS)' );
ylabel( 'Voltage (V)' );
legend( 'port 1','port 2');
xlim([0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE PLOT DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename = 'openEMS_simulation_sParam_dB.csv';

%% write header to file
textHeader = 'f(Hz);S11(dB);S21(dB)';
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', textHeader);
fclose(fid);

%% write data to end of file
dlmwrite(filename, [abs(freq)', s11_dB', s21_dB'],'delimiter',';','precision',6, '-append');

%% export sparameter to touchstone file
spara = [];
color_code = {'k-','r--'};

for n=1:2
  port{n} = calcPort( port{n}, Sim_Path, freq, 'RefImpedance', 50);
  figure
  hold on
  grid on
  grid minor on
  for p=1:2
    spara(p,n,:) = port{p}.uf.ref./port{n}.uf.inc;
    plot(freq, squeeze(20*log10(abs(spara(p,n,:)))),color_code{p},'Linewidth',2);
  end
end
write_touchstone('s', freq, spara(p,n,:), [Sim_Path '.s2p']);
