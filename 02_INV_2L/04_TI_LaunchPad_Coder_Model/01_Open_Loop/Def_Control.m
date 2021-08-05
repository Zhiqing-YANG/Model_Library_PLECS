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

function Ctrl = Def_Control(Grid,Inv)
%% Control Parameters
% modulation and sampling 
Ctrl.f_sw = 10e3;                   % [Hz] inverter switching frequency;    
Ctrl.f_sp = 2*Ctrl.f_sw;            % [Hz] sampling frequency
Ctrl.T_sw = 1/Ctrl.f_sw;            % [s] switching period
Ctrl.T_sp = 1/Ctrl.f_sp;            % [s] sampling time

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
Ctrl.th_vc = 130;
Ctrl.th_iL = 20;

end
