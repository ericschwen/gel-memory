%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% viscosity_calc.m

% Viscocity calculation script

% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.
%% Viscosity Calc
% Calculates principle frequency, amplitude of signal, SNR.
% Uses fourier transforms and/or curve fitting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modification history:
% v24: comment out multifile part. Also remove the cut and precut part.
% The cut came from zeroing the amplifiers after starting shearing, but
% that is probably bad practice and I didn't do it for the most recent
% data.

% v25: Played around with fixing error bars in amplitude and phase.
% v28: got fourier phase stuff working. lots of cleanup
% v29: continuing fourier phase stuff. wanted a backup
% v30: change time interval stuff to number of shear cycles. CURRENTLY
% MESSED UP I THINK. PHASE DRIFTING UP? Something is off with LCut being
% different between the two versions (i think because 0.3333 isn't exactly
% 1/3?). Maybe needs to actually be in time rather than cycles. to do the
% whole time space thing or something.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import data
% Import shear data file
filepath = ['C:\Eric\Xerox Data\Shear Data\0.3333Hz 4-11-17\1.4V\training\'...
    'a1_1.4000_a2_0.0000_f1_0.3333_f2_1.0000_p_90.txt'];
M = dlmread(filepath);

% Frequency and samples per period
freq = 0.3333;
spp = 1000;
fs = freq*spp;

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

% Full time vector. (cut it down for fits)
% tUncut = 0:1/fs:length(M1)/fs - 1/fs;
tUncut = 1/fs:1/fs:length(M1)/fs;
tUncut = tUncut.';

% signal length
L = length(M1);

% %% Full plots of stress and strain
% figure;
% plot(tUncut, M1, 'b');
% % xlim([0,20]);
% hold on
% plot(tUncut, M2, 'r');
% plot(tUncut, M3, 'c');
% plot(tUncut, M4, 'g');
% hold off


%% Plot limited range without DC offset.
cycle1 = 0;
cycle2 = 6;
lim1 = cycle1*spp+1;
lim2 = cycle2*spp+1;
figure;
hold on
xlim([cycle1,cycle2]);
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
axis([cycle1 cycle2 -0.2 0.2])

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
cycleInterval = 40; % number of cycles per interval
LCut = cycleInterval * spp;
% number of steps in loop
steps = length(1:LCut:(L-LCut));

% Keep track of the timesteps
cycleloop = cycleInterval/2:cycleInterval:steps*cycleInterval;

[ampsStress, indicesStress, freqsStress, phasesStress] = fourierLoop_v2(M2, freq, spp, cycleInterval);
[ampsStrain, indicesStrain, freqsStrain, phasesStrain] = fourierLoop_v2(M1, freq, spp, cycleInterval);

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
plot(cycleloop, ampsStress, 'o');
title('Stress curve amplitude fn (in V) vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Stress Amplitude (V)')

% Plot phase angle at different times
figure;
hold on
plot(cycleloop, phasesStress*180/pi, 'o');
plot(cycleloop, phasesStrain*180/pi, 'o');
plot(cycleloop, phaseDiffs*180/pi, 'o');
title('Phase angle vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Phase (deg)')
hold off

% Plot phase difference at different times
figure;
plot(cycleloop, phaseDiffsinDeg, 'o');
title('Phase difference vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Phase (deg)')
axis([0 max(cycleloop) 65 90])

%% Elastic and Viscous moduli

gp = (ampsStress./ampsStrain).*cos(phaseDiffs);
gpp = (ampsStress./ampsStrain).*sin(phaseDiffs);

