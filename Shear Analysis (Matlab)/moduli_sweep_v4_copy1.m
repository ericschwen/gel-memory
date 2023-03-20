% moduli_sweep_v1.m

% Calculate elastic and viscous moduli from amplitude sweep.
% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.

% Modification history:
% v1: only have the first part of import data done (through line 26)
% v2: 5-19-17
% v3: continuing to modify from changes during training to amplitude sweep
% data. Starts implementation of positive phases.
% v4: continuing edits. Uses positive phases for phase
% difference calcuations.

% Notes:
% Looks like the fourier "fitting" isn't super precise. Low SNR for small
% sections. Those sections are the ones with "negative" phases where the
% correct frequency peak is not found.

%% Import data
% Import shear data file

folder = 'C:\Eric\Xerox Data\Shear Data\0.3333Hz 4-11-17\1.4V\ampsweep_post_train\';

setAmps = 0.2:0.2:3.0;
filepath = cell(length(setAmps), 1);
M = cell(length(setAmps), 1);
signal_piezoX = cell(length(setAmps), 1);
signal_piezoY = cell(length(setAmps), 1);
signal_stressX = cell(length(setAmps), 1);
signal_stressY = cell(length(setAmps), 1);

for i = 1:length(setAmps)
    filepath{i} = [folder, 'a1_', sprintf('%.4f',setAmps(i)) '_a2_0.0000_f1_0.3333_f2_1.0000_p_90.txt'];
    M{i} = dlmread(filepath{i});
    % Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
    signal_piezoX{i} = M{i}(:, 1); % Piezo X (proportional to strain)
    signal_stressX{i} = M{i}(:, 2); % Signal X (proportional to stress in x direction)
    signal_piezoY{i} = M{i}(:, 3); % Piezo Y
    signal_stressY{i} = M{i}(:, 4); % Signal Y
    
end

% Frequency and samples per period
freq = 0.3333;
spp = 1000;
fs = freq*spp;

% Declare arrays for data storage
amps_stressX = 1:length(setAmps);
indices_stressX = 1:length(setAmps);
freqs_stressX = 1:length(setAmps);
phases_stressX = 1:length(setAmps);

amps_strainX = 1:length(setAmps);
indices_strainX = 1:length(setAmps);
freqs_strainX = 1:length(setAmps);
phases_strainX = 1:length(setAmps);


%% Loop processing
for i = 1:length(setAmps)

    % Full time vector. (cut it down for fits)
    % tUncut = 0:1/fs:length(M1)/fs - 1/fs;
    tUncut = 1/fs:1/fs:length(signal_piezoX{i})/fs;
    tUncut = tUncut.';

    % signal length
    LUncut = length(signal_piezoX{i});

%     % Full plots of stress and strain
%     figure;
%     plot(tUncut, signal_piezoX{i}, 'b');
%     % xlim([0,20]);
%     hold on
%     plot(tUncut, signal_stressX{i}, 'r');
%     plot(tUncut, signal_piezoY{i}, 'c');
%     plot(tUncut, signal_stressY{i}, 'g');
%     hold off

    % Cut time vector to remove part after shear stops (15 seconds or 5 cycles
    % in this case);
    timeInterval = 15; % Time interval in seconds

    % Call fourierLoop_v1 to get the fourier transform results for each
    % section. Doesn't actually use the loop part--just uses i = 1;
    [amps_stressX(i), indices_stressX(i), freqs_stressX(i), phases_stressX(i)] = ...
        fourierLoop_v1(signal_stressX{i}, freq, fs, timeInterval);
    [amps_strainX(i), indices_strainX(i), freqs_strainX(i), phases_strainX(i)] = ...
        fourierLoop_v1(signal_piezoX{i}, freq, fs, timeInterval);

end

% %% Make phases positive numbers
% % !!! This only happened when the fourier spectrum did not have a clear
% % peak at 0.3333Hz! Probably shouldn't use at all.

% % If phase angle is greater than pi, the angle function used will assign a
% % negative phase instead. This is equivalent, but messes up the phase angle
% % plotting and phase difference stuff. Convert to equivalent positive phase
% % here pi < phase < 2pi.
% pos_phases_stressX = phases_stressX;
% for i = 1:length(setAmps)
%     if pos_phases_stressX(i) < 0
%         pos_phases_stressX(i) = 2*pi + pos_phases_stressX(i);
%     end
%         
% end


%% Get phase differences
phaseDiffs = 1:length(setAmps);
phaseDiffsinPi = 1:length(setAmps);
phaseDiffsinDeg = 1:length(setAmps);

for i = 1:length(setAmps)
    phaseDiffs(i) = phases_stressX(i)-phases_strainX(i);
    phaseDiffsinPi(i) = phaseDiffs(i)/pi;
    phaseDiffsinDeg(i) = phaseDiffs(i) * 180/pi;
