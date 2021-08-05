%% Control Definition
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
Ctrl.f_sw = 10e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;            % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;            % [s] sampling time

% delay and hold
Ctrl.T_dh = 1.5*Ctrl.T_sp;         % [s] equiv. delay 

% alternating-current control
% bandwidth: 1000 [Hz]
Ctrl.ACC.Kp = 15.6;                 % [] Kp of ACC
Ctrl.ACC.Ki = 11014;                % [] Ki of ACC
Ctrl.ACC.wL = Grid.wg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*500;          % [] filter bandwidth of VFF 
Ctrl.ACC.K_AD = 0;                  % [] active damping factor
Ctrl.ACC.SatLim = inf;              % [] Saturation limit of integrator

% phase-locked loop
% bandwidth: 30 [Hz]
Ctrl.PLL.Kp = 2.3;                  % [] Kp of PLL
Ctrl.PLL.Ki = 251;                  % [] Ki of PLL
Ctrl.PLL.w1 = Grid.wg;         % [] ideal grid angular frequency
Ctrl.PLL.SatLim = inf;              % [] Saturation limit of integrator

%% Control Reference
Ctrl.I_ref_d = 10;                  % [A] d-axis ref current
Ctrl.I_ref_q = 0;                   % [A] q-axis ref current
Ctrl.SetOP.time = [0,0.4,0.4,0.8,0.8];
Ctrl.SetOP.i_ref_d = [Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d];
Ctrl.SetOP.i_ref_q = [Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q];

end
