%% Modifications to Example from FFT Phase on mathworks

% Import shear data file
filepath = ['C:\Eric\Xerox Data\Shear Data\glycerol testing 4-20-17\12 um gap xshear\'...
    'a1_3.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];
M = dlmread(filepath);

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
% Note: not sure which is x and y between M2 and M4 currently
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y


freq = 1;
fs = 1000;
% t = 0:1/fs:length(M1)/fs-1/fs;
t = 1/fs:1/fs:length(M1)/fs;
x1 = M1 - mean(M1);
x2 = M2 - mean(M2);

% Compute the discrete Fourier transform of the signal. 
y1 = fft(x1);
y2 = fft(x2);

% Compute the phase angles for the 15 Hz signals in each sinusoid and
% compute the phase difference.
phase1 = angle(y1(freq * length(t)/fs+1)); % index = freq * length(t) / fs
phase2 = angle(y2(freq * length(t)/fs+1));
phaseDiff = phase2-phase1;
phaseDiffinPi = phaseDiff/pi;
phaseDiffinDeg = phaseDiff * 180/pi;

% Test plot "fourier fit"
% fourierfit1 = 1.2*cos(2*pi*freq*t + phase1);
% fourierfit2 = 1.2*cos(2*pi*freq*t + phase2);
fourierfit1 = 1.2*sin(2*pi*freq*t + (phase1 + pi/2));
fourierfit2 = 1.2*sin(2*pi*freq*t + (phase2 + pi/2));

% Curve fitting
curvefit1 = fit(t',x1,'sin1');
curvefit2 = fit(t',x2,'sin1');
co1 = coeffvalues(curvefit1);
co2 = coeffvalues(curvefit2);
phaseFit1 = co1(3);
phaseFit2 = co2(3);
phaseFitDiff = phaseFit2-phaseFit1;
phaseFitDiffDeg = phaseFitDiff*180/pi;

% Plot sine curves
figure;
hold on
plot(t,x1, 'g')
plot(t,x2, 'b')
plot(curvefit1, 'r')
plot(curvefit2, 'c')
plot(t, fourierfit1, 'r:')
plot(t, fourierfit2, 'c:')
xlabel 'time'
ylabel 'x'
axis([0 5 -3 3])
hold off

% phaseFitDiff + 2 * pi = phaseDiff (from fourier)


%% Plot the magnitude of the transform as a function of frequency.
ly = length(y1);
f = (-ly/2:ly/2-1)/ly*fs;

figure;
stem(f,abs(fftshift(y1)))
xlabel 'Frequency (Hz)'
ylabel '|y|'

% Find the phase of the transform and plot it as a function of frequency.

phs = angle(fftshift(y1));

plot(f,phs/pi)
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'
grid

