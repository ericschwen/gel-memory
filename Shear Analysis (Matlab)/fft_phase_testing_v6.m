%% Modifications to Example from FFT Phase on mathworks

% v6: getting right phases from fourier info!

% Import shear data file
filepath = ['C:\Eric\Xerox Data\Shear Data\0.3333Hz 4-11-17\1.4V\training\'...
    'a1_1.4000_a2_0.0000_f1_0.3333_f2_1.0000_p_90.txt'];
M = dlmread(filepath);

% Frequency and samples per period
freq = 0.3333;
spp = 1000;
fs = freq*spp;

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
% Note: not sure which is x and y between M2 and M4 currently
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

cutTime = 63; % in seconds
M1cut = M1(1:uint32(fs * cutTime));
M2cut = M2(1:uint32(fs * cutTime));

% Time vector and data to fit
t = 0:1/fs:length(M1cut)/fs-1/fs;
t = t.';
% t = 1/fs:1/fs:length(M1cut)/fs;
x1 = M1cut - mean(M1cut);
x2 = M2cut - mean(M2cut);

% Compute the discrete Fourier transform of the signal. 
y1 = fft(x1);
y2 = fft(x2);

% Compute the phase angles for the 15 Hz signals in each sinusoid and
% compute the phase difference.
% index = freq * length(t) / fs
% Something weird with non-integer values for the index i want
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEED freq*cutTime TO BE AN INTEGER FOR PHASE FIT TO GET CORRECT PHASE!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freqIndex = freq * length(t)/fs+1;
phase1 = angle(y1(uint32(freqIndex))); 
phase2 = angle(y2(uint32(freqIndex)));
phaseDiff = phase2-phase1;
phaseDiffinPi = phaseDiff/pi;
phaseDiffinDeg = phaseDiff * 180/pi;

% Test plot "fourier fit"
% fourierfit1 = 1.2*cos(2*pi*freq*t + phase1);
% fourierfit2 = 1.2*cos(2*pi*freq*t + phase2);
fourierfit1 = 1.2*sin(2*pi*freq*t + (phase1 + pi/2));
fourierfit2 = 1.2*sin(2*pi*freq*t + (phase2 + pi/2));

time1 = 0;
time2 = 10;
index1 = time1 * fs+1;
index2 = time2*fs+1;

% Curve fitting
curvefit1 = fit(t,x1,'sin1');
% curvefit2 = fit(t',x2,'sin1');
curvefit2 = fit(t(index1:index2), x2(index1:index2), 'sin1',...
    'Lower',[-Inf, 2*pi*freq*0.9, -Inf], 'Upper', [Inf, 2*pi*freq*1.1, Inf]);
co1 = coeffvalues(curvefit1);
co2 = coeffvalues(curvefit2);
phaseFit1 = co1(3);
phaseFit2 = co2(3);
phaseFitDiff = phaseFit2-phaseFit1;
phaseFitDiffDeg = phaseFitDiff*180/pi;

% Plot sine curves
figure;
hold on
plot(t,x2, 'g')
plot(t,0.1*x1, 'b')
plot(curvefit1, 'r')
plot(curvefit2, 'k')
plot(t, 0.1*fourierfit1, 'r:')
plot(t, 0.1*fourierfit2, 'k:')
xlabel 'time'
ylabel 'x'
axis([0 10 -0.1 0.1])
hold off

% phaseFitDiff + 2 * pi = phaseDiff (from fourier)
% (for one test at least)

% % need freq*timeInterval to be a whole number for phase to fit right
% % full time interval = length(M1)/fs
% timeInterval = uint32((length(M1)/fs)/freq);

% turns out to just be the same as having a whole nubmer of periods
% timeInterval = length(M1)/spp;

