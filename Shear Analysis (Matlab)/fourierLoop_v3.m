function [amps, indices, freqs, phases] = fourierLoop_v3(signal, Freq, Fs, TimeInterval)

%% FOURIER TRANSFORM LOOP
% Use repeated fourier transforms to different sections to find the
% amplitude of the strain at different points in time.
% spp = Samples per period

% Modification history:
% v2: change the time interval stuff to cycle interval
% v3: revert to v1. then try padding input array (with zeros or repeating 
%     inputs) to reduce noise

% Set time interval for transform for each step in loop
% MAKE SURE timeInterval * freq IS AN INTEGER
timeInterval = TimeInterval; % Time interval in seconds
freq = Freq;
fs = Fs;

LCut = uint32(timeInterval * fs); % i think rounding to integer works?
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
    tcut = 1/fs * (startIndex:1:lastIndex);
    
    % padded cuts repeat stress data
    data_loops = 5; % number of times stress data is looped
    padded_stressCut = [stressCut;, stressCut; stressCut; stressCut; stressCut];
    padded_tcut = 1/fs * (startIndex:1:(lastIndex * data_loops));
    padded_LCut = LCut * data_loops;
    
    ycut = fft(padded_stressCut);
    
    freqIndex = freq * length(padded_tcut)/fs+1;
    phases(i) = angle(ycut(uint32(freqIndex)));
    
    P2Cut = abs(ycut/double(padded_LCut));
    % Compute single sided spectrum P1 based on P2 and even-valued signal of
    % length L.
    P1Cut = P2Cut(1:padded_LCut/2+1);
    P1Cut(2:end-1) = 2*P1Cut(2:end-1);
    
    padded_LCut = double(padded_LCut);
    % Frequencies for plotting
    fCut = fs*(0:(padded_LCut/2))/padded_LCut;
    
    % Get amplitude of peak and freqency where it occurs
    f1 = 0.1;
    f2 = 1.5;
    index1 = uint32(f1 * padded_LCut / fs +1); % get index in frequency vector
    index2 = uint32(f2 * padded_LCut / fs +1);
    [amps(i), indices(i)] = max(P1Cut(index1:index2));

    freqs(i) = fCut(indices(i) + index1 - 1);    
    
    % Optional print one figure of a single fourier section
    if i == 1
        figure;
        plot(fCut, P1Cut);
        xlim([0.05, 1.5])
        ylim([0, 0.025])
        title('Single-Sided Amplitude Spectrum of V(t)')
        xlabel('Frequency (Hz)')
        ylabel('|V(f)|')
    end
    
    % Optional print one figure of a single fourier section
    if i == 1
        figure;
        plot(tcut, stressCut);
        % xlim([0, 15])
        title('Stress vs. time)')
        xlabel('Time')
        ylabel('Stress')
    end
    
    % Optional print one figure of a single fourier section
    if i == 1
        figure;
        plot(padded_tcut, padded_stressCut);
        % xlim([15, 30])
        title('Stress vs. time)')
        xlabel('Time')
        ylabel('Stress')
    end
    
end
end