%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Glycerol-Water x-axis data
filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
    'Glycerol-Water Shear 6-21-16\x-axis 10hz\'...
    'a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% % % silica suspension data
% filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
%     '0.5Hz 1V 6-21-16/a1_1.0000_a2_0.0000_f1_0.5000_f2_1.0000_p_00.txt'];

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
% Note: Signal X and Signal Y reversed for 6-21-16 data.

% Piezo conversion: 1 V = 25 um displacement.
% Gap = 16.7 um for 6/8/16 run
% strain = displacement / gap
gap = 16.7;
strain = M1 * 25 / gap;

% strain rate = strain * 2 * pi * freqency
strainRate = 2 * pi * freq * strain;

% Timesteps
time = 1/(freq * spp) * (0:1:size(M1)-1);
time = time.';
% length of signal
L = size(M1);

% Zeroed signals
% Works better to subtract the mean (center at y = 0)
M1_0 = M1 - mean(M1);
M2_0 = M2 - mean(M2);
M3_0 = M3 - mean(M3);
M4_0 = M4 - mean(M4);

% Plot Piezo X vs time and signal X vs time
plot(time, M1_0, 'b');
xlim([0,0.5]);
hold on
plot(time, M2_0, 'r');
plot(time, M3_0, 'c');
plot(time, M4_0, 'g');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier transform

% Fourier transform of signal to get principal components
% 2 * Absolute value of it
V = 2 * abs(fft(M4_0)) / L(1);  % Possibly divide by length spp
f = Fs * linspace(0,1, L(1));

% Plot
plot(f,V); 
xlim([-1, 25])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

% Maximum amplitude
[ampV, index] = max(V);

% Frequency of maximum
freqV = index / L(1) * Fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Curve Fitting

fit1 = fit(time, M1_0, 'sin1');
fit2 = fit(time, M4_0, 'sin1');

% Coefficient vales
co1 = coeffvalues(fit1);
co2 = coeffvalues(fit2);

% Convert fit to equation
fit2_eq = co2(1) * sin(co2(2)*time+co2(3));

% Phase difference (in radians)
phase = co2(3) - co1(3);
phaseDeg = phase * 180/pi;

% Fit frequency (in Hz)
fit2_freq = co2(2) / (2*pi);

% % % Plots
% plot(time, M1_0, 'b');
% hold on
% plot(time, M1_0, 'r');
% plot(fit1, 'c');

plot(time, M4_0, 'g');
hold on
xlim([1, 1.5]);
plot(fit2, 'b');
hold off

% % % % Normalized plots of Piezo X and signal X vs time
% plot(time, M1_0./co1(1), 'b')
% hold on
% xlim([0, 0.5])
% % plot(time, M2_0/co2(1), 'r')
% plot(time, fit2_eq / co2(1), 'c')
% hold off

% % % Testing to see if phase looks right
% plot(time, sin(2 * pi * 10 * time))
% hold on
% xlim([0,0.5])
% plot(time, sin(2*pi*10*time+phase))
% hold off

% General thoughts: Amplitude from fourier and fit should match. It does!
% However, frequencies from fit and fourier do not match exactly. (Off by
% 1%). Possibly a problem with my fourier frequency part?
