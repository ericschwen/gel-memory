%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Viscocity calculation script

% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.
% Calculates principle frequency, amplitude of signal, SNR.
% Uses fourier transforms and/or curve fitting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Glycerol-Water x-axis data
% filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
%     'Glycerol-Water Shear 6-21-16\x-axis 10hz\'...
%     'a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% % % silica suspension data
filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
    '0.5Hz 1V 6-21-16/a1_1.0000_a2_0.0000_f1_0.5000_f2_1.0000_p_00.txt'];

% Frequency and samples per period
freq = 0.5;
spp = 1000;
% Sampling frequency (spp = samples per period) and time
Fs = (freq * spp);
T = 1/Fs;

% Import shear data file
M = dlmread(filename);

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1_precut = M(:, 1); % Piezo X (proportional to strain)
M2_precut = M(:, 2); % Signal X (proportional to stress)
M3_precut = M(:, 3); % Piezo Y
M4_precut = M(:, 4); % Signal Y
% Note: Signal X and Signal Y reversed for 6-21-16 data.

% Problem with data: there are a bunch of zeros in between time 50 and
% about point 610. Therefore I should ignore the first 650 times. This
% corresponds to the first 325000 data points)
M1 = M1_precut(325000:size(M1_precut));
M2 = M2_precut(325000:size(M2_precut));
M3 = M3_precut(325000:size(M3_precut));
M4 = M4_precut(325000:size(M4_precut));

% Timesteps precut
time_precut = 1/(freq * spp) * (0:1:size(M1_precut)-1);
time_precut = time_precut.';
% length of signal
L_precut = size(M1_precut);

% M2 (signal y) is clipped off after time 1600 or so, so I might want to
% ignore that part later.
% Signal X and Signal Y both drift upward the whole time. I'll probably
% need to either subtract the drift or average first. 

% Zeroed signals
% Works better to subtract the mean (center at y = 0)
M1_0 = M1 - mean(M1);
M2_0 = M2 - mean(M2);
M3_0 = M3 - mean(M3);
M4_0 = M4 - mean(M4);

% Timesteps
time = 1/(freq * spp) * (0:1:size(M1)-1);
time = time.';
% length of signal
L = size(M1);

% Piezo conversion: 1 V = 25 um displacement.
% strain = displacement / gap
gap = 37; % gap might actually be 12 or 13. 
strain = M1 * 25 / gap;

% strain rate = strain * 2 * pi * freqency
strainRate = 2 * pi * freq * strain;

% Plot Piezo X vs time and signal X vs time
plot(time, M1_0, 'b');
% xlim([0,20]);
hold on
plot(time, M2_0, 'r');
plot(time, M3_0, 'c');
plot(time, M4_0, 'g');
hold off

% Precut (for tracking of cut boundaries)
plot(time_precut, M1_precut, 'b');
% xlim([0,20]);
hold on
plot(time_precut, M2_precut, 'r');
plot(time_precut, M3_precut, 'c');
plot(time_precut, M4_precut, 'g');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier transform of whole signal.
% This gets the main frequency component and likely averages over the
% amplitudes.

% Fourier transform of signal to get principal components
% 2 * Absolute value of it
V = 2 * abs(fft(M4_0)) / L(1);
f = Fs * linspace(0,1, L(1));

% Plot
plot(f,V); 
xlim([0.2, 1])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

% Maximum amplitude
% [ampV, index] = max(V);

% Maximum amplitude excluding the peak at the zero from the DC shift.
% Start from .2 Hz and go to _ Hz.
[ampV, index] = max(V(100:5000));

% Frequency of maximum. Have to subtract the (100 - 1) because I limited V
% above.
freqV = (index+(100-1)-1) / L(1) * Fs;

% Note: amplitude will change if you look at specific parts. Changing
% viscosity?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier transform for smaller sections

% Beginning 200 seconds. Amplitude higher than overall.
L1 = 100000;
V1 = 2 * abs(fft(M4_0(1:L1))) / L1;
f1 = Fs * linspace(0,1, L1);

plot(f1,V1); 
xlim([0.2, 1])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

