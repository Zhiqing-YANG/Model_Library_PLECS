%% Participation factors
% ########################################################################
% Calculate resonant frequency and damping ratio of all eigenvalues
% Input:
%       - [obj] state-space model
% Output:
%       - [matrix] participation factor matrix 
% Establishment: 10.08.2018 Qilei Wang, PGS, RWTH Aachen
% ########################################################################

function PF = PF_cal(SSM)
%% Data pre-processing
format short
[V_R, ~] = eig(SSM.A);        % V_R: the right eigenvector element                       
V_t = inv(V_R);          
V_L = transpose(V_t);       % V_L: the left eigenvector element  

%% Participation factor calculation
P = V_R.*V_L; 
[m,n] = size(P); 
PF = zeros(m); 
for i = 1:n
    PF(:,i)=abs(P(:,i))/max(abs(P(:,i)));
end

%% Print results
disp('Participation factors')
disp(PF)

end

