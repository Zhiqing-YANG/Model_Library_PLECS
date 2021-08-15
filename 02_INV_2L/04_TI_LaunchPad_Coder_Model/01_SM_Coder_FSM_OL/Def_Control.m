%% Control Definition
% ########################################################################
% Define the object of an inverter controller
% Input:
%       - [obj] grid parameter 
%       - [obj] inverter parameter 
% Output:
%       - [obj] control parameter 
% Establishment: 24.02.2021 Liu Yu, Tianxiao Chen, PGS, RWTH Aachen
% ########################################################################

function Ctrl = Def_Control(Grid,Inv,Sensor)
%% Control Parameters
% modulation and sampling 
Ctrl.f_sw = 10e3;                   % [Hz] inverter switching frequency   
Ctrl.f_sp = 2*Ctrl.f_sw;            % [Hz] sampling frequency
Ctrl.T_sw = 1/Ctrl.f_sw;            % [s] switching period
Ctrl.T_sp = 1/Ctrl.f_sp;            % [s] sampling time
Ctrl.T_dead = 0.1e-6;               % [s] blanking time

% grid frequency
Ctrl.fg = Grid.fg;                  % [Hz] grid frequency

%% Calibration
Ctrl.Calib = Sensor;

%% Protection
Ctrl.Limit.V_ac = 180;
Ctrl.Limit.I_ac = 20;
Ctrl.Limit.V_dc = 250;

end
