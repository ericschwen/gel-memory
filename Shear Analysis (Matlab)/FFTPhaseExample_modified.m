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
%% Plotting fft
L = length(x);
Fs = 100; % sampling frequency

% Two sided spectrum P2
P2 = abs(y/L);
% Compute single sided spectrum P1 based on P2 and even-valued signal of
% length L.
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Frequencies for plotting (frequency vector)
F = Fs*(0:(L/2))/L;
plot(F,P1)
xlabel 'Frequency (Hz)'
ylabel 'fft'