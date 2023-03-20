% folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1V 0.5Hz 12-7-16\';
% fileList = {'ts1.lsm', 'ts2.lsm', 'ts3.lsm'};


rootFolder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-16\1.0V (2)\';
subFolderList = {'test_ts'};

for i = 1:1:length(subFolderList)
    folderPath = [rootFolder, subFolderList{i}];
    
    % import image from tiffs and make hyperstack
    [parameters, allPaths] = lsm_parallel_import_v3(folderPath);
    fprintf('%s%s\n', 'import done: ', subFolderList{i});
    
    % Band Pass filter
    lsmTS_BPfilter_v11(parameters, allPaths, folderPath);
    fprintf('%s%s\n', 'BP done: ', subFolderList{i});

%     % Otsu filter
%     tifstack_otsuFilter_v3(folderPath, parameters);
%     fprintf('%s%s\n', 'otsuFilter done: ', subFolderList{i});
% 
%     % Get image difference data
%     imageDiff_v4(folderPath, parameters);
%     fprintf('%s%s\n', 'otsu imdiff done: ', subFolderList{i});

end

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