%% Inverter Definition
% ########################################################################
% Define object of a central inverter
% Output:
%       - [obj] inverter parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Ctrl = Def_Control(Grid,Inv)

% modulation and sampling 
Ctrl.f_sw = 3e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;           % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;           % [s] sampling time

% alternating-current control
Ctrl.ACC.Kp = 0.23;                % [] Kp of ACC
Ctrl.ACC.Ki = 28;                  % [] Ki of ACC
Ctrl.ACC.wL = 2*pi*Grid.fg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF
Ctrl.ACC.SatLim = inf;             % [] Saturation limit of integrator

% alternating voltage controller 
Ctrl.AVC.Kp = 0.2;                 % [] Kp of AVC
Ctrl.AVC.Ki = 2;                   % [] Ki of AVC
Ctrl.AVC.wC = 2*pi*Grid.fg*Inv.Filter.C; % [] cross-coupling term
Ctrl.AVC.f1 = Grid.fg;             % [] cross-coupling term
Ctrl.AVC.SatLim = inf;             % [] Anti-windup of AVC

% control reference
Ctrl.V_ref_d = Grid.V_amp;         % [A] d-axis ref current
Ctrl.V_ref_q = 0;                  % [A] q-axis ref current
Ctrl.SetOP.time = [0,0.2,0.4,0.4,0.8,0.8];
Ctrl.SetOP.v_ref_d = [0,Ctrl.V_ref_d,Ctrl.V_ref_d,Ctrl.V_ref_d-50,Ctrl.V_ref_d-50,Ctrl.V_ref_d];
Ctrl.SetOP.v_ref_q = [Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q,Ctrl.V_ref_q];

end
