%% MatPIV 2D timeseries
%
% Import tifs (that were exported from lsm by zen) and run matPIV
% Mod Hist:
% v2: for xy-ts in ampsweeps


% folder_base = 'C:\Eric\Xerox Data\7-30-17 shift testing\xy ts cycles\';
% volts = {'3.0V', '4.2V', '5.8V'};

% folder_base = 'C:\Eric\Xerox Data\strain calibration 2-26-17\slightly higher (better pictue)\';
% volts = {'1V'};
% volts = {'2V', '7V'};
% volts = {'1V', '3V', '5V', '7V', '9V'};

% root_folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\';
% subfolders = {'p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};

% SHEAR BAND TEST VERSION
root_folder = 'C:\Eric\Xerox Data\30um gap runs\6-3-18 data\';
subfolders = {'0.6V\xy-ts-pre', '0.6V\xy-ts-post', '0.4V\xy-ts-pre', '0.4V\xy-ts-post', '0.8V\xy-ts-pre', '0.8V\xy-ts-post',...
    '0.5V\xy-ts-pre', '0.5V\xy-ts-post', '1.0V\xy-ts-pre', '1.0V\xy-ts-post'};

% root_folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained delayed\ampsweep\';
% % Read all file names from folder
% files_dir = dir(root_folder);
% subfolders = cell(length(files_dir)-2, 1);z
% for i = 3:length(files_dir)
%     subfolders{i-2} = files_dir(i).name;
% end


window = '512x32';

for i = 1:length(subfolders)
    
    % Name folder: PAUESE OR AMPSWEEP
%     folder = [root_folder, subfolders{i}, '\xy_ts'];
    
    % Name folder: shear band test
    folder = [root_folder, subfolders{i}];


    % run matPIV 2D

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