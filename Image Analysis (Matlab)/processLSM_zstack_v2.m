% Master file for running all the necessary image processing code to
% analyze zstacks of sheared colloidal gel.

% Mod. history
% v2: add otsu filter and image difference calculations

root_folder = 'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\2.8V\ampsweep\';
subfolders = {'3.6'};
% subfolders = {'0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'};

stacks = {'u0', 'u1', 'u2', 'u3', 'u4', 'u5'};
% stacks= {'s1', 's2', 's3', 's4', 's5'};
filenameList = cell(length(stacks),1);


for i = 1:1:length(subfolders)
    for j = 1:1:length(filenameList)
        
        folderPath = [root_folder, subfolders{i}];
        
        filenameList{j} = [stacks{j} '.lsm'];

        % Band Pass filter
        lsmTS_3DbandpassFilter_v4(folderPath, filenameList{j})
        
        
        tifstack_otsuFilter_v5(root_folder, subfolders{i}, stacks{j})
        
    end
    fprintf('%s%s\n', 'filtering done: ', subfolders{i});
    imageDiff_v9(root_folder, subfolders{i}, stacks);
end

%%
% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;