figure;
hold on
plot(cycleloop, gp, 'b:o');
plot(cycleloop, gpp, 'r:o');
title('Phase angle vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('G'' and G"')
legend('G''', 'G"')
hold off

%% Plot 'fourier fit'
% could add this as a check. use fft_phase_testing_v6 as example.
i = 10; % chooses which section of Stress and Strain to fit
fourierfitStress = ampsStress(i)*sin(2*pi*freq*tUncut + (phasesStress(i) + pi/2));
fourierfitStrain = ampsStrain(i)*sin(2*pi*freq*tUncut + (phasesStrain(i) + pi/2));

cycle1 = 40;
cycle2 = 43;
index1 = cycle1*spp + 1;
index2 = cycle2*spp;

% Plot sine curves. looks pretty good!
figure;
hold on
plot(tUncut(index1:index2), 0.1*(M1(index1:index2)-mean(M1(index1:index2))), 'b')
plot(tUncut(index1:index2), M2(index1:index2)- mean(M2(index1:index2)), 'g')
plot(tUncut(index1:index2), fourierfitStress(index1:index2), 'r')
plot(tUncut(index1:index2), 0.1*(fourierfitStrain(index1:index2)), 'k')
xlabel 'time'
ylabel 'x'
axis([cycle1/freq cycle2/freq -0.3 0.3])
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Phase info still not restructured for curve fitting
% 
% %% MEAN FITTING LOOP
% 
% % Use instead of exponential DC drift curve.
% 
% % Find mean of individual sections of a couple oscillations and
% % subtract the mean from each one. Should accomplish the same thing but it
% % might do a better job than the exponential fit.
% 
% % Could still be better zero each interval at the time 
% % if doing small interval fits.
% 
% cycleInterval = 6; 
% interval = cycleInterval * fs;
% lengthLoop = length(M2);
% % Define array size for new array
% M2_GZ = M2;
% % Tracking variable for last interval
% last = 1;
% 
% for start = 1:interval:(lengthLoop-interval)
%     % Need to zero the starting point to make it work
%     M2_GZ(start:start+interval) = ...
%         M2(start:start+interval) - mean(M2(start:start+interval));
%     last = start + interval;
% end
% 
% % Zero the last part that the loop missed.
% M2_GZ(last:end) = ...
%     M2(last:end) - mean(M2(last:end));
% 
% %% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)
% % Modified version. Set time = 0 at start to reduce uncertainty in phase
% 
% intervalTime = 120; 
% len1 = intervalTime * fs;
% startTime = 360;
% start1 = startTime * fs;
% 
% 
% % len1 = 10000
% % start1 = 500000;
% % Need to zero the starting point to make it work.
% % Use 1 for the starting time instead of start1 to get phase more
% % precisely.
% fit1_late = fit(tUncut(1:1+len1), M1(start1:start1+len1)-mean(M1(start1:start1+len1)), 'sin1');
% fit2_late = fit(tUncut(1:1+len1), M2_GZ(start1:start1+len1), 'sin1',...
%     'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% % Specify fit bounds to force the right frequency for the fit.
% 
% figure;
% plot(tUncut(start1:start1+len1),M2_GZ(start1:start1+len1),'g');
% hold on
% cycle1 = start1 * 1/(freq*spp);
% xlim([cycle1, cycle1+10])
% % plot(fit1_late, 'b'); 
% % Fit doesn't look pretty for some reason 
% % (number of points being used to plot i think.)
% plot(tUncut(start1:start1+len1), 0.05* (M1(start1:start1+len1)-mean(M1(start1:start1+len1))),'b');
% plot(fit2_late, 'r');
% title('Stress and Strain vs Time')
% xlabel('Time (s)')
% ylabel('Stress and Strain Amplitude (V)')
% legend('Stress', 'Strain', 'Stress Fit')
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
% %% CURVE FITTING LOOP (USING LOCALLY ZEROED CURVE) 
% % (ALSO USING TIME ZEROED FOR EACH FIT)
% 
% % Use to fit curve at many points throughout the data.
% % Gives amplitude and phase angle over time.
% 
% % Time interval in seconds (out of ~900 seconds)
% cycleInterval = 120; 
% LCut = cycleInterval * fs;
% 
% lengthLoop = size(M2_GZ);
% steps = size(1:LCut:lengthLoop-LCut);
% numSteps = steps(2);
% % Define loop data arrays
% ampStress = 1:1:numSteps;
% timeloop = 1:1:numSteps;
% % Keep track of fit values and confidence intervals
% phaseStress = 1:1:numSteps;
% phaseStrain = 1:1:numSteps;
% phaseConfStress = [1:1:numSteps; 1:1:numSteps];
% stressAmpConf = [1:1:numSteps; 1:1:numSteps];
% 
% 
% % Need to zero the starting point to make it work.
% count = 1;
% for start = 1:LCut:(lengthLoop-LCut)
% %     % Need to zero the starting point to make it work.
% %     % Can use M2_GZ or zero it within this loop.
% %     M2_LZ = M2_e1 - mean(M2_e1(start:start+interval));
%     fitStrain = fit(tUncut(1:1+LCut), ...
%         M1(start:start+LCut)-mean(M1(start:start+LCut)), 'sin1');
%     fitStress = fit(tUncut(1:1+LCut),...
%         M2_GZ(start:start+LCut), 'sin1',...
%         'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
%         'Upper', [Inf, 2*pi*freq*1.1, Inf]);
%     
%     coStrain = coeffvalues(fitStrain);
%     coStress = coeffvalues(fitStress);
%     
%     ampStress(count) = coStress(1);
%     phaseStress(count) = coStress(3);
%     phaseStrain(count) = coStrain(3);
%     cnf = confint(fitStress);
%     phaseConfStress(1:2, count) = cnf(1:2, 3);
%     stressAmpConf(1:2, count) = cnf(1:2, 1);
%     
% %     % Testing
% %     if count == 1
% %         fit1 = fitStress;
% %     end
%   
%     
% %     % Starting time of the interval
% %     timeloop(count) = 1/(freq*spp) * start;
%     % Midpoint of the interval
%     timeloop(count) = 1/(freq*spp) * (start + LCut/2);
%     count = count+1;
%     
%     % Optional Test plot for specific part
%     if count==4%numSteps;
% %         fitStress
%         figure;
%         plot(tUncut(start:start+LCut), M2_GZ(start:start+LCut), 'g');
%         hold on
%         plot(tUncut(start:start+LCut), 0.05* (M1(start:start+LCut)-mean(M1(start:start+LCut))), 'b');
%         cycle1 = (start * 1/(freq*spp));
%         xlim([cycle1, cycle1+5])
%         plot(fitStress);
%         title('Stress and Strain vs Time')
%         xlabel('Time (s)')
%         ylabel('Stress and Strain Amplitude (V)')
%         legend('Stress', 'Strain', 'Stress Fit')
%         hold off
%     end
% end
% 
% 
% %% Plot amplitude of fit curves at different times
% ampStress = abs(ampStress);
% stressAmpConf = abs(stressAmpConf);
% 
% figure;
% plot(timeloop, ampStress, 'ro');
% title('Stress curve amplitude (in V) vs Time')
% xlabel('Time (s)')
% ylabel('Stress Amplitude (V)')
% 
% phaseDiff = phaseStrain - phaseStress;
% phaseDiff = phaseDiff.';
% w_phaseDiff = wrapToPi(phaseDiff); % Try restricting to [-pi pi]
% phaseDiffDeg = phaseDiff * 180/pi;
% w_phaseDiffDeg = w_phaseDiff * 180/pi;
% 
% % PLot amplitude of fit curves with confidence intervals
% 
% stressConfPercentUp = (stressAmpConf(2,:)./ampStress)-1;
% stressConfPercentLow = 1-(stressAmpConf(1,:)./ampStress);
% 
% figure;
% errorbar(timeloop, ampStress,...
%     stressConfPercentUp.*ampStress, stressConfPercentLow.*ampStress,'o');
% title('Stress amplitude vs Time')
% xlabel('Time (s)')
% ylabel('Stress amplitude (V)')
% 
% % Compare with fourier amplitudes
% % Only works if you used the same time intervals above
% figure;
% hold on
% plot(timeloop, ampStress, 'go');
% plot(timeloop, ampsStress, 'ro');
% % errorbar(timeloop, ampStress,...
% %     stressConfPercentUp.*ampStress, stressConfPercentLow.*ampStress,'o');
% title('Stress curve amplitude (in V) vs Time')
% xlabel('Time (s)')
% ylabel('Stress Amplitude (V)')
% legend('fourier', 'curve fit')
% hold off
% 
% 
% %% Plot phase angle
% % Have to adjust to make it between 0 and 90.
% figure;
% plot(timeloop, phaseDiffDeg, 'o')
% title('Phase angle vs Time')
% xlabel('Time (s)')
% ylabel('phase angle (V)')
% ylim([-1.5*180/pi -1*180/pi])
% 
% 
% phaseConfStressPercentUp = (phaseConfStress(2,:)./phaseStress)-1;
% phaseConfStressPercentLow = 1-(phaseConfStress(1,:)./phaseStress);
% 
% phaseStrain = phaseStrain.';
% phaseStress = phaseStress.';
% 
% phaseConfStressPercentUp = phaseConfStressPercentUp.';
% phaseConfStressPercentLow = phaseConfStressPercentLow.';
% 
% % Plot stress phase with error bars
% figure;
% errorbar(timeloop, phaseStress,...
%     phaseConfStressPercentUp.*phaseStress, phaseConfStressPercentLow.*phaseStress,'o');
% title('Phase angle vs Time')
% xlabel('Time (s)')
% ylabel('phase angle (V)')
% 
% % Plot phase angle difference with error bars
% figure;
% errorbar(timeloop, phaseDiffDeg,...
%     phaseConfStressPercentUp.*phaseDiffDeg, phaseConfStressPercentLow.*phaseDiffDeg,'o');
% title('Phase angle vs Time')
% xlabel('Time (s)')
% ylabel('phase angle (V)')
% 
% 
% 
