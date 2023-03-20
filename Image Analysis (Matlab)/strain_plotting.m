%% Drift testing

%% Import data
window = '512x32';
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-3-18 data\0.6V\xy-ts-pre';
folder = 'C:\Eric\Xerox Data\voltage testing\6-18-19 voltage\2Vx';
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

figure;
plot(timesteps(2:end), shift_sum_x ,'b:o');
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
xlim([0 max(timesteps)])
% axis([0 max(timesteps) -2 2]);

% figure;
% plot(1:length(shift_sum_x), shift_sum_x ,'b:o');
% title('Position vs time');
% xlabel('Frame');
% ylabel('x-position (pixels)');
% xlim([0 length(shift_sum_x)])
% % axis([0 max(timesteps) -2 2]);

%% trim shift sum to just curve
trim1 = 1;
trim2 = 0;
shift_sum_x_trimmed = shift_sum_x(trim1:end-trim2);
timesteps_trimmed = timesteps(trim1 + 1: end-trim2);

% start = 60;
% fin = 140;
% shift_sum_x_trimmed = shift_sum_x(start: fin);
% timesteps_trimmed = timesteps(1+start: fin+1);

figure;
plot(timesteps_trimmed, shift_sum_x_trimmed ,'b:o');
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
xlim([0 max(timesteps)])


%% fit trimmed curve with no subtracted slope

% note: this just subtracts the mean to set the zero point. Doesn't work
% well for small numbers of oscillations. May have to adjust manually or
% fix something else.

% amp_estimate and auto_shift make sure center of curve is at zero.
%%%%%%%%%%%%%%%%%%%% MANUAL SHIFT ADDED %%%%%%%%%%%%%%%%%%%%%%%%%%%%
man_shift = 5;
amp_estimate = (max(shift_sum_x_trimmed) - min (shift_sum_x_trimmed))/2;
auto_shift = amp_estimate - max(shift_sum_x_trimmed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed + auto_shift;
% shift_sum_x_trimmed_zeroed = shift_sum_x_trimmed - mean(shift_sum_x_trimmed) + man_shift;
sine_fit_zeroed = fit(timesteps_trimmed, shift_sum_x_trimmed_zeroed, 'sin1');

figure;
hold on
plot(timesteps_trimmed, shift_sum_x_trimmed_zeroed ,'b:o');
plot(sine_fit_zeroed, 'g')
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
hold off

sine_fit_zeroed
coeffs = coeffvalues(sine_fit_zeroed);
amp_um = coeffs(1)*0.127


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
