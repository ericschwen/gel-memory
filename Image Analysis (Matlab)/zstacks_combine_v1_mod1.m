% zstacks_combine_v1
%
% Move the filtered images for a set of zstacks into a single folder useful
% for importing with trackpy

% Mod. History:
% mod1: modified file reading for different conventions in 6-22-17 data

rootFolder = 'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\';
l1 = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V'};
l2 = {'_1', '_2'};

zsize = 50;

for i = 1:1:length(l1)
    %% Make new output folder
    outfolder = [rootFolder, l1{i}, '_combined'];
    mkdir(outfolder);
    
    for j = 1:1:length(l2)
        
        bp_folderPath = [rootFolder, l1{i}, l2{j}, '_bpass3D'];
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
