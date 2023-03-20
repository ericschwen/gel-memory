%% Drift testing
%
% Takes input from shift field created by matPIV. Sums the individual
% shifts to get position over time. Trims off zeros if necessary. Fits the
% resulting curve to find amplitude of the displacement.
%
% Mod History:
% v2: adjust for 3/4 cycle ampsweep data (setting curve zero, etc)
% v3: set automatic cutoffs for start and finish. Converted to function in
% strain_amp_calc_pcycle
% v4: Use nonlinear least squares fit with custom function. Comment out 3/4
% cycle stuff. 6-20-19

%% Import data
window = '32x512';
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-3-18 data\0.6V\xy-ts-pre';
folder = 'C:\Eric\Xerox Data\voltage testing\6-18-19 voltage\0.5Vy';
strainPathX = [folder '_drift_' window '\v_fieldX.csv'];
shift_x = xlsread(strainPathX);
% access as shiftX(tframe, zframe). (The tframe is calculated by
% transition number. tframe 1 is between 1st and 2nd image, etc.)
strainPathY = [folder '_drift_' window '\v_fieldY.csv'];
shift_y = xlsread(strainPathY);

time_path = [folder '_drift_' window '\timestamps.csv'];
timesteps = xlsread(time_path);

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% % Lazy cheat way to look at y instead of x
shift_x = shift_y;
% %%%%%%%%%%%%%%%%


% % Plot shift vs time
% figure;
% plot(timesteps(2:end), shift_x ,'b:o');
% title('Shift vs time');
% xlabel('Time (s)');
% ylabel('Shift (pixels)');
% % axis([0 max(timesteps) -5 5]);

% Calculate total shift
displacement_x = zeros(length(shift_x),1);
displacement_x(1) = shift_x(1);
for i = 2:length(shift_x)
    displacement_x(i) = shift_x(i) + displacement_x(i-1);
end

% figure;
% plot(timesteps(2:end), displacement_x ,'b:o');
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% xlim([0 max(timesteps)])
% % axis([0 max(timesteps) -2 2]);

% trim shift sum to just curve. Default to 1 and 0 for no trimming.
trim1 = 1;
trim2 = 50;
displacement_x_trimmed = displacement_x(trim1:end-trim2);
timesteps_trimmed = timesteps(trim1 + 1: end-trim2);

figure;
plot(timesteps_trimmed, displacement_x_trimmed ,'b:o');
title('Position vs time');
xlabel('Time (s)');
ylabel('x-position (pixels)');
xlim([0 max(timesteps)])

%% Fit trimmed displacement curve to custom sine curve.

% % Set estimates
% b_0 = mean(displacement_x_trimmed); % offset estimate
% a_0 = max(displacement_x_trimmed); % amplitude estimate
% f_0 = 0.3333; % frequency estimate
% s_0 = 0; % theta shift estimate
% vars_0 = [a_0 f_0 s_0 b_0];
% 
% % Set bounds
% lb = [-300 0.3 -2*pi -300];
% ub = [300 0.4 2*pi 300];
% 
% % Define fit for sine curve with offset
% myfittype = fittype('a*sin(2*pi*f*t - s)+b', 'dependent', {'y'},'independent', {'t'},...
%     'coefficients', {'a','f', 's', 'b'});

% Set estimates
b_0 = mean(displacement_x_trimmed); % offset estimate
a_0 = max(displacement_x_trimmed); % amplitude estimate
f_0 = 0.3333; % frequency estimate
s_0 = 0; % theta shift estimate
m_0 = 0; % slope estimate
vars_0 = [a_0 f_0 s_0 m_0 b_0];

% Set bounds
lb = [-400 0.3 -2*pi -50 -300];
ub = [400 0.4 2*pi 50 300];

% Define fit for sine curve with linear shift
myfittype = fittype('a*sin(2*pi*f*t - s)+m*t+b', 'dependent', {'y'},'independent', {'t'},...
    'coefficients', {'a','f', 's', 'm', 'b'});

% Run fitting for piezo_x
myfit_x = fit(timesteps_trimmed, displacement_x_trimmed, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
fit_coeffs_x = coeffvalues(myfit_x);
conf_ints_x = confint(myfit_x);

% % Manually designate points from fit (for plotting)
% fit_points_x = fit_coeffs_x(1) * sin(2*pi*fit_coeffs_x(2) * timesteps_trimmed - fit_coeffs_x(3)) + ...
%     fit_coeffs_x(4);

% Manually designate points from fit (for plotting)
fit_points_x = fit_coeffs_x(1) * sin(2*pi*fit_coeffs_x(2) * timesteps_trimmed - fit_coeffs_x(3)) + ...
    fit_coeffs_x(4)* timesteps_trimmed + fit_coeffs_x(5);

figure;
hold on
plot(timesteps_trimmed, displacement_x_trimmed, 'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 10)
plot(timesteps_trimmed, fit_points_x, 'r', 'LineWidth', 2)
xlabel('Time','FontSize', 18);
ylabel('Displacement (px)','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off

myfit_x
amp_um = fit_coeffs_x(1) * .127


% % SECTION: for 3/4 cycle trimming
% % trim shift sum to just curve
% % 
% % Automatic trim settings
% base_pos = mean(shift_sum_x(1:30));
% zero_frame = 180;
% zero_pos = mean(shift_sum_x(zero_frame:length(shift_sum_x)));
% buffer_px = 2;
% 
% % find first trim cutoff. Could probably use while loop
% for i = 1:length(shift_sum_x)
%     if shift_sum_x(i) > base_pos + buffer_px
%         start_cut = i;
%         break
%     end
% end
% 
% for i = length(shift_sum_x):-1:1
%     if shift_sum_x(i) > zero_pos + buffer_px
%         last_cut = i;
%         break
%     end
% end
% 
% start = start_cut;
% fin = last_cut;
% 
% shift_sum_x_trimmed = shift_sum_x(start: fin);
% timesteps_trimmed = timesteps(1+start: fin+1);
% 
% figure;
% hold on
% plot(timesteps(2:end), shift_sum_x,'b:o');
% plot(timesteps_trimmed, shift_sum_x_trimmed ,'r:o');
% title('Position vs time');
% xlabel('Time (s)');
% ylabel('x-position (pixels)');
% xlim([0 max(timesteps)])
hold off