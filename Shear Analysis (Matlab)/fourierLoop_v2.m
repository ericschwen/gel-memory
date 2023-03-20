function [amps, indices, freqs, phases] = fourierLoop_v1(signal, Freq, Spp, CycleInterval)

%% FOURIER TRANSFORM LOOP
% Use repeated fourier transforms to different sections to find the
% amplitude of the strain at different points in time.
% spp = Samples per period
% Modification history:
% v2: change the time interval stuff to cycle interval

% Set time interval for transform for each step in loop
% MAKE SURE timeInterval * freq IS AN INTEGER

cycleInterval = CycleInterval; % number of cycles per interval
freq = Freq;
spp = Spp;
fs = freq*spp;

LCut = cycleInterval * spp; % i think rounding to integer works?
% number of steps in loop
steps = length(1:LCut:(length(signal)-LCut));

% Save results to arrays
amps = 1:1:steps;
indices = 1:1:steps;
freqs = 1:1:steps;
phases = 1:1:steps;

for i = 1:1:steps
    startIndex = LCut * (i-1) + 1;
    lastIndex = startIndex + LCut - 1;
    stressCut = signal(startIndex:lastIndex);
%     tcut = 1/fs * (startIndex:1:lastIndex);
    
    ycut = fft(stressCut);
    
%     freqIndex = freq * length(tcut)/fs+1;
    freqIndex = LCut/spp+1;
    phases(i) = angle(ycut(uint32(freqIndex)));
    
    P2Cut = abs(ycut/double(LCut));
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
    [amps(i), indices(i)] = max(P1Cut(index1:index2));

    freqs(i) = fCut(indices(i) + index1 - 1);    
    
%     % Optional print one figure of a single fourier section
%     if i == 3
%         figure;
%         plot(fCut, P1Cut);
%         xlim([0.05, 1.5])
%         title('Single-Sided Amplitude Spectrum of V(t)')
%         xlabel('Frequency (Hz)')
%         ylabel('|V(f)|')
%     end
    
end
end