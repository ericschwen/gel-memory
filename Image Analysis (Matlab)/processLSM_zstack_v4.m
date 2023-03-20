% Master file for running all the necessary image processing code to
% analyze zstacks of sheared colloidal gel.

% Mod. history
% v2: add otsu filter and image difference calculations
% v3: read files from folder
% v4: run bpass and combine files (essentially writing zstacks_combine_v3
% into this script. 10-1-17

root_list = {'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\'};

zsize = 150;


%% Note: File "C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\1.4V\ampsweep\1.0\u0.lsm"
% does not exist. I copied over u5 from the previous one. Should be same
% image.

for k = 1:length(root_list)
    root_folder = root_list{k};
   
%     % PAUSE VERSION:
%     subfolders = {'p0', 'p50', 'p150', 'p200', 'p300', 'p400', 'p500'}
    
    % AMPSWEEP VERSION:
    %Read all file names from folder
    files_dir = dir(root_folder);
    subfolders = cell(length(files_dir)-2, 1);
    for i = 3:length(files_dir)
        subfolders{i-2} = files_dir(i).name;
    end

%     subfolders = {'p100'};
%     stacks = {'u0', 'u1', 'u2'};
    
%     stacks = {'u0', 'u1', 'u2', 'u3'};
%         stacks= {'s1', 's2', 's3'};
    

%     stacks = {'u0', 'u1', 'u2', 'u3', 'u4', 'u5'};
    stacks= {'s1', 's2', 's3', 's4', 's5'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filenameList = cell(length(stacks),1);



    for i = 1:1:length(subfolders)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % Run bandpass filtering
        for j = 1:1:length(stacks)

            folderPath = [root_folder, subfolders{i}];

            filenameList{j} = [stacks{j} '.lsm'];

            % Band Pass filter
            lsmTS_3DbandpassFilter_v6(folderPath, filenameList{j}, zsize)

%             % Otsu filter. Run if wanted for image difference.
%             tifstack_otsuFilter_v5(root_folder, subfolders{i}, stacks{j})

        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make new output folder for combined bpass images
        outfolder = [root_folder, subfolders{i}, '\', stacks{1}(1), '_combined_o5'];
        mkdir(outfolder);
        
        % copy bpass filtered images to the combined file
        for j = 1:1:length(stacks)
            bp_folderPath = [root_folder, subfolders{i}, '\', stacks{j}, '_bpass3D_o5'];
            copyfile([bp_folderPath, '\z*'], outfolder)
            for z = 1:zsize
                movefile([outfolder, '\z', num2str(z), '.tif'], [outfolder, '\t', num2str(j), 'z', num2str(z), '.tif'])
            end
        end
        
        
        fprintf('%s%s\n', 'filtering done: ', subfolders{i});
%         imageDiff_v9(root_folder, subfolders{i}, stacks);
    end
    fprintf('%s%s\n', 'filtering done: ', root_folder);
end

%%
% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;
