% Plot TDR from OpenEMS results.
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
fstart = 0;
fstop = 20e9;
numfreq = 2001;
Z0 = 50;

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
% PORTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
portNamesAndNumbersList = containers.Map();

%% PORT - Port_1 - Port1
portStart = [ -1.2, 0, 49 ];
portStop  = [ 1.2, 1.5, 50 ];
portUnits = 1;
portExcitationAmplitude = 1.0;
portDirection = [0 1 0]*portExcitationAmplitude;
[CSX port{1}] = AddLumpedPort(CSX, 9900, 1, Z0*portUnits, portStart, portStop, portDirection, true);
portNamesAndNumbersList("Port1") = 1;

%% PORT - Port_2 - Port2
portStart = [ -1.2, 0, -50 ];
portStop  = [ 1.2, 1.5, -49 ];
portUnits = 1;
portExcitationAmplitude = 1.0;
portDirection = [0 1 0]*portExcitationAmplitude;
[CSX port{2}] = AddLumpedPort(CSX, 10000, 2, Z0*portUnits, portStart, portStop, portDirection);
portNamesAndNumbersList("Port2") = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POST-PROCESSING AND TIME DOMAIN PLOT GENERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq = linspace( fstart, fstop, numfreq );
port{1} = calcPort( port{1}, Sim_Path, freq, 'RefImpedance', Z0);
port{2} = calcPort( port{2}, Sim_Path, freq, 'RefImpedance', Z0);

% port.ut.tot total voltage (time-domain)
% port.it.tot total current (time-domain)
% port.ut.time voltage time vector
% port.it.time current time vector (same as voltage)

U1 = port{1}.ut.tot;
U2 = port{2}.ut.tot;
I1 = port{1}.it.tot;
I2 = port{2}.it.tot;
t = port{1}.ut.time;

U1_inc = 0.5 * (U1 + I1.* Z0);
U1_ref = U1 - U1_inc;
U2_inc = 0.5 * (U2 + I2.* Z0);
U2_ref = U2 - U2_inc;

figure
plot( t, U1./ U1_inc, 'k-', 'Linewidth', 2 );
hold on;
plot( t, U2./ U1_inc, 'r--', 'Linewidth', 2 );
hold on;
plot( t, U1_ref./ U1_inc, 'b--', 'Linewidth', 2 );
%ylim([0 2]);
xlim([0 6e-10]);
grid on;
grid minor on;
legend( 'U1', 'U2', 'U1 ref' );
ylabel('Port voltages (normalized to incident)');
xlabel('Time (s)');
savefig('voltages.png');

%% estimate impedance magnitude
r = U1_ref./ U1_inc;
Z = Z0 * (1+r)./(1-r);

figure
plot( t, Z, 'b-', 'Linewidth', 2 );
ylim([60 120]);
xlim([0 6e-10]);

grid on;
grid minor on;

title( 'Impedance vs Time' );
xlabel( 'Time (s)' );
ylabel( 'Impedance (ohm)' );
legend( 'Z' );

