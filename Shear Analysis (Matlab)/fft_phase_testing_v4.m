%% Modifications to Example from FFT Phase on mathworks

% Generate 2 signals that consists of sinusoids of frequencies 15 Hz 
% and 40 Hz. The signals are sampled at 100 Hz for one second.
freq = 15;
fs = 1000;
t = 0:1/fs:1-1/fs;
x1 = sin(2*pi*freq*t - 43*pi/180);
x2 = sin(2*pi*freq*t - 322*pi/180);

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
curvefit1 = fit(t',x1','sin1');
curvefit2 = fit(t',x2','sin1');
co1 = coeffvalues(curvefit1);
co2 = coeffvalues(curvefit2);
phaseFit1 = co1(3);
phaseFit2 = co2(3);
phaseFitDiff = phaseFit2-phaseFit1;

% Plot sine curves
figure;
hold on
plot(t,x1*0.8, 'g')
plot(t,x2*0.8, 'b')
plot(curvefit1, 'r')
plot(curvefit2, 'c')
plot(t, fourierfit1, 'r:')
plot(t, fourierfit2, 'c:')
xlabel 'time'
ylabel 'x'
axis([0 0.2 -1.3 1.3])
hold off




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

