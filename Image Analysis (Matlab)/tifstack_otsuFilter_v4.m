%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tifstack_otsuFilter(params, all_paths, folder)

%% Modification History:
% v2: changed to take .lsm file path as input
% v3: take folder and parameters as inputs
% file_path: time series of ztacks that have been BP filtered
% v4: change to work with all_files input and parallelization

%%

% Choose how many time steps to run for
numtframes = uint32(params.stack_size.T);
% Number of slices in zstacks
xsiz = uint32(params.stack_size.X); % could get these from params produced by lsm_parallel_import
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

% folder = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.3V 7-11-16.mdb\timeseries1';
%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_otsu');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Make new all_paths_bpass to get bp file paths
bpFolderPath = [folder(1:end-1), '_bpass'];

all_paths_bpass = cellfun(@(f) {[bpFolderPath '\' getFileName(f)]}, all_paths);

%%

numtframes = uint32(params.stack_size.T);
% Number of slices in zstacks
% xsiz = uint32(params.stack_size.X);
% ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

%% Apply otsu filter
numFrames = zsiz * numtframes;

parfor ff = 1:numFrames
        
    % Note: unfilteredImage expects a BP filtered image. Just not otsu
    % filtered yet.
    bpImage = imread(all_paths_bpass{ff});

    % Apply otsu filter
    otsuImage = thresholdLocally(bpImage);
    
    parts = strsplit(all_paths_bpass{ff}, '\');

    imwrite(otsuImage, strcat(outfolder, parts{end}), 'WriteMode', 'overwrite', 'Compression', 'none')

end
end

