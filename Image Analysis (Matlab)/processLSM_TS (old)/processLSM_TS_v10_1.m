% folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1V 0.5Hz 12-7-16\';
% fileList = {'ts1.lsm', 'ts2.lsm', 'ts3.lsm'};


rootFolder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-16\1.0V (2)\';
subFolderList = {'ampsweep_pre_train', 'ampsweep_post_train', 'training'};

for i = 1:1:length(subFolderList)
    folderPath = [rootFolder, subFolderList{i}];
    
    % import image from tiffs and make hyperstack
    [parameters, image4D] = lsm_parallel_import_v1(folderPath);
    fprintf('%s%s\n', 'import done: ', subFolderList{i});
    
    % Band Pass filter
    lsmTS_BPfilter_v9(image4D, parameters, folderPath);
    fprintf('%s%s\n', 'BP done: ', subFolderList{i});

    % Otsu filter
    tifstack_otsuFilter_v3(folderPath, parameters);
    fprintf('%s%s\n', 'otsuFilter done: ', subFolderList{i});

    % Get image difference data
    imageDiff_v4(folderPath, parameters);
    fprintf('%s%s\n', 'otsu imdiff done: ', subFolderList{i});

end

%%%%%%%%%%%%%
% May need to modify parallel_import if 6gb file is too big for matlab to
% store in the workspace

% should modify BP filter, etc to save to main folder rather than to folder
% full of individual files. Easy fix.

% Maybe implement parallel processing for bp filtering and otsu filtering?
% Might run into memory restrictions though if i try to store all of those
% at once.