% plot_shear_voltage_v1
%
% Take analog voltage readings from shear cell piezo (from analog_data_save
% labview file output). Plot the voltage over time to calculate amplitude.
% This amplitude can then be compared to the specified one to get
% calibration.
%
% Eric Schwen
% 6-17-19

% import data and separate signals
folder = 'C:\Eric\Xerox Data\voltage testing\piezo voltage to um\';
file = 'a1_0.0000_a2_2.0000_f1_0.3333_f2_1.0000_p_00.txt';
freq = 0.3333; % signal frequency
spp = 1000; % samples per period
file_path = [folder, file];

full_data = dlmread(file_path);
piezo_x = full_data(:, 1); % Piezo X (proportional to strain)
stress_x = full_data(:, 2); % Signal X (proportional to stress in x direction)
piezo_y = full_data(:, 3); % Piezo Y
stress_y = full_data(:, 4); % Signal Y

index = 1:length(piezo_x);
index = index';
time = index/(freq*spp);

just_zeros = zeros(length(piezo_x));

% trim blank data from end
trim_start = 1;
% trim_end = 2000;
trim_end = length(piezo_x);
piezo_x_trimmed = piezo_x(trim_start:trim_end);
piezo_y_trimmed = piezo_y(trim_start:trim_end);

% set zero for the voltage
piezo_x_zeroed = piezo_x_trimmed - mean(piezo_x_trimmed);
piezo_y_zeroed = piezo_y_trimmed - mean(piezo_y_trimmed);

% % Test plot
% hold on
% plot(index(1:trim_start), piezo_x_zeroed, 'b:o')
% plot(index, just_zeros, 'r')
% xlabel('Index');
% ylabel('Voltage (V)');
% % axis([0 max(t) 0.03 0.15]);
% box on
% hold off

% Set estimates
b_0 = mean(piezo_x_zeroed); % offset estimate
a_0 = 3.0; % amplitude estimate
f_0 = 0.3333; % frequency estimate
s_0 = 0; % theta shift estimate
vars_0 = [a_0 f_0 s_0 b_0];

% Set bounds
lb = [-7 0.3 -2*pi -1];
ub = [7 0.4 2*pi 1];

% Define fit
myfittype = fittype('a*sin(2*pi*f*t - s)+b', 'dependent', {'y'},'independent', {'t'},...
    'coefficients', {'a','f', 's', 'b'});

% Run fitting for piezo_x
myfit_x = fit(time(trim_start:trim_end), piezo_x_zeroed, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
fit_coeffs_x = coeffvalues(myfit_x);
conf_ints_x = confint(myfit_x);
% Manually designate points from fit (for plotting)
fit_points_x = fit_coeffs_x(1) * sin(2*pi*fit_coeffs_x(2) * time(trim_start:trim_end) - fit_coeffs_x(3)) + fit_coeffs_x(4);

% Run fitting for piezo_y
myfit_y = fit(time(trim_start:trim_end), piezo_y_zeroed, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
fit_coeffs_y = coeffvalues(myfit_y);
conf_ints_y = confint(myfit_y);
% Manually designate points from fit (for plotting)
fit_points_y = fit_coeffs_y(1) * sin(2*pi*fit_coeffs_y(2) * time(trim_start:trim_end) - fit_coeffs_y(3)) + fit_coeffs_y(4);

figure;
hold on
plot(time(trim_start:trim_end), piezo_x_zeroed, 'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 10)
% plot(myfit_x, 'g.')
plot(time(trim_start:trim_end), fit_points_x, 'r', 'LineWidth', 2)
plot(time(trim_start:trim_end), piezo_y_zeroed, 'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 10)
% plot(myfit_x, 'g.')
plot(time(trim_start:trim_end), fit_points_y, 'm', 'LineWidth', 2)
xlabel('Time','FontSize', 18);
ylabel('Voltage (V)','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off

myfit_x
myfit_y



