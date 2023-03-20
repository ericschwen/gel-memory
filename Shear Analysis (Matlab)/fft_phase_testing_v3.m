% Modifications to Example from FFT Phase on mathworks

filepath = ['C:\Eric\Xerox Data\Shear Data\4-25-17 glycerol testing (meeras cell)\12 um gap\1.0V xshear\'...
    'a1_1.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];
rawdata = dlmread(filepath);
rawdataTotal = rawdata;

% Import shear data file
M = rawdataTotal;

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
% Note: not sure which is x and y between M2 and M4 currently
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress in x direction)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

fs = 1000;
% Timesteps
t = 1/(fs) * (0:1:size(M1)-1);
x = M1;
x2 = M2;
freq = 1;

% Compute the discrete Fourier transform of the signal. 
y = fft(x);
y2 = fft(x2);

% Compute the phase angles for the 15 Hz signals in each sinusoid and
% compute the phase difference.
phase1 = angle(y(freq * length(t)/fs)); % index = freq * length(t) / fs
phase2 = angle(y2(freq * length(t)/fs));
phaseDiff = phase2-phase1;
phaseDiffinPi = phaseDiff/pi;
phaseDiffinDeg = phaseDiff * 180/pi;

% Test plot "fit"
fit1 = 1.1*cos(2*pi*freq*t + phase1);
fit2 = 1.1*cos(2*pi*freq*t + phase2);

figure;
hold on
plot(t,x - mean(x), 'g')
plot(t,x2, 'b')
plot(t, fit1, 'r')
plot(t, fit2, 'c')
xlabel 'time'
ylabel 'x'
axis([0 3 -5 5])
hold off



%% Plot the magnitude of the transform as a function of frequency.
ly = length(y);
f = (-ly/2:ly/2-1)/ly*fs;

figure;
stem(f,abs(fftshift(y)))
xlabel 'Frequency (Hz)'
ylabel '|y|'

% Find the phase of the transform and plot it as a function of frequency.

phs = angle(fftshift(y));

plot(f,phs/pi)
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'
grid
