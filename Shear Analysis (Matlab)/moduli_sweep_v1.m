% moduli_sweep_v1.m

% Calculate elastic and viscous moduli from amplitude sweep.
% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.

% Modification history:
% v1: only have the first part of import data done (through line 26)

%% Import data
% Import shear data file

folder = 'C:\Eric\Xerox Data\Shear Data\0.3333Hz 4-11-17\1.4V\ampsweep_post_train\';

setAmps = 0.2:0.2:3.0;
filepath = cell(length(setAmps), 1);
M = cell(length(setAmps), 1);

for i = 1:length(setAmps)
    filepath{i} = [folder, 'a1_', sprintf('%.4f',setAmps(i)) '_a2_0.0000_f1_0.3333_f2_1.0000_p_90.txt'];
    M{i} = dlmread(filepath{i});
end

% Frequency and samples per period
freq = 0.3333;
spp = 1000;
fs = freq*spp;
%% To do:
% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1{1} = M{1}(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

% Full time vector. (cut it down for fits)
% tUncut = 0:1/fs:length(M1)/fs - 1/fs;
tUncut = 1/fs:1/fs:length(M1)/fs;
tUncut = tUncut.';

% signal length
L = length(M1);

%% Full plots of stress and strain
figure;
plot(tUncut, M1, 'b');
% xlim([0,20]);
hold on
plot(tUncut, M2, 'r');
plot(tUncut, M3, 'c');
plot(tUncut, M4, 'g');
hold off


%% Plot limited range without DC offset.
t1 = 0;
t2 = 6;
lim1 = t1*freq*spp+1;
lim2 = t2*freq*spp+1;
figure;
hold on
xlim([t1,t2]);
plot(tUncut(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'g');
plot(tUncut(lim1:lim2), 0.05* (M1(lim1:lim2) - mean(M1(lim1:lim2))),'b');
% plot(time(lim1:lim2), M4(lim1:lim2) - mean(M4(lim1:lim2)), 'g');
hold off

title('Stress and Strain vs Time')
xlabel('Time (s)')
ylabel('Stress and Strain Amplitude (V)')
leg = legend({'Stress', 'Strain'}, 'Location', 'northwest');
set(leg, 'FontSize', 12)
xt = get(gca,'XTick');
set(gca, 'FontSize', 12);
axis([t1 t2 -0.2 0.2])

%% Fourier transforms of full stress and strain signals

% fast fourier transforms
y1 = fft(M1);
y2 = fft(M2);

% Compute the phase angles for the two signals
freqIndex = freq * length(tUncut)/fs+1;
phase1 = angle(y1(uint32(freqIndex))); 
phase2 = angle(y2(uint32(freqIndex)));
phaseDiff = phase2-phase1;
phaseDiffinPi = phaseDiff/pi;
phaseDiffinDeg = phaseDiff * 180/pi;

%% Fourier amplitude for full signal
% Two sided spectrum P2
P2_2 = abs(y2/L);
% Compute single sided spectrum P1 based on P2 and even-valued signal of
% length L.
P1_2 = P2_2(1:L/2+1);
P1_2(2:end-1) = 2*P1_2(2:end-1);

% Frequencies for plotting (frequency vector)
f = fs*(0:(L/2))/L;

figure;
hold on
plot(f,P1_2)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([0.05, 1.5])
hold off

f1 = 0.1;
f2 = 1.5;
index1 = uint32(f1 * L / fs +1); % get index in frequency vector
index2 = uint32(f2 * L / fs +1);
[ampMax_2, indexMax_2] = max(P1_2(index1:index2));

freqMax_2 = f(indexMax_2 + index1 - 1);

%% Fourier transform loop
% using function

% Set time interval for transform for each step in loop
% MAKE SURE timeInterval * freq IS AN INTEGER
timeInterval = 15; % Time interval in seconds
LCut = timeInterval * fs;
% number of steps in loop
steps = length(1:LCut:(L-LCut));

% Keep track of the timesteps
timeloop = timeInterval/2:timeInterval:steps*timeInterval;

[ampsStress, indicesStress, freqsStress, phasesStress] = fourierLoop_v1(M2, freq, fs, timeInterval);
[ampsStrain, indicesStrain, freqsStrain, phasesStrain] = fourierLoop_v1(M1, freq, fs, timeInterval);

% Get phase differences
phaseDiffs = 1:steps;
phaseDiffsinPi = 1:steps;
phaseDiffsinDeg = 1:steps;

for i = 1:steps
    phaseDiffs(i) = phasesStress(i)-phasesStrain(i);
    phaseDiffsinPi(i) = phaseDiffs(i)/pi;
    phaseDiffsinDeg(i) = phaseDiffs(i) * 180/pi;
end


% Plot amplitude of fourier peak at different times
figure;
% timeloop*freq = shear cycles
plot(timeloop*freq, ampsStress, 'o');
title('Stress curve amplitude fn (in V) vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Stress Amplitude (V)')

% Plot phase angle at different times
figure;
hold on
plot(timeloop*freq, phasesStress*180/pi, 'o');
plot(timeloop*freq, phasesStrain*180/pi, 'o');
plot(timeloop*freq, phaseDiffs*180/pi, 'o');
title('Phase angle vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Phase (deg)')
hold off

% Plot phase difference at different times
figure;
plot(timeloop*freq, phaseDiffsinDeg, 'o');
title('Phase difference vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Phase (deg)')
% axis([0 max(timeloop*freq) 30 90])

%% Plot 'fourier fit'
% could add this as a check. use fft_phase_testing_v6 as example.
i = 1; % chooses which section of Stress and Strain to fit
fourierfitStress = ampsStress(i)*sin(2*pi*freq*tUncut + (phasesStress(i) + pi/2));
fourierfitStrain = ampsStrain(i)*sin(2*pi*freq*tUncut + (phasesStrain(i) + pi/2));

time1 = 0;
time2 = 15;
index1 = uint32(time1*fs+1);
index2 = uint32(time2*fs+1);

% Plot sine curves. looks pretty good!
figure;
hold on
plot(tUncut(index1:index2), 0.1*(M1(index1:index2)-mean(M1(index1:index2))), 'b')
plot(tUncut(index1:index2), M2(index1:index2)- mean(M2(index1:index2)), 'g')
plot(tUncut(index1:index2), fourierfitStress(index1:index2), 'r')
plot(tUncut(index1:index2), 0.1*(fourierfitStrain(index1:index2)), 'k')
xlabel 'time'
ylabel 'x'
axis([time1 time2 -0.3 0.3])
hold off
%% Elastic and Viscous moduli

gp = (ampsStress./ampsStrain).*cos(phaseDiffs);
gpp = (ampsStress./ampsStrain).*sin(phaseDiffs);

figure;
hold on
plot(timeloop*freq, gp, 'b:o');
plot(timeloop*freq, gpp, 'r:o');
title('Phase angle vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('G'' and G"')
legend('G''', 'G"')
hold off

%% Phase info still not restructured for curve fitting
%% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)
% Modified version. Set time = 0 at start to reduce uncertainty in phase

intervalTime = 15; 
len1 = intervalTime * fs;
startTime = 0;
start1 = startTime * fs+1;


% len1 = 10000
% start1 = 500000;
% Need to zero the starting point to make it work.
% Use 1 for the starting time instead of start1 to get phase more
% precisely.
fit1_late = fit(tUncut(1:1+len1), M1(start1:start1+len1)-mean(M1(start1:start1+len1)), 'sin1');
fit2_late = fit(tUncut(1:1+len1), M2(start1:start1+len1)-mean(M2(start1:start1+len1)), 'sin1',...
    'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% Specify fit bounds to force the right frequency for the fit.

figure;
plot(tUncut(start1:start1+len1),M2(start1:start1+len1)-mean(M2(start1:start1+len1)),'g');
hold on
t1 = start1 * 1/(freq*spp);
xlim([t1, t1+10])
% plot(fit1_late, 'b'); 
% Fit doesn't look pretty for some reason 
% (number of points being used to plot i think.)
plot(tUncut(start1:start1+len1), 0.05* (M1(start1:start1+len1)-mean(M1(start1:start1+len1))),'b');
plot(fit2_late, 'r');
plot(tUncut(start1:start1+len1), (fourierfitStress(start1:start1+len1)), 'k')
title('Stress and Strain vs Time')
xlabel('Time (s)')
ylabel('Stress and Strain Amplitude (V)')
legend('Stress', 'Strain', 'Stress Fit', 'stress Fit fourier')
hold off

% Coefficient values
co1_late = coeffvalues(fit1_late);
co2_late = coeffvalues(fit2_late);

% Phase difference (in radians). 
phase_late = co2_late(3) - co1_late(3);
phaseDeg_late = phase_late * 180/pi;
% Really big phase difference! Maybe? check!
% (Or big change from before). Could be just
% uncertainty. Look at bigger range to reduce uncertainty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%