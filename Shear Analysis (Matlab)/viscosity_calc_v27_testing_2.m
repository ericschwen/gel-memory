%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% viscosity_calc.m

% Viscocity calculation script

% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.
% Calculates principle frequency, amplitude of signal, SNR.
% Uses fourier transforms and/or curve fitting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modification history:
% v24: comment out multifile part. Also remove the cut and precut part.
% The cut came from zeroing the amplifiers after starting shearing, but
% that is probably bad practice and I didn't do it for the most recent
% data.

% v25: Played around with fixing error bars in amplitude and phase.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMPORT AND CUT DATA

filepath = ['C:\Eric\Xerox Data\Shear Data\4-25-17 glycerol testing (meeras cell)\12 um gap\1.0V xshear\'...
    'a1_1.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];
rawdata = dlmread(filepath);
rawdataTotal = rawdata;

% Frequency and samples per period
freq = 1.0;
spp = 1000;
% Sampling frequency and period (with spp = samples per period)
Fs = (freq * spp);
Ts = 1/Fs;

% Import shear data file
M = rawdataTotal;

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
% Note: not sure which is x and y between M2 and M4 currently
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

% Shouldn't start until time 6s or so when I zeroed the amplifiers.
% Time 2s * Fs = 4000 (cut index)

% Note: Sign of stress can be (kind of) arbitrarily reversed. It depends on
% which direction you define as positive stress (compressive).

% Timesteps
time = 1/(Fs) * (0:1:size(M1)-1);
time = time.';
% % length of signal
L = size(M1);

% Preliminary plots of stress and strain
figure;
plot(time, M1, 'b');
% xlim([0,20]);
hold on
plot(time, M2, 'r');
plot(time, M3, 'c');
plot(time, M4, 'g');
hold off

% Signal X and Signal Y both drift upward the whole time. I'll probably
% need to either subtract the drift or average first. 

% Zeroed signals
% Works better to subtract the mean (center at y = 0)
M1_0 = M1 - mean(M1);
M2_0 = M2 - mean(M2);
M3_0 = M3 - mean(M3);
M4_0 = M4 - mean(M4);
% Doesn't actually zero smaller sections of signal. DC drift accounted for
% in curve fitting later.

% % strain rate = strain * 2 * pi * freqency
% strainRate = 2 * pi * freq * strain;

% Plot limited range without DC offset. And with optional curve fit.
t1 = 10;
t2 = 20;
lim1 = t1*freq*spp+1;
lim2 = t2*freq*spp+1;
figure;
plot(time(lim1:lim2), M1_0(lim1:lim2),'b');
hold on
xlim([t1,t2]);
plot(time(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'r');
plot(time(lim1:lim2), M4(lim1:lim2) - mean(M4(lim1:lim2)), 'g');
hold off
% % Curve fit included for the signal if wanted.
% strainfit = fit(time(lim1:lim2), M1_0(lim1:lim2), 'sin1');
% stressfit = fit(time(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'sin1');
% plot(stressfit, 'r');
% title('Strain and Stress (in V) vs. Time')
% xlabel('Time (s)')
% ylabel('Stress and Strain (V)')
% hold off

%% Fourier transform of piezo input voltage

% Following the fft matlab documentation example
Fs = freq * spp;
Ts = 1/Fs;
% Ls = length(M1)/Fs; % length of signal in seconds
L = length(M1); % length of signal in data points
t = (0:L-1) * Ts; % time vector


Y_P = fft(M1);
% Two sided spectrum P2
P2_P = abs(Y_P/L);
% Compute single sided spectrum P1 based on P2 and even-valued signal of
% length L.
P1_P = P2_P(1:L/2+1);
P1_P(2:end-1) = 2*P1_P(2:end-1);

% Frequencies for plotting (frequency vector)
f = Fs*(0:(L/2))/L;

figure;
hold on
plot(f,P1_P)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([0.05, 1.5])
hold off

f1 = 0.1;
f2 = 1.5;
index1 = uint32(f1 * L / Fs); % get index in frequency vector
index2 = uint32(f2 * L / Fs);
[ampMaxP, indexMaxP] = max(P1_P(index1:index2));

freqMaxP = f(indexMaxP + index1);

% get phase!
% index = frequency * L / Fs
phaseAngle_P = angle(Y_P(uint32(freq*L/Fs)));
phaseAngleOverPi_P = phaseAngle_P/pi;

% Note: amplitude will change if you look at specific parts. Changing
% viscosity?

%% Phase Difference
% phaseDiff = phaseAngle_P-phaseAngle_S;
% phaseDiffinPi = phaseDiff/pi;
% phaseDiffinDeg = phaseDiff * 180/pi;

% Note: amplitude will change if you look at specific parts. Changing
% viscosity?

% Plot parts to test 'fit'
estPiezo = ampMaxP * sin(2*pi*freq*t - phaseAngle_P);
% estSignal = ampMaxS * cos(2*pi*freq*t - phaseAngle_S);

t1 = 0;
t2 = 4;
lim1 = t1*freq*spp+1;
lim2 = t2*freq*spp+1;
figure;
plot(time(lim1:lim2), M1_0(lim1:lim2),'b');
hold on
xlim([t1,t2]);
plot(time(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'r');

plot(time(lim1:lim2), estPiezo(lim1:lim2), 'g');
% plot(time(lim1:lim2), estSignal(lim1:lim2), 'c');
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
