%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% viscosity_calc.m

% Viscocity calculation script

% Imports data for piezo X, shear X, piezo Y, shear Y from txt file.
% Calculates principle frequency, amplitude of signal, SNR.
% Uses fourier transforms and/or curve fitting.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORT AND CUT DATA

%%% 1Hz data
folderpath = ['C:\Users\Eric\Documents\Xerox Data\Shear Data'];
numfiles = 9;
filepath = cell(numfiles,1);
rawdata = cell(numfiles,1);

for i = 1:1:numfiles
    filepath{i} = [folderpath, '\', '0.5Hz 0.3V 9-12-16 part', num2str(i), '\', 'a1_0.3000_a2_0.0000_f1_0.5000_f2_1.0000_p_00.txt'];
    rawdata{i} = dlmread(filepath{i});
    
    if i == 1
        rawdataTotal = rawdata{i};
    else
        rawdataTotal = cat(1,rawdataTotal,rawdata{i});
    end
end


% %%% 1Hz data
% filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
%     '1Hz 0.2V 8-17-16\a1_0.2000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];
    
%%% 2Hz data
% filename = ['C:\Users\Eric\Documents\Xerox Data\Shear Data\'...
%     '2Hz 1.9V 7-12-16\a1_1.9000_a2_0.0000_f1_2.0000_f2_1.0000_p_00.txt'];

% Frequency and samples per period
freq = 0.5;
spp = 1000;
% Sampling frequency (spp = samples per period) and time
Fs = (freq * spp);
T = 1/Fs;

% Import shear data file
M = rawdataTotal;

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1_precut = M(:, 1); % Piezo X (proportional to strain)
M2_precut = M(:, 2); % Signal X (proportional to stress)
M3_precut = M(:, 3); % Piezo Y
M4_precut = M(:, 4); % Signal Y

% Shouldn't start until time 6s or so when I zeroed the amplifiers.
% Time 2s * freq * spp = 4000 (cut index)

% Note: Sign of stress can be (kind of) arbitrarily reversed. It depends on
% which direction you define as positive stress (compressive).
cut = 4000;
M1 = M1_precut(cut:size(M1_precut));
M2 = M2_precut(cut:size(M2_precut));
M3 = M3_precut(cut:size(M3_precut));
M4 = M4_precut(cut:size(M4_precut));


% Plotting of precut data (if I want to look).
% Timesteps precut
time_precut = 1/(freq * spp) * (0:1:size(M1_precut)-1);
time_precut = time_precut.';
% length of signal
L_precut = size(M1_precut);

% Precut plots (for tracking of cut boundaries)
figure;
plot(time_precut, M1_precut, 'b');
% xlim([0,20]);
hold on
plot(time_precut, M2_precut, 'r');
plot(time_precut, M3_precut, 'c');
plot(time_precut, M4_precut, 'g');
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

% Timesteps
time = 1/(freq * spp) * (0:1:size(M1)-1);
time = time.';
% length of signal
L = size(M1);

% % Piezo conversion: 1 V = 25 um displacement.
% % strain = displacement / gap
% gap = 37; % gap might actually be 12 or 13. 
% strain = M1 * 25 / gap;
% 
% % strain rate = strain * 2 * pi * freqency
% strainRate = 2 * pi * freq * strain;

% % Plot Piezo X vs time and signal X vs time
% figure;
% plot(time, M1_0, 'b');
% xlim([0,10]);
% hold on
% % plot(time, M4_0, 'r');
% % plot(time, M3_0, 'c');
% plot(time, M2_0, 'g');
% hold off
% 
% % Plot limited range without DC offset. And with optional curve fit.
% t1 = 10;
% t2 = 20;
% lim1 = t1*freq*spp+1;
% lim2 = t2*freq*spp+1;
% figure;
% plot(time(lim1:lim2), M1_0(lim1:lim2),'b');
% hold on
% xlim([t1,t2]);
% plot(time(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'g');
% Curve fit included for the signal if wanted.
% strainfit = fit(time(lim1:lim2), M1_0(lim1:lim2), 'sin1');
% stressfit = fit(time(lim1:lim2), M2(lim1:lim2) - mean(M2(lim1:lim2)), 'sin1');
% plot(stressfit, 'r');
% title('Strain and Stress (in V) vs. Time')
% xlabel('Time (s)')
% ylabel('Stress and Strain (V)')
% hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER TRANSFORM of whole signal.
% This gets the main frequency component and likely averages over the
% amplitudes.
% 
% Fourier transform of signal to get principal components
% 2 * Absolute value of it
V = 2 * abs(fft(M2_0)) / L(1);
f = Fs * linspace(0,1, L(1));

% Plot
figure;
plot(f,V); 
xlim([0.2, 1.5])
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURIER TRANSFORM LOOP
% Use repeated fourier transforms to different sections to find the
% amplitude of the strain at different points in time.

timeInterval = 60; % Time interval in seconds
interval = timeInterval * freq * spp;
count = 1;
steps = size(1:interval:(size(M2_0)-interval));
amploop = 1:1:steps;
indexloop = 1:1:steps;
freqloop = 1:1:steps;
timeloop = 1:1:steps;


for start = 1:interval:(size(M2_0) - interval)
    Vloop = 2 * abs(fft(M2_0(start:start+interval-1))) / interval;
    floop = Fs * linspace(0,1,interval);
    
    % Optional print one figure of a single fourier section
    if start == 1 + 8*interval
        figure;
        plot(floop, Vloop);
        xlim([0.2, 3])
        title('Single-Sided Amplitude Spectrum of V(t)')
        xlabel('Frequency (Hz)')
        ylabel('|V(f)|')
    end
    [amploop(count), indexloop(count)] = max(Vloop(30:500));
    freqloop(count) = (indexloop(count)+(30-1)-1) / interval * Fs; % Frequency working.
    
%     % Starting time of the interval
%     timeloop(count) = 1/(freq*spp) * start;
    % Midpoint of the interval
    timeloop(count) = 1/(freq*spp) * (start + interval/2);
    count = count+1;
end

% Plot amplitude of fourier peak at different times
figure;
plot(timeloop, amploop, 'o');
title('Stress curve amplitude (in V) vs Time')
xlabel('Time (s)')
ylabel('Stress Amplitude (V)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVE FITTING

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEAN FITTING LOOP

% Use instead of exponential DC drift curve.

% Find mean of individual sections of a couple oscillations and
% subtract the mean from each one. Should accomplish the same thing but it
% might do a better job than the exponential fit.

% Could still be better zero each interval at the time 
% if doing small interval fits.

% Time interval in seconds (out of ~1300 seconds)
timeInterval = 4; 
interval = timeInterval * freq * spp;
lengthLoop = size(M2);
% Define array size for new array
M2_GZ = M2;
% Tracking variable for last interval
last = 1;

for start = 1:interval:(lengthLoop(1)-interval)
    % Need to zero the starting point to make it work
    M2_GZ(start:start+interval) = ...
        M2(start:start+interval) - mean(M2(start:start+interval));
    
    last = start + interval;
%     % Optional Test plot for specific part
%     if count==numSteps;
%         plot(time(start:start+interval), M2_LZ(start:start+interval), 'b');
%         hold on
%         plot(fitStress);
%         hold off
%     end
end

% Zero the last part that the loop missed.
M2_GZ(last:lengthLoop(1)) = ...
    M2(last:lengthLoop(1)) - mean(M2(last:lengthLoop(1)));

% figure;
% plot(time, M2_GZ, 'g');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVE FITTING AT A LATER TIME (SHORTER PERIOD)
% Modified version. Set time = 0 at start to reduce uncertainty in phase

intervalTime = 120; 
len1 = intervalTime * freq * spp;
startTime = 300;
start1 = startTime * freq * spp;


% len1 = 10000;
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
xlim([t1, t1+5])
% plot(fit1_late, 'b'); 
% Fit doesn't look pretty for some reason 
% (number of points being used to plot i think.)
plot(time(start1:start1+len1), M1_0(start1:start1+len1),'b');
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
% CURVE FITTING LOOP (USING LOCALLY ZEROED CURVE) 
% (ALSO USING TIME ZEROED FOR EACH FIT)

% Use to fit curve at many points throughout the data.
% Gives amplitude and phase angle over time.

% Time interval in seconds (out of ~900 seconds)
timeInterval = 120; 
interval = timeInterval * freq * spp;

lengthLoop = size(M2_GZ);
steps = size(1:interval:lengthLoop(1)-interval);
numSteps = steps(2);
% Define loop data arrays
ampStress = 1:1:numSteps;
timeloop = 1:1:numSteps;
% Keep track of fit values and confidence intervals
phaseStress = 1:1:numSteps;
phaseStrain = 1:1:numSteps;
phaseConfStress = [1:1:numSteps; 1:1:numSteps];


% Need to zero the starting point to make it work.
count = 1;
for start = 1:interval:(lengthLoop(1)-interval)
%     % Need to zero the starting point to make it work.
%     % Can use M2_GZ or zero it within this loop.
%     M2_LZ = M2_e1 - mean(M2_e1(start:start+interval));
    fitStrain = fit(time(1:1+interval), ...
        M1_0(start:start+interval), 'sin1');
    fitStress = fit(time(1:1+interval),...
        M2_GZ(start:start+interval), 'sin1',...
        'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
        'Upper', [Inf, 2*pi*freq*1.1, Inf]);
    
    coStrain = coeffvalues(fitStrain);
    coStress = coeffvalues(fitStress);
    
    ampStress(count) = coStress(1);
    phaseStress(count) = coStress(3);
    phaseStrain(count) = coStrain(3);
    cnf = confint(fitStress);
    phaseConfStress(1:2, count) = cnf(1:2, 3);
    
%     % Starting time of the interval
%     timeloop(count) = 1/(freq*spp) * start;
    % Midpoint of the interval
    timeloop(count) = 1/(freq*spp) * (start + interval/2);
    count = count+1;
    
    % Optional Test plot for specific part
    if count==2%numSteps;
%         fitStress
        figure;
        plot(time(start:start+interval), M2_GZ(start:start+interval), 'g');
        hold on
        plot(time(start:start+interval), M1_0(start:start+interval), 'b');
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


% Plot amplitude of fit curves at different times
figure;
plot(timeloop, ampStress, 'o');
title('Stress curve amplitude (in V) vs Time')
xlabel('Time (s)')
ylabel('Stress Amplitude (V)')


phaseDiff = phaseStrain - phaseStress;
phaseDiffDeg = phaseDiff * 180/pi;

% Plot phase angle
% Have to adjust to make it between 0 and 90.
figure;
plot(timeloop, phaseDiffDeg, 'o')
title('Phase angle vs Time')
xlabel('Time (s)')
ylabel('phase angle (V)')


phaseConfStressPercentUp = (phaseConfStress(2,:)./phaseStress)-1;
phaseConfStressPercentLow = 1-(phaseConfStress(1,:)./phaseStress);

% Plot stress phase with error bars
figure;
errorbar(timeloop, phaseStress,...
    phaseConfStressPercentUp.*phaseStress, phaseConfStressPercentLow.*phaseStress,'o');
title('Phase angle vs Time')
xlabel('Time (s)')
ylabel('phase angle (V)')

% Plot phase angle difference with error bars
figure;
errorbar(timeloop, 180-phaseDiffDeg,...
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
% interval = timeInterval * freq * spp;
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

