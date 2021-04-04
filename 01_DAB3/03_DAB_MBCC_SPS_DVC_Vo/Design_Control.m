%% Control Design
% ########################################################################
% Design controls for DAB3 converter
% Establishment: 29.03.2021 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

% define system
eval('Def_System')

% specify desired control performance
Req.DVC.BW = 100;           % [Hz] ACC bandwidth
Req.DVC.PM = 60;           % [deg] ACC phase margin
Design = Design_Ctrl(DAB3,Ctrl,Req,2);

% update design results
Ctrl.DVC.Kp = Design.DVC.Kp;
Ctrl.DVC.Ki = Design.DVC.Ki;