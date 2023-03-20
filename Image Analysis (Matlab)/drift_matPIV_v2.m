function drift_matPIV(params, all_paths, folder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the shifts dx and dy to match two images as best as possible.
% Designed to iterate through entire zstacks taken at regular intervals.
% Saves results in strainpathX and strainpathY files.

%% Import sizes from params structure
numtframes = uint32(params.stack_size.T);
xsiz = uint32(params.stack_size.X);
ysiz = uint32(params.stack_size.Y);
zsiz = uint32(params.stack_size.Z);

out_supersize = [zsiz numtframes];
all_paths_shaped = reshape(all_paths, out_supersize);
% Now all_paths_shaped{z,t} gives the path to the specified image 
% Equivalent to all_paths{zframe + (tframe-1) * zsiz}

% Can manually specify number of tframes shorter for testing
numtframes = 3;

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Make new output folder
folderParts = strsplit(folder, '\');
parent = strjoin(folderParts(1:end-2), '\');
newfolder = strcat(folderParts(end-1), '_drift');
mkdir(parent, newfolder{1});

outfolder = [parent, '\', newfolder{1}, '\'];

%% Declare names of files to save to

strainpathX = [outfolder '\v_fieldX.csv'];
strainpathY = [outfolder '\v_fieldY.csv'];

zini = 1;
dz = 1;
zfin = zsiz;
% Size of zstack. Can be different from 
% zfin if there is an excluded part in bottom or top of image.

numFrames = zsiz * (numtframes-1);
% total number of iterations using numtframes-1 since I need to compare
% subsequent images (so the number of data points I get is the total number
% of times - 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Declare data arrays
dx = zeros(numtframes-1, zsiz);
dy = zeros(numtframes-1, zsiz);


%%
for zframe = zini : dz : zfin
    
    % Iterate through different times. Default = N/2-1
    % Can set a lower value for quicker test runs, etc.
    for tframe = 1:1:(numtframes-1)

        image1 = imread(all_paths_shaped{zframe, tframe});

        image2 = imread(all_paths_shaped{zframe, tframe+1});

        %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
        % Algorithm definitions
        windows = [512 32; 512 32];
        overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
        method = 'multin';  %Defines evaluation mode for matpiv.m
        warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning

        Dt = 1;

        [x,y,u,v] = matpiv_gpu(image1, image2, windows, Dt, overlap, method);

        % Saves shifts. Rows are consecutive times, columns are
        % consecutive images in zstack.
        dx(tframe, zframe) = mean(u);
        dy(tframe, zframe) = mean(v);

    end

end 

%% Write results to file
 csvwrite(strainpathX, dx);
 csvwrite(strainpathY, dy);

end