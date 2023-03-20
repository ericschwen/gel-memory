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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try fitting signal x and y to exponentials to get rid of drift

% Use exp2 fit. Second "exponential" effectively just a constant.
fit4_exp2 = fit(time(2:size(time)), M4_0(2:size(M4_0)), 'exp2');

plot(time, M4_0, 'g');
hold on
plot(fit4_exp2, 'b');
% plot(time, M1_0, 'r');
hold off

% General model Exp2:
% fit4_exp2(x) = a*exp(b*x) + c*exp(d*x)
co_exp2 = coeffvalues(fit4_exp2);
fit4_exp2_eq = co_exp2(1)*exp(co_exp2(2)*time)...
    + co_exp2(3)*exp(co_exp2(4)*time);
M4_v2 = M4_0 - fit4_exp2_eq;

plot(time, M4_v2, 'g');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier transform

% Fourier transform of signal to get principal components
% 2 * Absolute value of it
V = 2 * abs(fft(M4_0)) / L(1);  % Possibly divide by length spp
f = Fs * linspace(0,1, L(1));

% Plot
plot(f,V); 
xlim([-1, 2.5])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

% Maximum amplitude
[ampV, index] = max(V);

% Frequency of maximum
freqV = (index-1) / L(1) * Fs;

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
xlim([0, 20]);
plot(fit2, 'b');
% plot(time, M1_0, 'r');
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
% Frequencies match too now. Woo!
