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
Ctrl.f_sw = 3e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;           % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;           % [s] sampling time

% delay and hold
Ctrl.T_dh = 1.5*Ctrl.T_sp;         % [s] equiv. delay 

% alternating-current control
% bandwidth: 300 [Hz]
Ctrl.ACC.Kp = 0.23;                % [] Kp of ACC
Ctrl.ACC.Ki = 28;                  % [] Ki of ACC
Ctrl.ACC.wL = Grid.wg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF 
Ctrl.ACC.K_AD = 0;                 % [] active damping factor
Ctrl.ACC.SatLim = inf;             % [] Saturation limit of integrator

% alternating-voltage controller 
% bandwidth: 50 [Hz]
Ctrl.AVC.Kp = 0.3;                 % [] Kp of AVC
Ctrl.AVC.Ki = 2;                   % [] Ki of AVC
Ctrl.AVC.wC = Grid.wg*Inv.Filter.C; % [] cross-coupling term
Ctrl.AVC.f1 = Grid.fg;             % [] cross-coupling term
Ctrl.AVC.SatLim = inf;             % [] Anti-windup of AVC

%% Control Reference
Ctrl.V_ref_d = Grid.V_amp;         % [A] d-axis ref current
Ctrl.V_ref_q = 0;                  % [A] q-axis ref current
Ctrl.SetOP.time = [0,0.2,0.4,0.4,0.8,0.8];
Ctrl.SetOP.v_ref_d = [0,Ctrl.V_ref_d,Ctrl.V_ref_d,Ctrl.V_ref_d-50,Ctrl.V_ref_d-50,Ctrl.V_ref_d];
Ctrl.SetOP.v_ref_q = [Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q];

end
