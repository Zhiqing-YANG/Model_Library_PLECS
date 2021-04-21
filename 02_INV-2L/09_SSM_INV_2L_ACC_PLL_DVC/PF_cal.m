%% Participation factors
% ########################################################################
% to calculate participation factors

% Establishment: 08.04.2019 Christian Bendfeld, PGS, RWTH Aachen
% ########################################################################

function [PF, V_L] = PF_cal(A)

format short
[V_R, EV, V_L] = eig(A);        % V_R: the right eigenvector element 
                                % V_L: the left eigenvector element
P = V_R.*V_L;
[m,n] = size(P); 
PF = zeros(m); 
for i = 1:n
    PF(:,i)=abs(P(:,i))/max(abs(P(:,i)));
end

disp('Participation factors')
disp(PF)

end

