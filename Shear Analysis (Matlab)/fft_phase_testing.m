%% Example from FFT Phase on mathworks

% Generate a signal that consists of two sinusoids of frequencies 15 Hz 
% and 40 Hz. The signal is sampled at 100 Hz for one second.
fs = 100;
t = 0:1/fs:1-1/fs;
x = sin(2*pi*15*t) + sin(2*pi*40*t);

% Compute the discrete Fourier transform of the signal. Plot the magnitude
% of the transform as a function of frequency.
y = fft(x);

ly = length(y);
f = (-ly/2:ly/2-1)/ly*fs;

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