%% Define Operation Point 
% ########################################################################
% Calculate operation point for Single Inverter
% Input:
%       - [obj] inverter parameter
%       - [obj] grid parameter 
%       - [V] V_dc_ref
%       - [A] I_pv
%       - [A] I_ref_q
% Output:
%       - [obj] operation point
%       - [obj] set operation points
% Establishment: 28.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   25.06.2019 Chritian Bendfeld, PGS, RWTH Aachen
% ########################################################################

function [OP,SetOP] = Def_OP_2MW_3kHz(Inv,Grid,V_dc_ref,I_pv,I_ref_q)

%% Definition
% For Multi Inverter dont consider Grid
% The Cable is negleted
R2 = Inv.Filter.R2+Grid.Rg;
L2 = Inv.Filter.L2+Grid.Lg;


%% operation point

% power balance
OP.V_dc = V_dc_ref;
OP.I_pv = I_pv;

OP.I_L1_d = V_dc_ref*I_pv/(1.5*Grid.V_amp);
OP.I_L1_q = I_ref_q;


OP.V_g_D = Grid.V_amp;
OP.V_g_Q = 0;

OP.V_C_d = OP.V_g_D + OP.I_L1_d*R2 - OP.I_L1_q*Grid.wg*L2;
OP.V_C_q = OP.V_g_Q;

for j = 1:10

OP.I_C_d = -OP.V_C_q*Grid.wg*Inv.Filter.C;
OP.I_C_q = OP.V_C_d*Grid.wg*Inv.Filter.C;

OP.I_L2_d = OP.I_L1_d - OP.I_C_d;
OP.I_L2_q = OP.I_L1_q - OP.I_C_q;

%% initial Theta_diff
OP.Theta_diff = atan((Grid.wg*OP.I_L2_d*L2 + OP.I_L2_q*R2)/(OP.V_g_D+OP.I_L2_d*R2-Grid.wg*OP.I_L2_q*L2));

% loop for increasing accuracy
for i = 1:10 
OP.I_L2_D = OP.I_L2_d*cos(OP.Theta_diff) - OP.I_L2_q*sin(OP.Theta_diff);
OP.I_L2_Q = OP.I_L2_d*sin(OP.Theta_diff) + OP.I_L2_q*cos(OP.Theta_diff);

% LCL filter
OP.V_C_D = OP.V_g_D + OP.I_L2_D*R2 - Grid.wg*L2*OP.I_L2_Q;
OP.V_C_Q = OP.V_g_Q + OP.I_L2_Q*R2 + Grid.wg*L2*OP.I_L2_D;


OP.Theta_diff = atan(OP.V_C_Q/OP.V_C_D);
end

OP.V_C_d = OP.V_C_D*cos(OP.Theta_diff)+OP.V_C_Q*sin(OP.Theta_diff);
OP.V_C_q = 0;


% inverter
OP.V_inv_d = OP.V_C_d + OP.I_L1_d*Inv.Filter.R1 - OP.I_L1_q*Grid.wg*Inv.Filter.L1;    
OP.V_inv_q = OP.V_C_q + OP.I_L1_q*Inv.Filter.R1 + OP.I_L1_d*Grid.wg*Inv.Filter.L1;

OP.I_L1_d = V_dc_ref*I_pv/(1.5*OP.V_inv_d);

end

OP.M_d = OP.V_inv_d/(V_dc_ref/2);
OP.M_q = OP.V_inv_q/(V_dc_ref/2);

% PCC
OP.I_PCC_D = OP.I_L2_D;
OP.I_PCC_Q = OP.I_L2_Q;
OP.I_PCC_d = OP.I_PCC_D*cos(OP.Theta_diff) + OP.I_PCC_Q*sin(OP.Theta_diff);
OP.I_PCC_q = -OP.I_PCC_D*sin(OP.Theta_diff) + OP.I_PCC_Q*cos(OP.Theta_diff);


OP.V_pcc_D = OP.V_C_D - OP.I_PCC_D*Inv.Filter.R2 + Grid.wg*Inv.Filter.L2*OP.I_PCC_Q;
OP.V_pcc_Q = OP.V_C_Q - OP.I_PCC_Q*Inv.Filter.R2 - Grid.wg*Inv.Filter.L2*OP.I_PCC_D;

OP.V_pcc_d = OP.V_pcc_D*cos(OP.Theta_diff) + OP.V_pcc_Q*sin(OP.Theta_diff);
OP.V_pcc_q = -OP.V_pcc_D*sin(OP.Theta_diff) + OP.V_pcc_Q*cos(OP.Theta_diff);




%% set operation points
SetOP.time      = [0,0.3,0.3,0.5,0.5];
SetOP.v_dc_ref  = [OP.V_dc,OP.V_dc,OP.V_dc+30,OP.V_dc+30,OP.V_dc];
SetOP.i_pv      = [OP.I_pv,OP.I_pv,OP.I_pv,OP.I_pv,OP.I_pv];
SetOP.i_ref_d   = [OP.I_L1_d, OP.I_L1_d, OP.I_L1_d, OP.I_L1_d, OP.I_L1_d];
SetOP.i_ref_q   = [OP.I_L1_q,OP.I_L1_q,OP.I_L1_q,OP.I_L1_q,OP.I_L1_q];
SetOP.v_g_amp   = [Grid.V_amp,Grid.V_amp,Grid.V_amp,Grid.V_amp,Grid.V_amp];  

end