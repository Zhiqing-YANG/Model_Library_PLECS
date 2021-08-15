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
Ctrl.T_del_add = Ctrl.T_sp;         % [s] additional delay time

% alternating-current control
% bandwidth: 1000 [Hz]
Ctrl.ACC.Kp = 15.6;                 % [] Kp of ACC
Ctrl.ACC.Ki = 11014;                % [] Ki of ACC
Ctrl.ACC.wL = Grid.wg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*500;          % [] filter bandwidth of VFF 
Ctrl.ACC.K_AD = 0;                  % [] active damping factor
Ctrl.ACC.SatLim = 200;              % [] Saturation limit of integrator

% alternating-voltage controller 
% bandwidth: 100 [Hz]
Ctrl.AVC.Kp = 6e-3;                 % [] Kp of AVC
Ctrl.AVC.Ki = 300;                  % [] Ki of AVC
Ctrl.AVC.wC = Grid.wg*Inv.Filter.C; % [] cross-coupling term
Ctrl.AVC.f1 = Grid.fg;              % [] cross-coupling term
Ctrl.AVC.SatLim = 30;               % [] Anti-windup of AVC

%% Calibration
Ctrl.Calib = Sensor;

%% Protection
Ctrl.Limit.V_ac = 180;
Ctrl.Limit.I_ac = 20;
Ctrl.Limit.V_dc = 250;

end
