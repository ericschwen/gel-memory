%% Strain plotting
%
% Mod History:
% v2: adjust for 3/4 cycle ampsweep data (setting curve zero, etc)
% v3: set automatic cutoffs for start and finish. Converted to function in
% strain_amp_calc_pcycle

%% Import data
window = '512x32';
freq = 0.3333;
% folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep\0.8\xy_ts';
folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p400\xy_ts';
strainPathX = [folder '_drift_' window '\v_fieldX.csv'];
shift_x = xlsread(strainPathX);
% access as shiftX(tframe, zframe). (The tframe is calculated by
% transition number. tframe 1 is between 1st and 2nd image, etc.)
strainPathY = [folder '_drift_' window '\v_fieldY.csv'];
shift_y = xlsread(strainPathY);

time_path = [folder '_drift_' window '\timestamps.csv'];
timesteps = xlsread(time_path);


% Plot shift vs time
figure;
plot(timesteps(2:end), shift_x ,'b:o');
title('Shift vs time');
xlabel('Time (s)');
ylabel('Shift (pixels)');
% axis([0 max(timesteps) -5 5]);

% Calculate total shift
shift_sum_x = zeros(length(shift_x),1);
shift_sum_x(1) = shift_x(1);
for i = 2:length(shift_x)
    shift_sum_x(i) = shift_x(i) + shift_sum_x(i-1);
end

% figure;
% plot(timesteps(2:end), shift_sum_x ,'b:o');
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% xlim([0 max(timesteps)])
% % axis([0 max(timesteps) -2 2]);

% figure;
% plot(1:length(shift_sum_x), shift_sum_x ,'b:o');
% title('Position vs time');
% xlabel('Frame');
% ylabel('x-position (pixels)');
% xlim([0 length(shift_sum_x)])
% % axis([0 max(timesteps) -2 2]);

%% trim shift sum to just curve

% Automatic trim settings
base_pos = mean(shift_sum_x(1:30));
zero_frame = 180;
zero_pos = mean(shift_sum_x(zero_frame:length(shift_sum_x)));
buffer_px = 2;

% find first trim cutoff. Could probably use while loop
for i = 1:length(shift_sum_x)
    if shift_sum_x(i) > base_pos + buffer_px
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


% trim1 = 105;
% trim2 = 500;
% shift_sum_x_trimmed = shift_sum_x(trim1:end-trim2);
% timesteps_trimmed = timesteps(trim1 + 1: end-trim2);

% Manually find curve part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = start_cut;
fin = last_cut;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shift_sum_x_trimmed = shift_sum_x(start: fin);
timesteps_trimmed = timesteps(1+start: fin+1);

figure;
hold on
plot(timesteps(2:end), shift_sum_x,'b:o');
plot(timesteps_trimmed, shift_sum_x_trimmed ,'r:o');
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
xlim([0 max(timesteps)])
hold off

%%%%
% fit trimmed curve with no subtracted slope

% % version where you just subtract the mean (works for many cycles)
% shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed - mean(shift_sum_x_trimmed);
% sine_fit_zeroed = fit(timesteps_trimmed, shift_sum_x_trimmed_zeroed, 'sin1');

% subtract mean of end of curve (should be zero for shear cycle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit with frequency restricted to reasonable range
shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed - zero_pos;
sine_fit_zeroed = fit(timesteps_trimmed, shift_sum_x_trimmed_zeroed, 'sin1',...
    'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
    'Upper', [Inf, 2*pi*freq*1.1, Inf]);

% figure;
% hold on
% plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'b:o');
% plot(sine_fit_zeroed, 'g')
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% hold off


figure;
hold on
plot(timesteps(2:end), shift_sum_x - zero_pos ,'b:o');
plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'r:o');
plot(sine_fit_zeroed, 'g')
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
hold off

sine_fit_zeroed
coeffs = coeffvalues(sine_fit_zeroed);
amp_um = coeffs(1)*0.127

% other basic calculation of amplitude: minimum to zero and zero to max
px_dif = zero_pos - mean(shift_sum_x(1:30))
px_dif2 = max(shift_sum_x) - zero_pos
