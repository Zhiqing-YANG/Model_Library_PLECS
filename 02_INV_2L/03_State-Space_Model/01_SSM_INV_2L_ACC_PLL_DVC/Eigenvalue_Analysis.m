%% Eigenvalue Analysis
% ########################################################################
% Analyze eigenvalues with 
%   - State-space model composition
%   - Resonant mode analysis
%   - Participation factor analysis
% Establishment: 07.24.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

%% Looad System
addpath('System/');
eval('Def_System');

%% Operating Case
% state-space model
SSM_INV = SSM_INV_2L_ACC_PLL_DVC(Inv,Ctrl,Grid);
SSM_SYS = SSM_SYS_MINV_GRID(Grid,SSM_INV);

% input variables
% [v_dc_ref,i_ref_q,i_pv,v_g_d,v_g_q]


%% Eigenvalue Analysis
% resonant mode analysis
EV = EV_RES_cal(SSM_SYS);

% participation factor analysis
PF = PF_cal(SSM_SYS);
