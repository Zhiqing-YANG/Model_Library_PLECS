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
Ctrl.f_sw = 3e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;           % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;           % [s] sampling time

% alternating-current control
% bandwidth: 300 [Hz]
Ctrl.ACC.Kp = 0.23;                % [] Kp of ACC
Ctrl.ACC.Ki = 28;                  % [] Ki of ACC
Ctrl.ACC.wL = Grid.wg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF 
Ctrl.ACC.K_AD = 0.05;              % [] active damping factor
Ctrl.ACC.SatLim = inf;             % [] Saturation limit of integrator

% phase-locked loop
% bandwidth: 30 [Hz]
Ctrl.PLL.Kp = 0.36;                % [] Kp of PLL
Ctrl.PLL.Ki = 40;                  % [] Ki of PLL
Ctrl.PLL.w1 = Grid.wg;             % [] ideal grid angular frequency
Ctrl.PLL.SatLim = inf;             % [] Saturation limit of integrator

% direct-voltage control 
% bandwidth: 20 [Hz]
Ctrl.DVC.Kp = -3.6;                % [] Kp of DVC  
Ctrl.DVC.Ki = -239;                % [] Ki of DVC
Ctrl.DVC.SatLim = inf;             % [] Saturation limit of integrator

%% Control Reference
Ctrl.I_ref_d = Inv.OP.V_dc*Inv.OP.I_pv/(1.5*Grid.V_amp);           % [A] d-axis ref current
Ctrl.I_ref_q = 0;                       % [A] q-axis ref current
Ctrl.V_ref_dc = Inv.OP.V_dc;            % [A] dc ref voltage
Ctrl.SetOP.time = [0,0.4,0.4,0.8,0.8];
Ctrl.SetOP.i_ref_d = [Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d,Ctrl.I_ref_d];
Ctrl.SetOP.i_ref_q = [Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q,Ctrl.I_ref_q];
%Ctrl.SetOP.v_ref_dc = [Ctrl.V_ref_dc,Ctrl.V_ref_dc,Ctrl.V_ref_dc+50,Ctrl.V_ref_dc+50,Ctrl.V_ref_dc];   
Ctrl.SetOP.v_ref_dc = [Ctrl.V_ref_dc,Ctrl.V_ref_dc,Ctrl.V_ref_dc,Ctrl.V_ref_dc,Ctrl.V_ref_dc]; 

end
