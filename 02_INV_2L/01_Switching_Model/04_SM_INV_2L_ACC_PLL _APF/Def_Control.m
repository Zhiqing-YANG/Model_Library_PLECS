%% Inverter Definition
% ########################################################################
% Define the object of an inverter controller
% Input:
%       - [obj] grid parameter 
%       - [obj] inverter parameter 
% Output:
%       - [obj] control parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Ctrl = Def_Control(Grid,Inv)
%% Control Parameters
% modulation and sampling 
Ctrl.f_sw = 20e3;                  % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;           % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;           % [s] sampling time

% delay and hold
Ctrl.T_dh = 1.5*Ctrl.T_sp;         % [s] equiv. delay 

% alternating-current control
Ctrl.ACC.Kp = 40;                  % [] Kp of ACC
Ctrl.ACC.Ki = 20;                  % [] Ki of ACC
Ctrl.ACC.wL = 2*pi*Grid.fg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*20e3;        % [] filter bandwidth of VFF
Ctrl.ACC.SatLim = inf;             % [] Saturation limit of integrator

% phase-locked loop
Ctrl.PLL.Kp = 0.36;                % [] Kp of PLL
Ctrl.PLL.Ki = 40;                  % [] Ki of PLL
Ctrl.PLL.w1 = 2*pi*Grid.fg;        % [] ideal grid angular frequency
Ctrl.PLL.SatLim = inf;             % [] Saturation limit of integrator

% active power filter
Ctrl.APF.wc = 2*pi*10;              % [rad/s] cutoff frequency

%% Control Reference
Ctrl.I_ref_d = 1000;               % [A] d-axis ref current
Ctrl.I_ref_q = 0;                  % [A] q-axis ref current
Ctrl.SetOP.time = [0,0.2,0.2,0.6,0.6];
Ctrl.SetOP.i_ref_d = [Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d+300,Ctrl.I_ref_d+300,Ctrl.I_ref_d];
Ctrl.SetOP.i_ref_q = [Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q];

end
