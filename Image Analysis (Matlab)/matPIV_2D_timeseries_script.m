%% MatPIV 2D timeseries
%
% Import tifs (that were exported from lsm by zen) and run matPIV


% folder_base = 'C:\Eric\Xerox Data\7-30-17 shift testing\xy ts cycles\';
% volts = {'3.0V', '4.2V', '5.8V'};

folder_base = 'C:\Eric\Xerox Data\strain calibration 2-26-17\slightly higher (better pictue)\';
volts = {'1V'};
% volts = {'2V', '7V'};
% volts = {'1V', '3V', '5V', '7V', '9V'};

% folder_base = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p0\xy_ts';
% volts = {''};

window = '512x32';

for i = 1:length(volts)
    folder = [folder_base volts{i}];
    % run matPIV 2D
%     folder = 'C:\Eric\Xerox Data\7-30-17 shift testing\xy ts
%     cycles\1.8V';o

    [params, paths] = lsm_parallel_import_2D_v1(folder);

    drift_matPIV_2D_v2(params, paths, folder);


    % save timestamps

    folderParts = strsplit(folder, '\');
    parent = strjoin(folderParts(1:end-1), '\');
    filename = [parent, '\', folderParts{end}, '.lsm'];

    timestamps = lsmINF_timestamps_v1(filename);

    time_path = [folder '_drift_' window '\timestamps.csv'];
    csvwrite(time_path, timestamps);
end