%% Grid Definition
% ########################################################################
% Define object of a grid
% Output:
%       - [obj] grid parameter 
% Establishment: 23.08.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Grid = Def_Grid()
% grid
Grid.fg = 50;                           % [Hz] grid frequency
Grid.wg = 2*pi*Grid.fg;                 % [rad/s] grid angle frequency
Grid.V_rms_l = 550;                     % [V] grid line voltage rms
Grid.V_amp = sqrt(2/3)*Grid.V_rms_l;    % [V] grid phase voltage amplitude
Grid.Lg = 25e-6;                        % [H] Grid inductance 
Grid.Rg = 0e-3;                         % [Ohm] Grid resistance
Grid.Rv = 5e2;                          % [Ohm] Virtual resistance for SSM

% -- change of Lg
Grid.Lg_add = 0;                        % [H] incremental grid inductance 
Grid.Lg_add_time = 0.5;                 % [s] simulation time when Lg changes 

end
