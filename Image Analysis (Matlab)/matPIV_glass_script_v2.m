
% Calculate shift from glass zstacks over time.
% Modified from matPIV_ampsweep_script_v3
% 6-1-21
% Author: Eric
% Mod History:
%   v2: Swap to using matPIV_2stacks_v4 where the windows can be selected.

folder = 'E:\Gardner Data\glass 11-17-20\ts-4-stacked\';
% folder = 'E:\Gardner Data\piezo 2-25-20\ts-post-2-stacked\';
% folder = 'E:\Gardner Data\piezo 2-13-20\2-14-20 testing\ts-post-2-stacked-translated\';

zsiz = 100;
winx = 256;
winy = 32;

% Make cell array of filepaths. NOTE: digits in sprintf set to 3 currently.
start = 1;
finish = 120;
filepaths = cell(length(start:finish),1);
for i=start:finish
    filename = ['t', sprintf('%.3d', i), '.tif'];
    filepaths{i} = [folder, filename];
end

% Old, manually typing out filenames version
% filenames = {'t120.tif', 't121.tif', 't122.tif'};
% filepaths = cell(length(filenames),1);
% for i = 1:length(filenames)
%     filepaths{i} = [folder, filenames{i}];
% end

dx = zeros(length(filepaths)-1,1);
dy = zeros(length(filepaths)-1,1);

for i = 1:(length(filepaths)-1)
    [dx(i), dy(i)] = matPIV_2stacks_v4(filepaths{i}, filepaths{i+1}, zsiz, winx, winy);
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

% Plot total shift
figure;
hold on
plot((1:length(shift_sum_x))*.5, shift_sum_x*.125,'b:o', 'DisplayName', 'dx');
plot((1:length(shift_sum_y))*.5, shift_sum_y*.125,'r:o', 'DisplayName', 'dy');
plot(time, time * x1 * .125,'b', 'DisplayName', 'xfit');
plot(time, time * y1 * .125,'r', 'DisplayName', 'yfit');
% plot(fx, time, shift_sum_x)
title('Total Shift vs time');
xlabel('Time (s)');
ylabel('Shift (um)');
leg = legend('Location', 'southeast');
set(leg, 'FontSize', 14)