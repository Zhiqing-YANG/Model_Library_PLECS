%% Inverter Definition
% ########################################################################
% Define object of a central inverter
% 2 MW, 3 kHz
% Input:
%       - [char] controller type ('PI' or 'PR')
% Output:
%       - [obj] inverter parameter 
% Establishment: 27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Inv = Def_Inv_2MW_3kHz(Type_ACC)

% inverter 
Inv.f_sw = 3e3;                   % [Hz] inverter switching frequency;    
Inv.f_sp = 2*Inv.f_sw;            % [Hz] sampling frequency
Inv.T_sp = 1/Inv.f_sp;            % [s] sampling time

% signal processing
Inv.SP.T_tr= 1e-6;                % [s] transducer delay
Inv.SP.LPF_num = [1];             % [] num tf of signal conditioning
Inv.SP.LPF_den = [1];             % [] den tf of signal conditioning

% filter
Inv.Filter.C_dc = 15e-3;          % [F] dc-link capacitance
Inv.Filter.L1 = 120e-6;           % [H] Inv inductance in inverter side
Inv.Filter.R1 = 1e-3;             % [Ohm] parasite resistance in inverter side
Inv.Filter.C = 1e-3;              % [H] Inv capacitance 
Inv.Filter.Rd = 0.05;             % [Ohm] damping resistance             
Inv.Filter.L2 = 40e-6;            % [H] Inv inductance in grid side
Inv.Filter.R2 = 1e-3;             % [Ohm] parasite resistance in grid side

% current controller 
switch Type_ACC
    case 'PI'
        Inv.ACC.Kp = 0.23;         % [] Kp of ACC
        Inv.ACC.Ki = 28;         % [] Ki of ACC
    case 'PR'
        Inv.ACC.Kp = 0.2;         % [] Kp of ACC
        Inv.ACC.Kr = 215;         % [] Kr of ACC
end
Inv.ACC.w1 = 2*pi*50;             % [rad/s] ideal grid angular frequency
Inv.ACC.K_AD = 0.05;              % [] active damping factor
Inv.ACC.K_VFF = 2*pi*3000;        % [] filter bandwidth of VFF
Inv.ACC.AntiWindup = inf;         % [] Anti-windup of ACC

% voltage controller 
Inv.DVC.Kp = -3.6;                % [] Kp of DVC
Inv.DVC.Ki = -239;               % [] Ki of DVC
Inv.DVC.AntiWindup = inf;         % [] Anti-windup of DVC

% PLL controller 
Inv.PLL.Kp = 0.36;                 % [] Kp of PLL
Inv.PLL.Ki = 40;                 % [] Ki of PLL
Inv.PLL.w1 = 2*pi*50;             % [rad/s] ideal grid angular frequency

end
