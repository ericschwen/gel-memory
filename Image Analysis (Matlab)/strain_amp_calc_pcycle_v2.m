function [amp_um, amp_px, max_to_zero, min_to_zero] = strain_amp_calc_pcycle_v2(folder, freq)

% Calculates amplitude in um and px for curve of points generated by
% matPIV. Takes folder of tif files and frequency of oscillation as inputs.
%
% Mod History:
% v2: no plotting (commented out)

% sample data inputs
% freq = 0.3333;
% folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\xy_ts';

% Import data
window = '512x32';
strainPathX = [folder '_drift_' window '\v_fieldX.csv'];
shift_x = xlsread(strainPathX);

% % include y path if you want
% strainPathY = [folder '_drift_' window '\v_fieldY.csv'];
% shift_y = xlsread(strainPathY);

time_path = [folder '_drift_' window '\timestamps.csv'];
timesteps = xlsread(time_path);


% Calculate total shift
shift_sum_x = zeros(length(shift_x),1);
shift_sum_x(1) = shift_x(1);
for i = 2:length(shift_x)
    shift_sum_x(i) = shift_x(i) + shift_sum_x(i-1);
end

%% trim shift sum to just curve

% Automatic trim settings
base_pos = mean(shift_sum_x(1:30));
zero_frame = 180;
zero_pos = mean(shift_sum_x(zero_frame:length(shift_sum_x)));
buffer_px = (zero_pos - base_pos)/5;

% find first trim cutoff. Could probably use while loop.
% use double the buffer for lower part.
for i = 1:length(shift_sum_x)
    if shift_sum_x(i) > base_pos + 2* buffer_px
        start_cut = i;
        break
    end
end

for i = length(shift_sum_x):-1:1
    if shift_sum_x(i) > zero_pos + buffer_px
        last_cut = i;
        break
    end
end


shift_sum_x_trimmed = shift_sum_x(start_cut: last_cut);
timesteps_trimmed = timesteps(1+start_cut: last_cut+1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit with frequency restricted to reasonable range
shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed - zero_pos;
sine_fit_zeroed = fit(timesteps_trimmed, shift_sum_x_trimmed_zeroed, 'sin1',...
    'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
    'Upper', [Inf, 2*pi*freq*1.1, Inf]);


% figure;
% hold on
% plot(timesteps(2:end), shift_sum_x - zero_pos ,'b:o');
% plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'r:o');
% plot(sine_fit_zeroed, 'g')
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% hold off

sine_fit_zeroed;
coeffs = coeffvalues(sine_fit_zeroed);
amp_px = coeffs(1);
amp_um = coeffs(1)*0.127;

% other basic calculation of amplitude: minimum to zero and zero to max
min_to_zero = zero_pos - mean(shift_sum_x(1:30));
max_to_zero = max(shift_sum_x) - zero_pos;

end
