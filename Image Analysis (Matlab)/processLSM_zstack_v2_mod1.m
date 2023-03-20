% Master file for running all the necessary image processing code to
% analyze zstacks of sheared colloidal gel.

% Mod. history
% v2: add otsu filter and image difference calculations
% v2_mod1: for pauses

root_folder = 'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\zstacks_';
subfolders = {'p0', 'p20', 'p40', 'p60', 'p80', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};
% subfolders = {'0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'};

% stacks = {'u1', 'u2', 'u3', 'u4'};
stacks= {'s1', 's2', 's3'};
filenameList = cell(length(stacks),1);

% filenameList = {'u1.lsm', 'u2.lsm', 'u3.lsm', 'u4.lsm', 'u5.lsm', 'u6.lsm'};



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
