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

% signal length
L = length(M1);

% %% Full plots of stress and strain
% figure;
% plot(tFull, M1, 'b');
% % xlim([0,20]);
% hold on
% plot(tFull, M2, 'r');
% plot(tFull, M3, 'c');
% plot(tFull, M4, 'g');
% hold off


%% Plot limited range without DC offset.
t1 = 100;
t2 = 106;
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

%% FOURIER TRANSFORM LOOP
% Use repeated fourier transforms to different sections to find the
% amplitude of the strain at different points in time.

% should rewrite this as a funciton.

% Set time interval for transform for each step in loop
% MAKE SURE timeInterval * freq IS AN INTEGER
timeInterval = 120; % Time interval in seconds
LCut = timeInterval * fs;
% number of steps in loop
steps = length(1:LCut:(L-LCut));

% Save results to arrays
ampMaxStressCut = 1:1:steps;
indexMaxStressCut = 1:1:steps;
freqStressCut = 1:1:steps;
phaseCut = 1:1:steps;

% Keep track of the timesteps
timeloop = timeInterval/2:timeInterval:steps*timeInterval;


for i = 1:1:steps
    startIndex = LCut * (i-1) + 1;
    lastIndex = startIndex + LCut - 1;
    stressCut = M2(startIndex:lastIndex);
    tcut = 1/fs * (startIndex:1:lastIndex);
    
    ycut = fft(stressCut);
    
    freqIndex = freq * length(tcut)/fs+1;
    phaseCut(i) = angle(ycut(uint32(freqIndex)));
    
    P2Cut = abs(ycut/LCut);
    % Compute single sided spectrum P1 based on P2 and even-valued signal of
    % length L.
    P1Cut = P2Cut(1:LCut/2+1);
    P1Cut(2:end-1) = 2*P1Cut(2:end-1);
    
    % Frequencies for plotting
    fCut = fs*(0:(LCut/2))/LCut;
    
    % Get amplitude of peak and freqency where it occurs
    f1 = 0.1;
    f2 = 1.5;
    index1 = uint32(f1 * LCut / fs +1); % get index in frequency vector
    index2 = uint32(f2 * LCut / fs +1);
    [ampMax_2, indexMax_2] = max(P1Cut(index1:index2));
    [ampMaxStressCut(i), indexMaxStressCut(i)] = max(P1Cut(index1:index2));

    freqStressCut(i) = fCut(indexMaxStressCut(i) + index1 - 1);
    
    % Optional print one figure of a single fourier section
    if i == 3
        figure;
        plot(fCut, P1Cut);
        xlim([0.05, 1.5])
        title('Single-Sided Amplitude Spectrum of V(t)')
        xlabel('Frequency (Hz)')
        ylabel('|V(f)|')
    end
    
    
end

% Plot amplitude of fourier peak at different times
figure;
% timeloop*freq = shear cycles
plot(timeloop*freq, ampMaxStressCut, 'o');
title('Stress curve amplitude (in V) vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Stress Amplitude (V)')

