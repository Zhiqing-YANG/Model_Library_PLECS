
%% Controller of DAB3 Definition
% ########################################################################
% Define Object of a Controller for DAB3
% Input:
%       - [obj] Parameters of DAB3
%       - [obj] Parameters of OP
% Output:
%       - [obj] Parameters of controller
%
% Establishment: 03.04.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%%
function Ctrl = Def_Control(DAB3,OP)       

% Modulation and sampling
Ctrl.f_sw = 1e3;                        % [Hz] switching frequency
Ctrl.w = 2*pi*Ctrl.f_sw;                % [rad/s] 
Ctrl.f_sp = Ctrl.f_sw;                  % [Hz] sampling frequency
Ctrl.T_sp = 1/Ctrl.f_sp;                % [s] sampling time
Ctrl.td_in = 5e-6;                      % [s] dead time of input bridge devices
Ctrl.td_out = 5e-6;                     % [s] dead time of output bridge devices
Ctrl.td_flag = 1;                       % [s] dead time compensation mode:  1: on;
                                        %                                   0: off;

% Model-based current control
Ctrl.MBCC.Ntr = DAB3.Ntr;               % [] trafo turns ratio
Ctrl.MBCC.L = DAB3.L;                   % [H] leakage inductance
Ctrl.MBCC.Rw = DAB3.Rw;                 % [Ohm] winding resistance

% Direct-voltage control
Ctrl.DVC.Kp = 1.25;                     
Ctrl.DVC.Ki = 68;
Ctrl.DVC.SatLim = inf;

% Control Reference
Ctrl.Pref = OP.Pref;                    % [p.u.] referred transferred power
Ctrl.Vi = OP.Vi;                        % [V] input voltage operation point 
Ctrl.Vo = OP.Vo;                        % [V] output voltage operation point 
Ctrl.SetOP.time = [0,0.04,0.04,0.08,0.08];
Ctrl.SetOP.p_ref = [Ctrl.Pref,Ctrl.Pref,Ctrl.Pref,Ctrl.Pref,Ctrl.Pref];
Ctrl.SetOP.v_in_ref = [Ctrl.Vi,Ctrl.Vi,Ctrl.Vi,Ctrl.Vi,Ctrl.Vi];
Ctrl.SetOP.v_out_ref = [Ctrl.Vo,Ctrl.Vo,Ctrl.Vo+50,Ctrl.Vo+50,Ctrl.Vo];   

end