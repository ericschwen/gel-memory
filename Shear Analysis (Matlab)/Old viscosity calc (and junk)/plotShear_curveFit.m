%%%%%%%%%%%%%%
filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
    '10 hz x-axis\a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '1 hz x-axis\a1_5.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '2 hz x-axis\a1_5.0000_a2_0.0000_f1_2.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '1 hz y-axis\a1_5.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '2 hz y-axis\a1_5.0000_a2_0.0000_f1_2.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '10 hz y-axis\a1_2.3208_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];
% 
% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '10 hz y-axis\a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% Frequency and samples per period
freq = 10;
spp = 1000;
% Sampling frequency and time
Fs = (freq * spp);
T = 1/Fs;

% Import shear data file
M = dlmread(filename);

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

% Piezo conversion: 1 V = 25 um displacement.
% Gap = 16.7 um for 6/8/16 run
% strain = displacement / gap
strain = M1 * 25 / 16.7;

% strain rate = strain * 2 * pi * freqency
strainRate = 2 * pi * freq * strain;

%Timesteps
time = 1/(freq * spp) * (0:1:size(M1)-1);
time = time.';
% length of signal
L = size(M1);

% Fourier fit gets shift in height (bring back to center at zero)
fitHigh = fit(time, M1, 'fourier1');
fitHighCoeff = coeffvalues(fitHigh);

% M1 centered at y = 0;
M1_0 = M1 - fitHighCoeff(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Curve fitting
fit1 = fit(time, M1_0, 'sin1')

% Plot Piezo X vs time and signal X vs time
plot(time(1:30000), M1(1:30000), 'b');
xlim([1, 1.5]);
hold on
plot(fit1, 'c');
plot(time(1:30000), M1_0(1:30000), 'r');
% plot(time, 5.378*sin(0.003713 * time + 1.456), 'c');
% plot(time, M3 + 4, 'c');
% plot(time, M4 + 6, 'g');
hold off
