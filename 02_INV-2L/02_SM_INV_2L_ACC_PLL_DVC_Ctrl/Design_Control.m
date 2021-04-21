%% Control Design
% ########################################################################
% Design controls for grid-tied inverter
% Establishment: 25.11.2020 Zhiqing Yang, PGS, RWTH Aachen
% Last Change:   25.11.2020 Zhiqing Yang, PGS, RWTH Aachen
% ########################################################################

% define system
eval('Def_System')

% specify desired control performance
Req.ACC.BW = 300;           % [Hz] ACC bandwidth
Req.ACC.PM = 60;            % [deg] ACC phase margin
Req.PLL.BW = 30;            % [Hz] PLL bandwidth
Req.PLL.PM = 60;            % [deg] PLL phase margin
Req.DVC.BW = 20;            % [Hz] ACC bandwidth
Req.DVC.PM = 60;            % [deg] ACC phase margin
Design = Design_Ctrl(Inv,Grid,Ctrl,Req,2);

% update design results
Ctrl.ACC.Kp = Design.ACC.Kp;
Ctrl.ACC.Ki = Design.ACC.Ki;
Ctrl.PLL.Kp = Design.PLL.Kp;
Ctrl.PLL.Ki = Design.PLL.Ki;
Ctrl.DVC.Kp = Design.DVC.Kp;
Ctrl.DVC.Ki = Design.DVC.Ki;
