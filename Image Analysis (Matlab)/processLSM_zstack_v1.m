% Master file for running all the necessary image processing code to
% analyze zstacks of sheared colloidal gel.


rootFolder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train\';
subFolderList = {'1.2V'};
filenameList = {'u1.lsm', 'u2.lsm', 'u3.lsm', 'u4.lsm', 'u5.lsm', 'u6.lsm'};

for i = 1:1:length(subFolderList)
    for j = 1:1:length(filenameList)
        
        folderPath = [rootFolder, subFolderList{i}];


        % Band Pass filter
        lsmTS_3DbandpassFilter_v4(folderPath, filenameList{j})
        fprintf('%s%s\n', 'BP done: ', filenameList{j});
        
        % Otsu filter
        % note that this only does 2D version. could maybe find or write a
        % 3D otsu filter if i wanted.
        tifstack_otsuFilter_v4(parameters, allPaths, folderPath);

    
    end

end

%%
% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;
