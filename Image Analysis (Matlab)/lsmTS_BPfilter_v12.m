%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modification History:
% v2: change size to 270 frames to work with bigger zstacks.
% v3: remove (comment out) normalization over columns. doesn't do what i
% want it to do.
% v4: divide out background illumination.
% v5: overall normalization of image
% v6: remove the normalization from v5. Not actually correct. Need to
% normalize by number of particles too.
% v7: remove dividing out background illumination for now. Not sure it is
% working as intended and I don't think it is necessarily necessary.
% v8: put z size and number of time frames as input arguments.
% v9: take 4-D uint8 image as argument (produced by lsm_parallel_import)
% rather than an lsm file path.
% v10: take parameters, cell array of image paths, and root folder as
% inputs.
% v11: change to work with all_paths having a single column
% v12: implement parallel processing (parfor)
%%
function lsmTS_BPfilter(params, all_paths, folder)
% filteredImage for time series

% full_image organized as full_image(y,x,z,t)

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
newfolder = strcat(folderParts(end-1), '_bpass');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Run bandpass filter
numFrames = zsiz * numtframes;

parfor ff = 1:numFrames

    image = imread(all_paths{ff});
    % Apply bandpass filter
    filteredImage = bpass2D(image,8,2,1);      

%     % Can get image complement for dark particles on light background
%         filteredImage = imcomplement(filteredImage);
    
    
    parts = strsplit(all_paths{ff}, '\');
    
    imwrite(filteredImage, strcat(outfolder, parts{end}),'WriteMode', 'overwrite', 'Compression', 'none');
end

