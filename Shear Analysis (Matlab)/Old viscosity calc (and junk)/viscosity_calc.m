%%%%%%%%%%%%%%%%%
filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
    '10 hz x-axis\a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '1 hz x-axis\a1_5.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '2 hz x-axis\a1_5.0000_a2_0.0000_f1_2.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '1 hz y-axis\a1_5.0000_a2_0.0000_f1_1.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '2 hz y-axis\a1_5.0000_a2_0.0000_f1_2.0000_f2_1.0000_p_00.txt'];

% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '10 hz y-axis\a1_2.3208_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];
% 
% filename = ['C:\Users\Eric\Documents\Xerox\Glycerol-Water Shear\'...
%     '10 hz y-axis\a1_5.0000_a2_0.0000_f1_10.0000_f2_1.0000_p_00.txt'];

% Frequency and samples per period
freq = 10;
spp = 1000;
% Sampling frequency and time
Fs = (freq * spp);
T = 1/Fs;

% Import shear data file
M = dlmread(filename);

% Columns of M: Piezo X, Piezo Y, Shear X, Shear Y
M1 = M(:, 1); % Piezo X (proportional to strain)
M2 = M(:, 2); % Signal X (proportional to stress)
M3 = M(:, 3); % Piezo Y
M4 = M(:, 4); % Signal Y

% Piezo conversion: 1 V = 25 um displacement.
% Gap = 16.7 um for 6/8/16 run
% strain = displacement / gap
strain = M1 * 25 / 16.7;

% strain rate = strain * 2 * pi * freqency
strainRate = 2 * pi * freq * strain;

%Timesteps
time = 1/(freq * spp) * (0:1:size(M1)-1);
time = time.';
% length of signal
L = size(M1);


% Works better to subtract the mean (center at y = 0)
M1_0 = M1 - mean(M1);
M2_0 = M2 - mean(M2);


% Fourier transform of signal to get principal components
% 2 * Absolute value of it
V = 2 * abs(fft(M2)) / L(1);  % Possibly divide by length spp
f = Fs * linspace(0,1, L(1));

plot(f,V); 
xlim([0, 20])
title('Single-Sided Amplitude Spectrum of V(t)')
xlabel('Frequency (Hz)')
ylabel('|V(f)|')

amp1 = max(V)

% %%%%%%% Copying documentation for fft %%%%%%%
% NFFT = 2^nextpow2(L(1)); % Next power of 2 from length of y
% Y = fft(M2_0,NFFT)/L(1);
% f = Fs/2*linspace(0,1,NFFT/2+1);
% 
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% xlim([0, 20])
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

% amp = max(2*abs(Y));







