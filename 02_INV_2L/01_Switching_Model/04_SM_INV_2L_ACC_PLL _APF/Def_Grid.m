%% Grid Definition
% ########################################################################
% Define the object of a grid
% Output:
%       - [obj] grid parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Grid = Def_Grid()
% grid
Grid.fg = 50;                           % [Hz] grid frequency
Grid.wg = 2*pi*Grid.fg;                 % [rad/s] grid angle frequency
Grid.V_rms_l = 380;                     % [V] grid line voltage rms
Grid.V_amp = sqrt(2/3)*Grid.V_rms_l;    % [V] grid phase voltage amplitude
Grid.Lg = 40e-6;                        % [H] Grid inductance 
Grid.Rg = 2e-3;                         % [H] Grid resistance

end
