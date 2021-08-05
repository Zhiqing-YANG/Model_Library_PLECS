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
Grid.V_rms_l = 50*sqrt(3);              % [V] grid line voltage rms
Grid.V_amp = sqrt(2/3)*Grid.V_rms_l;    % [V] grid phase voltage amplitude
Grid.Lg = 3e-3;                       % [H] Grid inductance 
Grid.Rg = 0.2;                          % [Ohm] Grid resistance

% -- change of Lg
Grid.Lg_add = 0;                        % [H] incremental grid inductance 
Grid.Lg_add_time = 0.5;                 % [s] simulation time when Lg changes 

end