end


% Plot amplitude of fourier peak at different times
figure;
% timeloop*freq = shear cycles
plot(setAmps, amps_stressX, 'o');
title('Stress curve amplitude fn (in V) vs strain amplitude')
xlabel('Strain Amplitude (V)')
ylabel('Stress Amplitude (V)')

% Plot phase angle at different times
figure;
hold on
plot(setAmps, phases_stressX*180/pi, 'o');
plot(setAmps, phases_strainX*180/pi, 'o');
plot(setAmps, phaseDiffs*180/pi, 'o');
title('Phase angle vs strain amplitude')
xlabel('Strain Amplitude (V)')
ylabel('Phase (deg)')
hold off

% Plot phase difference at different times
figure;
plot(setAmps, phaseDiffsinDeg, 'o');
title('Phase difference vs strain amplitude')
xlabel('Strain Amplitude (V)')
ylabel('Phase (deg)')
axis([0 max(setAmps) 30 90])

%% Elastic and Viscous moduli

% Thought: this shouldn't really work for phase difference greater than
% pi/2.

gp = (amps_stressX./amps_strainX).*cos(phaseDiffs);
gpp = (amps_stressX./amps_strainX).*sin(phaseDiffs);

figure;
hold on
plot(setAmps(2:end), gp(2:end), 'b:o');
plot(setAmps(2:end), gpp(2:end), 'r:o');
title('Phase angle vs strain amplitude')
xlabel('Strain amplitude (V)')
ylabel('G'' and G"')
legend('G''', 'G"')
hold off


%% Plot 'fourier fit'
% could add this as a check. use fft_phase_testing_v6 as example.
i = 4; % chooses which section of Stress and Strain to fit
fourierfitStress = amps_stressX(i)*sin(2*pi*freq*tUncut + (phases_stressX(i) + pi/2));
pos_fourierfitStress = amps_stressX(i)*sin(2*pi*freq*tUncut + (phases_stressX(i) + pi/2));
fourierfitStrain = amps_strainX(i)*sin(2*pi*freq*tUncut + (phases_strainX(i) + pi/2));

time1 = 0;
time2 = 15;
index1 = uint32(time1*fs+1);
index2 = uint32(time2*fs+1);

% Plot sine curves. looks pretty good!
figure;
hold on
plot(tUncut(index1:index2), signal_stressX{i}(index1:index2)- mean(signal_stressX{i}(index1:index2)), 'g')
plot(tUncut(index1:index2), 0.2*(signal_piezoX{i}(index1:index2)-mean(signal_piezoX{i}(index1:index2))), 'b')
% plot(tUncut(index1:index2), fourierfitStress(index1:index2), 'r')
% plot(tUncut(index1:index2), 0.2*(fourierfitStrain(index1:index2)), 'k')
title('Stress and Strain vs Time')
xlabel('Time (s)')
ylabel('Stress and Strain Amplitude (V)')
leg = legend({'Stress', 'Strain'}, 'Location', 'northwest');
set(leg, 'FontSize', 12)
xt = get(gca,'XTick');
set(gca, 'FontSize', 12);
axis([time1 time2 -0.2 0.2])
hold off

%% Plot limited range without DC offset.
t1 = 0;
t2 = 15;
lim1 = t1*freq*spp+1;
lim2 = t2*freq*spp+1;
figure;
hold on
xlim([t1,t2]);
plot(tUncut(lim1:lim2), signal_stressX{i}(lim1:lim2) - mean(signal_stressX{i}(lim1:lim2)), 'g');
plot(tUncut(lim1:lim2), 0.05* (signal_piezoX{i}(lim1:lim2) - mean(signal_piezoX{i}(lim1:lim2))),'b');
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


%% End of stuff i have working for ampsweep.
% %% Fourier transforms of full stress and strain signals
% 
% % fast fourier transforms
% y1 = fft(M1);
% y2 = fft(M2);
% 
% % Compute the phase angles for the two signals
% freqIndex = freq * length(tUncut)/fs+1;
% phase1 = angle(y1(uint32(freqIndex))); 
% phase2 = angle(y2(uint32(freqIndex)));
% phaseDiff = phase2-phase1;
% phaseDiffinPi = phaseDiff/pi;
% phaseDiffinDeg = phaseDiff * 180/pi;





