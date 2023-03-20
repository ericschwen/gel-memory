
% Import and plot data from drift in glass zstacks over time. Uses the
% data saved by matPIV_glass_script and matPIV_2stacks.
% 9-22-21
% Author: Eric
% Mod History:
%   v2: Add in data smoothing. 9-24-21

folder = 'E:\Gardner Data\glass 11-17-20\ts-4-stacked\';
% folder = 'E:\Gardner Data\piezo 2-25-20\ts-post-2-stacked\';
% folder = 'E:\Gardner Data\piezo 2-13-20\2-14-20 testing\ts-post-2-stacked-translated\';

% Parameters to use during import
windows_in_filename = 1;
winx = 256;
winy = 64;
% zsiz = 100;


% Make cell array of filepaths. NOTE: digits in sprintf set to 3 currently.
start = 1;
finish = 120;
filepaths = cell(length(start:finish),1);
for i=start:finish
    filename = ['t', sprintf('%.3d', i), '.tif'];
    filepaths{i} = [folder, filename];
end

dx = zeros(length(filepaths)-1,1);
dy = zeros(length(filepaths)-1,1);

for i = 1:(length(filepaths)-1)
    if windows_in_filename
        % With windows in filename
        dx(i) = mean(csvread(join([filepaths{i}(1:end-4), '_v_fieldX1_' string(winx), '_', string(winy), '.csv'],'')));
        dy(i) = mean(csvread(join([filepaths{i}(1:end-4), '_v_fieldY1_' string(winx), '_', string(winy), '.csv'],'')));
    else
        % Default version without windows in filename
        dx(i) = mean(csvread([filepaths{i}(1:end-4), '_v_fieldX1.csv']));
        dy(i) = mean(csvread([filepaths{i}(1:end-4), '_v_fieldY1.csv']));
    end
end

% Plot shift for each frame
figure;
hold on
plot(1:length(filepaths)-1, .125*dx,'b:o', 'DisplayName', 'dx');
plot(1:length(filepaths)-1, .125*dy,'r:o', 'DisplayName', 'dy');
title('Shift vs file');
xlabel('file');
ylabel('Shift (um)');
leg = legend('Location', 'northeast');
set(leg, 'FontSize', 14)
% axis([0 length(filepaths) -1 1]);

% Calculate total shift
shift_sum_x = zeros(length(dx),1);
shift_sum_x(1) = dx(1);
shift_sum_y = zeros(length(dy),1);
shift_sum_y(1) = dy(1);
for i = 2:length(dx)
    shift_sum_x(i) = dx(i) + shift_sum_x(i-1);
    shift_sum_y(i) = dy(i) + shift_sum_y(i-1);
end

% Linear fit for shift
time = ((1:length(shift_sum_x))*.5).';
% backslash is linear regression (matlab syntax)
x1 = time\shift_sum_x;
y1 = time\shift_sum_y;
% Matlab fit function instead. Set bounds to 0 for y-intercept. This is
% mostly just a check for the linear regression.
fx = fit(time, shift_sum_x, 'poly1', 'Lower', [-Inf, -0.000001], 'Upper', [Inf, 0.000001]);

% Moving average smoothing (instead of linear fit)
ma_x = smoothdata(shift_sum_x, 'movmean', 5, 'omitnan');

% Plot total shift
figure;
hold on
plot((1:length(shift_sum_x))*.5, shift_sum_x*.125,'b:o', 'DisplayName', 'dx');
plot((1:length(shift_sum_y))*.5, shift_sum_y*.125,'r:o', 'DisplayName', 'dy');
plot(time, time * x1 * .125,'b', 'DisplayName', 'xfit');
plot(time, time * y1 * .125,'r', 'DisplayName', 'yfit');
plot(time, ma_x*.125, 'g', 'DisplayName', 'MA x')
% plot(fx, time, shift_sum_x)
title('Total Shift vs time');
xlabel('Time (s)');
ylabel('Shift (um)');
leg = legend('Location', 'southeast');
set(leg, 'FontSize', 14)