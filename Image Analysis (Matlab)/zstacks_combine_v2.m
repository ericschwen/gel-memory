% zstacks_combine_v1
%
% Move the filtered images for a set of zstacks into a single folder useful
% for importing with trackpy


root_folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep\';

% Read all file names from folder
files_dir = dir(root_folder);
subfolders = cell(length(files_dir)-2, 1);
for i = 3:length(files_dir)
    subfolders{i-2} = files_dir(i).name;
end

% filenameList = {'u0', 'u1', 'u2', 'u3', 'u4', 'u5'};

filenameList = {'s1', 's2', 's3', 's4', 's5'};

zsize = 50;

for i = 1:1:length(subfolders)
    %% Make new output folder
    outfolder = [root_folder, subfolders{i}, '\', filenameList{1}(1), '_combined'];
    mkdir(outfolder);
    
    for j = 1:1:length(filenameList)
        
        bp_folderPath = [root_folder, subfolders{i}, '\', filenameList{j}, '_bpass3D'];
        copyfile([bp_folderPath, '\z*'], outfolder)
        for z = 1:zsize
            movefile([outfolder, '\z', num2str(z), '.tif'], [outfolder, '\t', num2str(j), 'z', num2str(z), '.tif'])
        end

       fprintf('%s%s\n', 'combine: ', bp_folderPath);
    
    end

end

%%
% % Testing code. run this part to set global variable as local variables
% % for running specfic functions.
% params = parameters;
% all_paths = allPaths;
% folder = folderPath;