% %% Fourier amplitude for full signal
% % Two sided spectrum P2
% P2_2 = abs(y2/L);
% % Compute single sided spectrum P1 based on P2 and even-valued signal of
% % length L.
% P1_2 = P2_2(1:L/2+1);
% P1_2(2:end-1) = 2*P1_2(2:end-1);
% 
% % Frequencies for plotting (frequency vector)
% f = fs*(0:(L/2))/L;
% 
% figure;
% hold on
% plot(f,P1_2)
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% xlim([0.05, 1.5])
% hold off
% 
% f1 = 0.1;
% f2 = 1.5;
% index1 = uint32(f1 * L / fs +1); % get index in frequency vector
% index2 = uint32(f2 * L / fs +1);
% [ampMax_2, indexMax_2] = max(P1_2(index1:index2));
% 
% freqMax_2 = f(indexMax_2 + index1 - 1);
% 
% %% Fourier transform loop
% % using function
% 
% % Set time interval for transform for each step in loop
% % MAKE SURE timeInterval * freq IS AN INTEGER
% timeInterval = 15; % Time interval in seconds
% LCut = timeInterval * fs;
% % number of steps in loop
% steps = length(1:LCut:(L-LCut));
% 
% % Keep track of the timesteps
% timeloop = timeInterval/2:timeInterval:steps*timeInterval;
% 
% [amps_stressX, indices_stressX, freqs_stressX, phases_stressX] = fourierLoop_v1(M2, freq, fs, timeInterval);
% [amps_strainX, indices_strainX, freqs_strainX, phases_strainX] = fourierLoop_v1(M1, freq, fs, timeInterval);
% 
% % Get phase differences
% phaseDiffs = 1:steps;
% phaseDiffsinPi = 1:steps;
% phaseDiffsinDeg = 1:steps;
% 
% for i = 1:steps
%     phaseDiffs(i) = phases_stressX(i)-phases_strainX(i);
%     phaseDiffsinPi(i) = phaseDiffs(i)/pi;
%     phaseDiffsinDeg(i) = phaseDiffs(i) * 180/pi;
% end
% 
% 
% % Plot amplitude of fourier peak at different times
% figure;
% % timeloop*freq = shear cycles
% plot(timeloop*freq, amps_stressX, 'o');
% title('Stress curve amplitude fn (in V) vs Shear Cycle')
% xlabel('Shear Cycles')
% ylabel('Stress Amplitude (V)')
% 
% % Plot phase angle at different times
% figure;
% hold on
% plot(timeloop*freq, phases_stressX*180/pi, 'o');
% plot(timeloop*freq, phases_strainX*180/pi, 'o');
% plot(timeloop*freq, phaseDiffs*180/pi, 'o');
% title('Phase angle vs Shear Cycle')
% xlabel('Shear Cycles')
% ylabel('Phase (deg)')
% hold off
% 
% % Plot phase difference at different times
% figure;
% plot(timeloop*freq, phaseDiffsinDeg, 'o');
% title('Phase difference vs Shear Cycle')
% xlabel('Shear Cycles')
% ylabel('Phase (deg)')
% % axis([0 max(timeloop*freq) 30 90])
% 
% 
% 
% %% Phase info still not restructured for curve fitting
% %% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)
% % Modified version. Set time = 0 at start to reduce uncertainty in phase
% 
% intervalTime = 15; 
% len1 = intervalTime * fs;
% startTime = 0;
% start1 = startTime * fs+1;
% 
% 
% % len1 = 10000
% % start1 = 500000;
% % Need to zero the starting point to make it work.
% % Use 1 for the starting time instead of start1 to get phase more
% % precisely.
% fit1_late = fit(tUncut(1:1+len1), M1(start1:start1+len1)-mean(M1(start1:start1+len1)), 'sin1');
% fit2_late = fit(tUncut(1:1+len1), M2(start1:start1+len1)-mean(M2(start1:start1+len1)), 'sin1',...
%     'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% % Specify fit bounds to force the right frequency for the fit.
% 
% figure;
% plot(tUncut(start1:start1+len1),M2(start1:start1+len1)-mean(M2(start1:start1+len1)),'g');
% hold on
% t1 = start1 * 1/(freq*spp);
% xlim([t1, t1+10])
% % plot(fit1_late, 'b'); 
% % Fit doesn't look pretty for some reason 
% % (number of points being used to plot i think.)
% plot(tUncut(start1:start1+len1), 0.05* (M1(start1:start1+len1)-mean(M1(start1:start1+len1))),'b');
% plot(fit2_late, 'r');
% plot(tUncut(start1:start1+len1), (fourierfitStress(start1:start1+len1)), 'k')
% title('Stress and Strain vs Time')
% xlabel('Time (s)')
% ylabel('Stress and Strain Amplitude (V)')
% legend('Stress', 'Strain', 'Stress Fit', 'stress Fit fourier')
% hold off
% 
% % Coefficient values
% co1_late = coeffvalues(fit1_late);
% co2_late = coeffvalues(fit2_late);
% 
% % Phase difference (in radians). 
% phase_late = co2_late(3) - co1_late(3);
% phaseDeg_late = phase_late * 180/pi;
% % Really big phase difference! Maybe? check!
% % (Or big change from before). Could be just
% % uncertainty. Look at bigger range to reduce uncertainty.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%