% Another 200 seconds near the end. Amplitude less than overall.
V2 = 2 * abs(fft(M4_0(5*L1+1:6*L1))) / L1;
f2 = Fs * linspace(0,1,L1);

plot(f2,V2); 
xlim([0.2, 1])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

% Middle(ish) 200 seconds. Middling amplitude.
V3 = 2 * abs(fft(M4_0(3*L1+1:4*L1))) / L1;
f3 = Fs * linspace(0,1,L1);

plot(f3,V3); 
xlim([0.2, 1])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')


% % % Plots of the data for the fourier transforms above.
plot(time(1:L1), M4_0(1:L1));
xlim([0,20]);
plot(time(5*L1+1:6*L1), M4_0(5*L1+1:6*L1));
plot(time(3*L1+1:4*L1), M4_0(3*L1+1:4*L1));
xlim([700, 720]);

% Looks like the amplitude decreases over the course of the process (Both 
% in fourier transform and in regular signal. Shear thinning? 
% I could write a loop to evaluate specific sections and plot the
% decreasing amplitude over time.

% SNR is also much lower at later timesteps. I think lower signal but
% similar noise levels.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Curve Fitting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECTION FOR GETTING RID OF DC DRIFT FROM AMPLIFIER
% SKIP IF DON'T HAVE DRIFT
% Try fitting signal x and y to exponentials to get rid of drift.

% Subtract off mean of last section (so it ends at 0V) and fit to
% a single exponential.
M4_f0 = M4_0 - mean(M4_0(size(M4_0)-5000:size(M4_0)));
fit4_exp1 = fit(time(1:size(time)), M4_f0(1:size(M4_f0)), 'exp1');

% Plot fit and signal. Looks pretty good!
plot(time, M4_f0, 'g');
hold on
plot(fit4_exp1, 'b');
% plot(fit4_exp2, 'r');
% plot(time, M1_0, 'r');
hold off

% General model Exp1:
%      fit4_exp1(x) = a*exp(b*x)
co_exp1 = coeffvalues(fit4_exp1);
fit4_exp1_eq = co_exp1(1)*exp(co_exp1(2)*time);

% Subtract exponential fit from signal to center it around 0V.
M4_e1 = M4_f0 - fit4_exp1_eq;

% Plot
plot(time, M4_e1, 'g');

% Subtracting the exponential shouldn't really do anything but change the
% zero point by subtracting off the mean (eliminating the drifting DC
% offset from the amplifier.

% Could also find mean of individual sections of a couple oscillations and
% subtract the mean from each one. Should accomplish the same thing but it
% might do a better job than the exponential fit.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTUAL CURVE FITTING (NOT THE DRIFT PART)
% Use M4_0 instead of M4_e1 if not using the version after the exponential
% fit is subtracted.

% fits for M1 (x strain) and M4 (x stress)
fit1 = fit(time, M1_0, 'sin1');
fit2 = fit(time, M4_e1, 'sin1');

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
% Fit to full range. Doesn't seem to work very well. For early periods.
plot(time, M4_e1, 'g');
hold on
xlim([0, 20]);
plot(fit2, 'b');
% plot(time, M1_0, 'r');
hold off

% Try looking at other regions. Much noisier signal later on? But
% decreasing amplitude?
plot(time, M4_e1, 'g');
hold on
xlim([1000, 1020]);
plot(fit2, 'b');
% plot(time, M1_0, 'r');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try fitting to a shorter period. Fits alright!
% Probably need to look at shorter sections to get amplitude right as it
% changes over time.

% Data point = time * freq * spp
timelim = 10000;
fit2_short = fit(time(1:10000), M4_e1(1:10000), 'sin1');
plot(time(1:10000),M4_e1(1:10000), 'b');
hold on
plot(fit2_short,'r');
hold off

% Coefficient values
co2_short = coeffvalues(fit2_short);

% Phase difference (in radians)
phase_short = co2_short(3) - co1(3);
phaseDeg_short = phase_short * 180/pi;

% Can fit Piezo to the shorter later regions as well in order to get the
% new phase and calculate phase differences.

%Fit shorter period later on

