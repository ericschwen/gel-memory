%% Strain plotting
%
% Mod History:
% v2: adjust for 3/4 cycle ampsweep data (setting curve zero, etc)

%% Import data
window = '512x32';
freq = 0.3333;
folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep\0.8\xy_ts';
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
% trim1 = 105;
% trim2 = 500;
% shift_sum_x_trimmed = shift_sum_x(trim1:end-trim2);
% timesteps_trimmed = timesteps(trim1 + 1: end-trim2);

% Manually find curve part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start = 75;
fin = 155;
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

% MANUALLY choose where zero part starts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zero_frame = 180;
zero_position = mean(shift_sum_x(zero_frame:length(shift_sum_x)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit with frequency restricted to reasonable range
shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed - zero_position;
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
plot(timesteps(2:end), shift_sum_x - zero_position ,'b:o');
plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'r:o');
plot(sine_fit_zeroed, 'g')
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
hold off

sine_fit_zeroed
coeffs = coeffvalues(sine_fit_zeroed);
amp_um = coeffs(1)*0.127

% other basic calculation of amplitude: minimum to zero
px_dif = zero_position - mean(shift_sum_x(1:30))

% % fit with restricted frequency
% freq = 0.3333;
% fit_restrict = fit(timesteps_trimmed, shift_sum_x_trimmed_zeroed, 'sin1',...
%     'Lower',[-Inf, 2*pi*freq*0.9, -Inf],...
%     'Upper', [Inf, 2*pi*freq*1.1, Inf]);
% 
% figure;
% hold on
% plot(timesteps(2:end), shift_sum_x - zero_position ,'b:o');
% plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'r:o');
% plot(sine_fit_zeroed, 'g')
% plot(fit_restrict, 'c')
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% hold off

% %% Subtract overall drift and then fit curve
% 
% % linear
% poly1_fit = fit(timesteps_trimmed, shift_sum_x_trimmed, 'poly1');
% 
% co_poly1 = coeffvalues(poly1_fit);
% 
% % subtract polynomial fit from drift
% shift_sum_x_noDrift = zeros(length(shift_sum_x_trimmed), 1);
% for i = 1:length(shift_sum_x_trimmed)
%     shift_sum_x_noDrift(i) = shift_sum_x_trimmed(i) - (co_poly1(1) * timesteps_trimmed(i) + co_poly1(2));
% end
% 
% sin1_fit = fit(timesteps_trimmed, shift_sum_x_noDrift, 'sin1');
% 
% figure;
% hold on
% plot(timesteps_trimmed, shift_sum_x_noDrift, 'b:o')
% plot(sin1_fit)
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% hold off
% 
% sin1_fit
% co_sin1 = coeffvalues(sin1_fit);
% amp_um = co_sin1(1)*0.125

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-axis verison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Plot shift vs time
% figure;
% plot(timesteps(2:end), shift_y ,'b:o');
% title('Shift vs time');
% xlabel('Time (s)');
% ylabel('Shift (pixels)');
% axis([0 max(timesteps) -5 5]);
% 
% % Calculate total shift
% shift_sum_y = zeros(length(shift_y),1);
% shift_sum_y(1) = shift_y(1);
% for i = 2:length(shift_y)
%     shift_sum_y(i) = shift_y(i) + shift_sum_y(i-1);
% end
% 
% figure;
% plot(timesteps(2:end), shift_sum_y ,'b:o');
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% xlim([0 max(timesteps)])
% % axis([0 max(timesteps) -2 2]);
% 
% %% trim shift sum to just curve
% trim1 = 105;
% trim2 = 500;
% shift_sum_y_trimmed = shift_sum_y(trim1:end-trim2);
% timesteps_trimmed = timesteps(trim1 + 1: end-trim2);
% 
% figure;
% plot(timesteps_trimmed, shift_sum_y_trimmed ,'b:o');
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% xlim([0 max(timesteps)])
% 
% %% fit trimmed curve
% 
% shift_sum_y_trimmed_zeroed = shift_sum_y_trimmed - mean(shift_sum_y_trimmed);
% sine_fit_zeroed = fit(timesteps_trimmed, shift_sum_y_trimmed_zeroed, 'sin1');
% 
% figure;
% hold on
% plot(timesteps_trimmed, shift_sum_y_trimmed_zeroed ,'b:o');
% plot(sine_fit_zeroed, 'g')
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% hold off
% 
% sine_fit_zeroed
% coeffs = coeffvalues(sine_fit_zeroed);
% amp_um = coeffs(1)*0.125
% % xlim([0 max(timesteps)])
