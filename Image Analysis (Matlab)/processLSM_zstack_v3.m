% Master file for running all the necessary image processing code to
% analyze zstacks of sheared colloidal gel.

% Mod. history
% v2: add otsu filter and image difference calculations
% v3: read files from folder. Use v3 for single files, v4 for sweeps.

root_list = {'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained long\'};
zsize = 270;

for k = 1:length(root_list)
    root_folder = root_list{k};
   

%     % Read all file names from folder
%     files_dir = dir(root_folder);
%     subfolders = cell(length(files_dir)-2, 1);
%     for i = 3:length(files_dir)
%         subfolders{i-2} = files_dir(i).name;
%     end
    
    subfolders = {''};

    
    stacks = {'zstack_pre_sweep', 'zstack_post_sweep'};
%     stacks = {'zstack_pre_train'};    
%     stacks = {'zstack_pre_train', 'zstack_post_train'};
%     stacks = {'u0', 'u1', 'u2', 'u3', 'u4', 'u5'};
%     stacks= {'s1', 's2', 's3', 's4', 's5'};

    filenameList = cell(length(stacks),1);

    for i = 1:1:length(subfolders)
        for j = 1:1:length(filenameList)

            folderPath = [root_folder, subfolders{i}];

            filenameList{j} = [stacks{j} '.lsm'];

            % Band Pass filter
            lsmTS_3DbandpassFilter_v6(folderPath, filenameList{j}, zsize)

            % Otsu filter
%             tifstack_otsuFilter_v5(root_folder, subfolders{i}, stacks{j})

        end
        fprintf('%s%s\n', 'filtering done: ', subfolders{i});
%         imageDiff_v9(root_folder, subfolders{i}, stacks);
    end
    fprintf('%s%s\n', 'filtering done: ', root_folder);
end

%%

% Note: File "C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\1.4V\ampsweep\1.0\u0.lsm"
% does not exist. I copied over u5 from the previous one. Should be same
% image.

% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;
