% folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1V 0.5Hz 12-7-16\';
% fileList = {'ts1.lsm', 'ts2.lsm', 'ts3.lsm'};


rootFolder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.3333Hz 4-11-17\';
subFolderList = {'1.4V\ampsweep_pre_train'};

for i = 1:1:length(subFolderList)
    folderPath = [rootFolder, subFolderList{i}];
    
    % import image from tiffs and make hyperstack
    [parameters, allPaths] = lsm_parallel_import_v3(folderPath);
    fprintf('%s%s\n', 'import done: ', subFolderList{i});
    
    % drift calculation
    drift_matPIV_v4(parameters, allPaths, folderPath);
    fprintf('%s%s\n', 'drift calc done: ', subFolderList{i});
    
%     % Band Pass filter
%     lsmTS_BPfilter_v12(parameters, allPaths, folderPath);
%     fprintf('%s%s\n', 'BP done: ', subFolderList{i});
% 
%     % Otsu filter
%     tifstack_otsuFilter_v4(parameters, allPaths, folderPath);
%     fprintf('%s%s\n', 'otsuFilter done: ', subFolderList{i});

%     % Get image difference data
%     imageDiff_v7(parameters, allPaths, folderPath);
%     fprintf('%s%s\n', 'otsu imdiff done: ', subFolderList{i});

end


%%
params = parameters;
all_paths = allPaths;
folder = folderPath;

%%%%%%%%%%%%%
% May need to modify parallel_import if 6gb file is too big for matlab to
% store in the workspace

% should modify BP filter, etc to save to main folder rather than to folder
% full of individual files. Easy fix.

% Maybe implement parallel processing for bp filtering and otsu filtering?
% Might run into memory restrictions though if i try to store all of those
% at once.

% Could do parallel processing if I save it each xy slice as a separate
% file

% Should clear image4D after the bp filter step to clear up memory.
% clear('image4D');

% Should clear parameters at end of each loop
% clear('parameters');

% Maybe save all_paths rather than full image for 