% Plot phase angle at different times
figure;
plot(timeloop*freq, phaseCut, 'o');
title('Phase angle vs Shear Cycle')
xlabel('Shear Cycles')
ylabel('Phase (rad)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)
% Modified version. Set time = 0 at start to reduce uncertainty in phase

intervalTime = 120; 
len1 = intervalTime * Fs;
startTime = 360;
start1 = startTime * Fs;


% len1 = 10000
% start1 = 500000;
% Need to zero the starting point to make it work.
% Use 1 for the starting time instead of start1 to get phase more
% precisely.
fit1_late = fit(time(1:1+len1), M1_0(start1:start1+len1), 'sin1');
fit2_late = fit(time(1:1+len1), M2_GZ(start1:start1+len1), 'sin1',...
    'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% Specify fit bounds to force the right frequency for the fit.

figure;
plot(time(start1:start1+len1),M2_GZ(start1:start1+len1),'g');
hold on
t1 = start1 * 1/(freq*spp);
xlim([t1, t1+10])
% plot(fit1_late, 'b'); 
% Fit doesn't look pretty for some reason 
% (number of points being used to plot i think.)
plot(time(start1:start1+len1), 0.05* M1_0(start1:start1+len1),'b');
plot(fit2_late, 'r');
title('Stress and Strain vs Time')
xlabel('Time (s)')
ylabel('Stress and Strain Amplitude (V)')
legend('Stress', 'Strain', 'Stress Fit')
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
%% CURVE FITTING LOOP (USING LOCALLY ZEROED CURVE) 
% (ALSO USING TIME ZEROED FOR EACH FIT)

% Use to fit curve at many points throughout the data.
% Gives amplitude and phase angle over time.

% Time interval in seconds (out of ~900 seconds)
timeInterval = 120; 
LCut = timeInterval * Fs;

lengthLoop = size(M2_GZ);
steps = size(1:LCut:lengthLoop(1)-LCut);
numSteps = steps(2);
% Define loop data arrays
ampStress = 1:1:numSteps;
timeloop = 1:1:numSteps;
% Keep track of fit values and confidence intervals
phaseStress = 1:1:numSteps;
phaseStrain = 1:1:numSteps;
phaseConfStress = [1:1:numSteps; 1:1:numSteps];
stressAmpConf = [1:1:numSteps; 1:1:numSteps];


% Need to zero the starting point to make it work.
count = 1;
for start = 1:LCut:(lengthLoop(1)-LCut)
%     % Need to zero the starting point to make it work.
%     % Can use M2_GZ or zero it within this loop.
%     M2_LZ = M2_e1 - mean(M2_e1(start:start+interval));
    fitStrain = fit(time(1:1+LCut), ...
        M1_0(start:start+LCut), 'sin1');
    fitStress = fit(time(1:1+LCut),...
        M2_GZ(start:start+LCut), 'sin1',...
        'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
        'Upper', [Inf, 2*pi*freq*1.1, Inf]);
    
    coStrain = coeffvalues(fitStrain);
    coStress = coeffvalues(fitStress);
    
    ampStress(count) = coStress(1);
    phaseStress(count) = coStress(3);
    phaseStrain(count) = coStrain(3);
    cnf = confint(fitStress);
    phaseConfStress(1:2, count) = cnf(1:2, 3);
    stressAmpConf(1:2, count) = cnf(1:2, 1);
    
%     % Testing
%     if count == 1
%         fit1 = fitStress;
%     end
  
    
%     % Starting time of the interval
%     timeloop(count) = 1/(freq*spp) * start;
    % Midpoint of the interval
    timeloop(count) = 1/(freq*spp) * (start + LCut/2);
    count = count+1;
    
    % Optional Test plot for specific part
    if count==4%numSteps;
%         fitStress
        figure;
        plot(time(start:start+LCut), M2_GZ(start:start+LCut), 'g');
        hold on
        plot(time(start:start+LCut), 0.05* M1_0(start:start+LCut), 'b');
        t1 = (start * 1/(freq*spp));
        xlim([t1, t1+5])
        plot(fitStress);
        title('Stress and Strain vs Time')
        xlabel('Time (s)')
        ylabel('Stress and Strain Amplitude (V)')
        legend('Stress', 'Strain', 'Stress Fit')
        hold off
    end
end


%% Plot amplitude of fit curves at different times
ampStress = abs(ampStress);
stressAmpConf = abs(stressAmpConf);

figure;
plot(timeloop, ampStress, 'ro');
title('Stress curve amplitude (in V) vs Time')
xlabel('Time (s)')
ylabel('Stress Amplitude (V)')

phaseDiff = phaseStrain - phaseStress;
phaseDiff = phaseDiff.';
w_phaseDiff = wrapToPi(phaseDiff); % Try restricting to [-pi pi]
phaseDiffDeg = phaseDiff * 180/pi;
w_phaseDiffDeg = w_phaseDiff * 180/pi;

% PLot amplitude of fit curves with confidence intervals

stressConfPercentUp = (stressAmpConf(2,:)./ampStress)-1;
stressConfPercentLow = 1-(stressAmpConf(1,:)./ampStress);

figure;
errorbar(timeloop, ampStress,...
    stressConfPercentUp.*ampStress, stressConfPercentLow.*ampStress,'o');
title('Stress amplitude vs Time')
xlabel('Time (s)')
ylabel('Stress amplitude (V)')

% Compare with fourier amplitudes
% Only works if you used the same time intervals above
figure;
hold on
% plot(timeloop, ampStress, 'go');
plot(timeloop, ampMaxStressCut, 'ro');
errorbar(timeloop, ampStress,...
    stressConfPercentUp.*ampStress, stressConfPercentLow.*ampStress,'o');
title('Stress curve amplitude (in V) vs Time')
xlabel('Time (s)')
ylabel('Stress Amplitude (V)')
legend('fourier', 'curve fit')
hold off

%% Plot phase angle
% Have to adjust to make it between 0 and 90.
figure;
plot(timeloop, phaseDiffDeg, 'o')
title('Phase angle vs Time')
xlabel('Time (s)')
ylabel('phase angle (V)')
ylim([-1.5*180/pi -1*180/pi])


phaseConfStressPercentUp = (phaseConfStress(2,:)./phaseStress)-1;
phaseConfStressPercentLow = 1-(phaseConfStress(1,:)./phaseStress);

phaseStrain = phaseStrain.';
phaseStress = phaseStress.';

phaseConfStressPercentUp = phaseConfStressPercentUp.';
phaseConfStressPercentLow = phaseConfStressPercentLow.';

% Plot stress phase with error bars
figure;
errorbar(timeloop, phaseStress,...
    phaseConfStressPercentUp.*phaseStress, phaseConfStressPercentLow.*phaseStress,'o');
title('Phase angle vs Time')
xlabel('Time (s)')
ylabel('phase angle (V)')

% Plot phase angle difference with error bars
figure;
errorbar(timeloop, phaseDiffDeg,...
    phaseConfStressPercentUp.*phaseDiffDeg, phaseConfStressPercentLow.*phaseDiffDeg,'o');
title('Phase angle vs Time')
xlabel('Time (s)')
ylabel('phase angle (V)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old parts I don't use but didn't want to delete:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % FOURIER TRANSFORM OF SMALLER SECTIONS OF SIGNAL
% 
% % Beginning 200 seconds. Amplitude higher than overall.
% L1 = 100000;
% V1 = 2 * abs(fft(M2_0(1:L1))) / L1;
% f1 = Fs * linspace(0,1, L1);
% 
% plot(f1,V1); 
% xlim([0.2, 1])
% title('Single-Sided Amplitude Spectrum of V(t)')
% xlabel('Frequency (Hz)')
% ylabel('|V(f)|')
% 
% % Middle(ish) 200 seconds. Middling amplitude.
% V3 = 2 * abs(fft(M2_0(3*L1+1:4*L1))) / L1;
% f3 = Fs * linspace(0,1,L1);
% 
% plot(f3,V3); 
% xlim([0.2, 1])
% title('Single-Sided Amplitude Spectrum of V(t)')
% xlabel('Frequency (Hz)')
% ylabel('|V(f)|')
% % 
% [ampV3, index3] = max(V3(10:5000)); % Amplitude matches with sine fit later.
% 
% freqV3 = (index3+(10-1)-1) / L1 * Fs; % Frequency working.
% 
% 
% % Another 200 seconds near the end. Amplitude less than overall.
% V2 = 2 * abs(fft(M2_0(5*L1+1:6*L1))) / L1;
% f2 = Fs * linspace(0,1,L1);
% 
% plot(f2,V2); 
% xlim([0.2, 1])
% title('Single-Sided Amplitude Spectrum of V(t)')
% xlabel('Frequency (Hz)')
% ylabel('|V(f)|')
% 
% 
% % % % Plots of the data for the fourier transforms above.
% plot(time(1:L1), M2_0(1:L1));
% xlim([0,20]);
% plot(time(3*L1+1:4*L1), M2_0(3*L1+1:4*L1));
% xlim([700, 720]);
% plot(time(5*L1+1:6*L1), M2_0(5*L1+1:6*L1));
% xlim([1000, 1020]);
% 
% 
% % Looks like the amplitude decreases over the course of the process (Both 
% % in fourier transform and in regular signal. Shear thinning? 
% % I could write a loop to evaluate specific sections and plot the
% % decreasing amplitude over time.
% 
% % SNR is also much lower at later timesteps. I think lower signal but
% % similar noise levels.
% 
% % First 20s. 
% len4 = 10000;
% V4 = 2 * abs(fft(M2_0(1:len4))) / len4;
% f4 = Fs * linspace(0,1,len4);
% 
% plot(f4,V4); 
% xlim([0.2, .7])
% title('Single-Sided Amplitude Spectrum of V(t)')
% xlabel('Frequency (Hz)')
% ylabel('|V(f)|')
% 
% [ampV4, index4] = max(V4(10:5000)); % Amplitude matches with sine fit later.
% 
% freqV4 = (index4+(10-1)-1) / len4 * Fs; % Frequency working.
% 
% % Could try using fourier transform on signal without DC shift to get rid
% % of peak at 0 Hz and get SNR better. That might throw in extra
% % complications though so I'll leave it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % CURVE FITTING LOOP (USING LOCALLY ZEROED CURVE)
% 
% % Use to fit curve at many points throughout the data.
% % Gives amplitude and phase angle over time.
% 
% % Time interval in seconds (out of ~900 seconds)
% timeInterval = 120; 
% interval = timeInterval * Fs;
% count = 1;
% lengthLoop = size(M2_GZ);
% steps = size(1:interval:lengthLoop(1)-interval);
% numSteps = steps(2);
% % Define loop data arrays
% ampStress = 1:1:numSteps;
% phaseDiff = 1:1:numSteps;
% phaseDiffDeg = 1:1:numSteps;
% timeloop = 1:1:numSteps;
% 
% % Need to zero the starting point to make it work.
% 
% for start = 1:interval:(lengthLoop(1)-interval)
% %     % Need to zero the starting point to make it work.
% %     % Can use M2_GZ or zero it within this loop.
% %     M2_LZ = M2_e1 - mean(M2_e1(start:start+interval));
%     fitStrain = fit(time(start:start+interval), ...
%         M1_0(start:start+interval), 'sin1');
%     fitStress = fit(time(start:start+interval),...
%         M2_GZ(start:start+interval), 'sin1');
%     
%     coStrain = coeffvalues(fitStrain);
%     coStress = coeffvalues(fitStress);
%     
%     ampStress(count) = coStress(1);
%     phaseDiff(count) = (coStress(3) - coStrain(3));
%     phaseDiffDeg(count) = phaseDiff(count) * 180/pi;
%     
% %     % Starting time of the interval
% %     timeloop(count) = 1/(freq*spp) * start;
%     % Midpoint of the interval
%     timeloop(count) = 1/(freq*spp) * (start + interval/2);
%     count = count+1;
%     
% %     % Optional Test plot for specific part
% %     if count==numSteps;
% %         plot(time(start:start+interval), M2_LZ(start:start+interval), 'b');
% %         hold on
% %         plot(fitStress);
% %         hold off
% %     end
% end
% 
% 
% % Plot amplitude of fit curves at different times
% figure;
% plot(timeloop, ampStress, 'o');
% title('Stress curve amplitude (in V) vs Time')
% xlabel('Time (s)')
% ylabel('Stress Amplitude (V)')
% 
% % Plot phase angle
% % Not sure this is really working yet. Very noisy towards the end.
% figure;
% plot(timeloop, phaseDiffDeg, 'o')
% title('Phase angle vs Time')
% xlabel('Time (s)')
% ylabel('phase angle (V)')


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)

% % Need to zero the starting point to make it work.
% len1 = 10000;
% start1 = 500000;
% % M2_late = M2_e1 - mean(M2_e1(start1:start1+len1)); % If using exp fit.
% fit1_late = fit(time(start1:start1+len1), M1_0(start1:start1+len1), 'sin1');
% fit2_late = fit(time(start1:start1+len1), M2_GZ(start1:start1+len1), 'sin1',...
%     'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% % Specify fit bounds to force the right frequency for the fit.
% 
% figure;
% plot(time(start1:start1+len1),M2_GZ(start1:start1+len1),'g');
% hold on
% plot(fit1_late, 'b');
% plot(fit2_late, 'r');
% xlim([251 255])
% title('Stress and Strain vs Time')
% xlabel('Time (s)')
% ylabel('Stress and Strain Amplitude (V)')
% legend('Stress', 'Strain', 'Stress Fit')
% hold off
% % Fit seems to be working. Could be underestimating amplitude within the
% % noise. Hard to tell. Fourier transform is probably better for amplitude
% % with this much noise. This can still find the phase pretty well though.
% % Maybe? Confidence bounds are huge in the phase. Probably will work
% % better(less uncertainty) with larger range.
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

