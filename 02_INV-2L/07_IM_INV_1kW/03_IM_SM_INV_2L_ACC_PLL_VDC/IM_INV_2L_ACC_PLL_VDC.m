%% Numeric Calculation of Inverter Impedance Model 
% ########################################################################
% numeric calculation of impedance/admitance at a given frequency range
% Input:
%       - [obj] grid parameter
%       - [obj] inverter parameter
%       - [obj] control parameter 
%       - [vector] frequency range [Hz]
% Output:
%       - [obj] impedance/admitance matrices at a given frequency range
% Establishment: 15.01.2021 Jiani He, PGS, RWTH Aachen
% Last Change:   15.01.2021 Jiani He, PGS, RWTH Aachen
% ########################################################################

function [Z_inv, Y_inv, Z_pcc, Y_pcc, Z_g, Y_g] = IM_INV_2L_ACC_PLL_VDC(Grid,Inv,Ctrl,f_swp)
Z_inv.dd = [];
Z_inv.dq = [];
Z_inv.qd = [];
Z_inv.qq = [];

Y_inv.dd = [];
Y_inv.dq = [];
Y_inv.qd = [];
Y_inv.qq = [];

Z_pcc.dd = [];
Z_pcc.dq = [];
Z_pcc.qd = [];
Z_pcc.qq = [];

Y_pcc.dd = [];
Y_pcc.dq = [];
Y_pcc.qd = [];
Y_pcc.qq = [];

Z_g.dd = [];
Z_g.dq = [];
Z_g.qd = [];
Z_g.qq = [];

Y_g.dd = [];
Y_g.dq = [];
Y_g.qd = [];
Y_g.qq = [];

w_swp = 2*pi*f_swp;
for w = w_swp
    [Z_inv_w, Y_inv_w, Z_pcc_w, Y_pcc_w, Z_g_w, Y_g_w] = IM_INV_2L_ACC_PLL_VDC_w(Grid,Inv,Ctrl,w);
    Z_inv.dd = [Z_inv.dd, Z_inv_w(1,1)];
    Z_inv.dq = [Z_inv.dq, Z_inv_w(1,2)];
    Z_inv.qd = [Z_inv.qd, Z_inv_w(2,1)];
    Z_inv.qq = [Z_inv.qq, Z_inv_w(2,2)];
    
    Y_inv.dd = [Y_inv.dd, Y_inv_w(1,1)];
    Y_inv.dq = [Y_inv.dq, Y_inv_w(1,2)];
    Y_inv.qd = [Y_inv.qd, Y_inv_w(2,1)];
    Y_inv.qq = [Y_inv.qq, Y_inv_w(2,2)];
    
    Z_pcc.dd = [Z_pcc.dd, Z_pcc_w(1,1)];
    Z_pcc.dq = [Z_pcc.dq, Z_pcc_w(1,2)];
    Z_pcc.qd = [Z_pcc.qd, Z_pcc_w(2,1)];
    Z_pcc.qq = [Z_pcc.qq, Z_pcc_w(2,2)];
    
    Y_pcc.dd = [Y_pcc.dd, Y_pcc_w(1,1)];
    Y_pcc.dq = [Y_pcc.dq, Y_pcc_w(1,2)];
    Y_pcc.qd = [Y_pcc.qd, Y_pcc_w(2,1)];
    Y_pcc.qq = [Y_pcc.qq, Y_pcc_w(2,2)];
    
    Z_g.dd = [Z_g.dd, Z_g_w(1,1)];
    Z_g.dq = [Z_g.dq, Z_g_w(1,2)];
    Z_g.qd = [Z_g.qd, Z_g_w(2,1)];
    Z_g.qq = [Z_g.qq, Z_g_w(2,2)];
    
    Y_g.dd = [Y_g.dd, Y_g_w(1,1)];
    Y_g.dq = [Y_g.dq, Y_g_w(1,2)];
    Y_g.qd = [Y_g.qd, Y_g_w(2,1)];
    Y_g.qq = [Y_g.qq, Y_g_w(2,2)];
end

end