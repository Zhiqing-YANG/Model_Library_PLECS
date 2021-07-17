%% Grid Definition
% ########################################################################
% Define object of a grid
% Input:
%       - [Hz] grid frequency
%       - [V] line-to-line rms voltage
% Output:
%       - [obj] grid parameter 
% Establishment: 27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   27.02.2019 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

function Grid = Def_Grid(fg,V_rms_l)

% grid
Grid.fg = fg;                       % [Hz] grid frequency
Grid.wg = 2*pi*Grid.fg;             % [rad/s] grid angle frequency
Grid.V_rms_l = V_rms_l;             % [V] grid line voltage rms
Grid.V_amp = sqrt(2/3)*Grid.V_rms_l;% [V] grid phase voltage amplitude
Grid.Lg = 25e-6;                    % [H] Grid inductance 
Grid.Rg = 1e-3;                     % [H] Grid resistance
Grid.Cg = 0e-3;                     % [H] Grid capacitance at PCC
Grid.Rv = 1e3;                      % [Ohm] Virtual resistance

end
