% zstacks_combine_v1
%
% Move the filtered images for a set of zstacks into a single folder useful
% for importing with trackpy


rootFolder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep';
subfolders = {'p0', 'p20', 'p40', 'p60', 'p80', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};
filenameList = {'s1', 's2', 's3'};

zsize = 50;

for i = 1:1:length(subFolderList)
    %% Make new output folder
    outfolder = [rootFolder, subFolderList{i}, '\', filenameList{1}(1), '_combined'];
    mkdir(outfolder);
    
    for j = 1:1:length(filenameList)
        
        bp_folderPath = [rootFolder, subFolderList{i}, '\', filenameList{j}, '_bpass3D'];
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
