%% Sensor Definition
% ########################################################################
% Define the object of a sensor configuration
% Detailed information: "Mainboard Sensor Calibration.xlsx"
% AC voltage sensor: LV 25-P
% AC current sensor: LA 55-P
% Establishment: 24.02.2021 Liu Yu, Tianxiao Chen PGS, RWTH Aachen
% ########################################################################

function Sensor = Def_Sensor(PCB)
    switch PCB
        case 1
        %% Mainboard PCB 1 - Sensor 1
        % AC Voltage Sensor 
        % configuration
        R1 = 22e3;                      % [Ohm] pri. side curr. limit resistor
        Rm = 195;                       % [Ohm] sec. side meas. resistor
        k = 2500/1000;                  % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 24.6e3;                   % [Ohm] resistor with op-amp

        % scaling and shift
        Sensor.Vac.Ref = 1.497;         % [V] voltage schift ref
        Sensor.Vac.Scale = Ra2/Ra1*Rm/R1*k; % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Vac.a = 1;               
        Sensor.Vac.b1 = 0.002;
        Sensor.Vac.b2 = 0.000;
        Sensor.Vac.b3 = -0.004;

        % AC Current Sensor
        % configuration
        turn = 2;                       % [] turns through curr. sensor
        Rm = 135;                       % [Ohm] sec. side meas. resistor
        k = 1/1000;                     % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 26.1e3;                   % [Ohm] resistor with op-amp

        % scaling and shift
        Sensor.Iac.Ref = 1.497;         % [V] voltage schift ref
        Sensor.Iac.Scale = Ra2/Ra1*Rm*turn*k; % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Iac.a = 1;
        Sensor.Iac.b1 = -0.009;
        Sensor.Iac.b2 = 0.003;
        Sensor.Iac.b3 = 0.000;

        % DC Voltage Sensor
        % configuration
        k = 1/100;                      % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 30e3;                     % [Ohm] resistor with op-amp

        % scaling and shift
        Sensor.Vdc.Ref = 0;             % [V] voltage schift ref
        Sensor.Vdc.Scale = Ra2/Ra1*k;   % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Vdc.a = 0.71;
        Sensor.Vdc.b = 0;
           
        case 2
        %% Mainboard PCB 2 - Sensor 2
        % AC Voltage Sensor 
        % configuration
        R1 = 22e3;                      % [Ohm] pri. side curr. limit resistor
        Rm = 195;                       % [Ohm] sec. side meas. resistor
        k = 2500/1000;                  % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 24.6e3;                   % [Ohm] resistor with op-amp

        % scaling and shift
        Sensor.Vac.Ref = 1.497;         % [V] voltage schift ref
        Sensor.Vac.Scale = Ra2/Ra1*Rm/R1*k; % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Vac.a = 1;
        Sensor.Vac.b1 = -0.009;
        Sensor.Vac.b2 = -0.006;
        Sensor.Vac.b3 = 0.004;

        % AC Current Sensor
        % configuration
        turn = 2;                       % [] turns through curr. sensor
        Rm = 135;                       % [Ohm] sec. side meas. resistor
        k = 1/1000;                     % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 26.1e3;                   % [Ohm] resistor with op-amp

        % scaling and shift
        Sensor.Iac.Ref = 1.497;         % [V] voltage schift ref
        Sensor.Iac.Scale = Ra2/Ra1*Rm*turn*k; % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Iac.a = 1;
        Sensor.Iac.b1 = -0.007;
        Sensor.Iac.b2 = -0.005;
        Sensor.Iac.b3 = -0.003;

        % DC Voltage Sensor
        % configuration
        k = 1/100;                      % [] turns ratio Np/Ns
        Ra1 = 100e3;                    % [Ohm] resistor with op-amp
        Ra2 = 30e3;                     % [Ohm] resistor with op-amp
        
        % scaling and shift
        Sensor.Vdc.Ref = 0;             % [V] voltage schift ref
        Sensor.Vdc.Scale = Ra2/Ra1*k;   % [] voltage scaling factor

        % calibration y = a*u + b
        Sensor.Vdc.a = 0.71;
        Sensor.Vdc.b = 0;  
    end     
end


