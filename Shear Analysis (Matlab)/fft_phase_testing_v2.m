%% Modifications to Example from FFT Phase on mathworks

% Generate 2 signals that consists of sinusoids of frequencies 15 Hz 
% and 40 Hz. The signals are sampled at 100 Hz for one second.
fs = 1000;
t = 0:1/fs:1-1/fs;
x = sin(2*pi*15*t + 250/pi*180);
x2 = sin(2*pi*15*t + 289*pi/180);

% % Plot sine curves
% figure;
% hold on
% plot(t,x)
% plot(t,x2)
% xlabel 'time'
% ylabel 'x'
% axis([0 0.2 -1 1])
% hold off


% Compute the discrete Fourier transform of the signal. 
y = fft(x);
y2 = fft(x2);

% Compute the phase angles for the 15 Hz signals in each sinusoid and
% compute the phase difference.
phase1 = angle(y(16)); % index = freq * length(t) / fs
phase2 = angle(y2(16));
phaseDiff = phase2-phase1;
phaseDiffinPi = phaseDiff/pi;
phaseDiffinDeg = phaseDiff * 180/pi;

% Test plot "fit"
fit1 = 1.1*cos(2*pi*15*t + phase1);
fit2 = 1.1*cos(2*pi*15*t + phase2);

figure;
hold on
plot(t,x, 'g')
plot(t,x2, 'b')
plot(t, fit1, 'r')
plot(t, fit2, 'c')
xlabel 'time'
ylabel 'x'
axis([0 0.2 -1 1])
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

%% FFT Phase
% Generate a signal and compute its DFT. Specify a sample rate of 100 Hz. Find 
% the phase of the transform and plot it as a function of frequency.
% 
% 

% Copyright 2015 The MathWorks, Inc.


t = (0:99)/100;                        % Time vector
x = sin(2*pi*15*t) + sin(2*pi*40*t);   % Signal
y = fft(x);                            % Compute DFT of x
p = unwrap(angle(y));                  % Phase
f = (0:length(y)-1)/length(y)*100;     % Frequency vector
plot(f,p)
xlabel 'Frequency (Hz)'
ylabel 'Phase (rad)'

%% Another example from the web somewhere

Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*100*t-pi/4)+cos(2*pi*200*t-pi/2);
xdft = fft(x);
angle([xdft(101) xdft(201)]) 

% PHASE calculation
phs = (angle(xdft));
lxdft = length(xdft);
f_phase = (0:lxdft-1) * (Fs/lxdft);
f_phase = f_phase.';

figure;
hold on
plot(f_phase, phs/pi)
xlabel('f (Hz)')
ylabel('Phase / \pi')
grid
xlim([0, 400])
% ylim([-2, 2])
hold off