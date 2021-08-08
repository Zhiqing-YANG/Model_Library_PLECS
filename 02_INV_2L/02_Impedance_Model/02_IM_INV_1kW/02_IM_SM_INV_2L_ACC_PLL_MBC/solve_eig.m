%% Calculation of Eigenvalues of Grid/Inverter Impedance Ratio 
% ########################################################################
% calculation of eigenvalues of grid/inverter impedance ratio 
% Input:
%       - [obj] grid parameter
%       - [obj] inverter parameter
%       - [obj] control parameter 
%       - [vector] frequency range [Hz]
%       - [num] option
%               opt = 1 calculate eigenvalues for positive frequency range
%               opt = 0 calculate eigenvalues for both positive and negative frequency range
% Output:
%       - [matrix] eigenvalues of impedance ratio at a given frequency range
% Establishment: 15.12.2020 Jiani He, PGS, RWTH Aachen
% ########################################################################

function eig = solve_eig(Grid,Inv,Ctrl,f_swp,opt)

% include negative frequency range if opt = 0
if (opt == 0)
    f_swp = [-f_swp(end:-1:1),f_swp];
end

% positive frequency range
eig = [];
circle = 0;  % number of turns which the complex vector a circles around the origin
a_old = 0;

for f = f_swp
    w = 2*pi*f;
    [Z_inv_w,Y_inv_w,Z_pcc_w,Y_pcc_w,Z_g_w,Y_g_w] = IM_INV_2L_ACC_PLL_DVC_w(Grid,Inv,Ctrl,w);
    L_w = Y_pcc_w*Z_g_w;

    % find eigenvalues of the impedance ratio
    % e(1,1)=0.5*(L_w(1,1)+L_w(2,2))+sqrt(0.5^2*(L_w(1,1)-L_w(2,2))^2+L_w(1,2)*L_w(2,1));
    % e(2,1)=0.5*(L_w(1,1)+L_w(2,2))-sqrt(0.5^2*(L_w(1,1)-L_w(2,2))^2+L_w(1,2)*L_w(2,1));
    a = 0.5^2*(L_w(1,1)-L_w(2,2))^2+L_w(1,2)*L_w(2,1); 
    [b, circle] = sqrt_complex(a, a_old, circle);
    e(1,1) = 0.5*(L_w(1,1)+L_w(2,2))+b;   % eigenvalue 1
    e(2,1) = 0.5*(L_w(1,1)+L_w(2,2))-b;   % eigenvalue 2
    
    a_old = a;
    
    eig = [eig,e];
    
end

end

