% zstacks_combine_v1
%
% Move the filtered images for a set of zstacks into a single folder useful
% for importing with trackpy


rootFolder = 'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\zstacks_';
l1 = {'p0', 'p20', 'p40', 'p60', 'p80', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500'};
% l1 = {'0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'};
% l1 = {'0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V'};
% filenameList = {'s1', 's2', 's3'};
filenameList = {'u1', 'u2', 'u3', 'u4'};

zsize = 50;

for i = 1:1:length(l1)
    %% Make new output folder
    outfolder = [rootFolder, l1{i}, '\', filenameList{1}(1), '_combined'];
    mkdir(outfolder);
    
    for j = 1:1:length(filenameList)
        
        bp_folderPath = [rootFolder, l1{i}, '\', filenameList{j}, '_bpass3D'];
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
