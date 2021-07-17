%System Initialization
% ########################################################################
% Define an inverter system
% Establishment: 27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   13.05.2019 Christian Bendfeld PGS, RWTH Aachen
% ########################################################################

% simulation 
simtime = 2;                      % [s] simulation time

% grid
fg = 50;                          % [Hz] grid frequency
V_rms = 550;                            % [V] grid voltage (ll rms)
Grid = Def_Grid(fg,V_rms);         

%inverter
Inv = Def_Inv_2MW_3kHz('PI');

% w/wo delay
Pade.order = 1;
[Pade] = Pade_cal(Pade,Inv);

% operation point
V_dc_ref = 1200;                    % [V] ref of dc-link volgage
I_pv = 1000;                        % [A] pv current
I_ref_q = 0;                        % [A] ref of q-axis current
[OP,SetOP] = Def_OP_2MW_3kHz(Inv,Grid,V_dc_ref,I_pv,I_ref_q);

% control parameter design test
V_dc_max = 1500;                    % [V] maximum dc-link voltage
ACC_req.BW = 300;                   % [Hz] ACC design bandwidth
ACC_req.PM = 60;                    % [deg] ACC design phase margin
DVC_req.BW = 20;                    % [Hz] DVC design bandwidth
DVC_req.PM = 60;                    % [deg] DVC design phase margin
PLL_req.BW = 30;                    % [Hz] PLL design bandwidth
PLL_req.PM = 60;                    % [deg] PLL design phase margin
[ACC,DVC,PLL] = Design_Ctrl(Inv,V_dc_max,Grid,ACC_req,DVC_req,PLL_req,0);

% state-space model
[SSM] = SSM_CCM_LCL_AD_Lg_ACC_PLL_DVC(Inv,OP,Grid,Pade);
init_sym = [zeros(1,9),OP.V_C_d,OP.V_C_q,0,0,0,pi/2-OP.Theta_diff,OP.V_dc,0,0];

% EV and PF analysis
EV_modes_cal(SSM);
PF_cal(SSM.A);
