%% Control Definition
% ########################################################################
% Define the object of an inverter controller
% Input:
%       - [obj] grid parameter 
%       - [obj] inverter parameter 
% Output:
%       - [obj] control parameter 
% Establishment: 24.02.2021 Liu Yu, Tianxiao Chen PGS, RWTH Aachen
% ########################################################################

function Ctrl = Def_Control(Grid,Inv)
%% Control Parameters
% modulation and sampling 
Ctrl.f_sw = 10e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;            % [Hz] sampling frequency
Ctrl.T_sw = 1/Ctrl.f_sw;            % [s] switching period
Ctrl.T_sp = 1/Ctrl.f_sp;            % [s] sampling time

% delay and hold
Ctrl.T_dh = 1.5*Ctrl.T_sp;          % [s] equiv. delay 

% alternating-current control
% bandwidth: 1000 [Hz]
Ctrl.ACC.Kp = 15.6;                 % [] Kp of ACC
Ctrl.ACC.Ki = 11014;                % [] Ki of ACC
Ctrl.ACC.wL = Grid.wg*Inv.Filter.L1; % [] cross-coupling term
Ctrl.ACC.K_VFF = 2*pi*500;          % [] filter bandwidth of VFF 
Ctrl.ACC.K_AD = 0;                  % [] active damping factor
Ctrl.ACC.SatLim = 200;              % [] Saturation limit of integrator

% phase-locked loop
% bandwidth: 30 [Hz]
Ctrl.PLL.Kp = 2.3;                  % [] Kp of PLL
Ctrl.PLL.Ki = 251;                  % [] Ki of PLL
Ctrl.PLL.w1 = Grid.wg;              % [] ideal grid angular frequency
Ctrl.PLL.SatLim = inf;              % [] Saturation limit of integrator

%% Filter
% low-pass filter for VPS
fr_v = 1000;          % cut-off frequency
w = 2*pi*fr_v;
zeta = 0.707;
Ctrl.VPSfilter.num = [w^2];
Ctrl.VPSfilter.den = [1 2*zeta*w w^2];

% low-pass filter for IPS
fr_i = 3000;          % cut-off frequency
w = 2*pi*fr_i;
zeta = 0.707;
Ctrl.IPSfilter.num = [w^2];
Ctrl.IPSfilter.den = [1 2*zeta*w w^2];

%% Protection
Ctrl.th_vc = 150;
Ctrl.th_iL = 20;

%% Operation Point
Ctrl.Vdc = Inv.OP.V_dc;

end
