function lsmTS_3DbandpassFilter_v5(folder, filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs:
%   folder: folder containing the lsm file
%   filename: name of the lsm zstack file


%v2: changes to a function. Inputs are the folder and filename (for .lsm file)
%v3: change to save individual images instead of a stack. 6-13-17
%v4: no shortened segments and only 50 slices.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Need to run bpass3D for each frame and save the result each time.

filepath = [folder, '\', filename];
% filepath = [folder, filename];
filebase = filepath(1:length(filepath)-4);

%% Make new output folder
outfolder = [filebase, '_bpass3D_o5'];
% outfolder2 = [filebase, '_bpass3D_slices'];
mkdir(outfolder);


% initiate image array of the correct size.
xsiz = 512;
ysiz = 512;
zsiz = 50;

imarray = zeros(ysiz, xsiz, zsiz);

zini = 1;
dz = 1;
zfin = zsiz;

cnt = 1;
for zframe = zini:dz:zfin
    imarray(:, :, cnt) = imread(filepath, 2*zframe-1);
    cnt = cnt +1;
end

% Parameters: image array, particle radius, noise, image complement

filteredImage = bpass3D_ellipse_v3(imarray, 5, 1, 1);

% imarray = uint8(imarray); % Needs to be uint8 to print correctly.
% imprint(filteredImage);

% Write bandpass filtered image to file:
for zframe = zini:dz:zfin
    writepath = strcat(outfolder, '\z', int2str(zframe), '.tif');
    imwrite(filteredImage(:,:,zframe), writepath ,'WriteMode', 'overwrite', 'Compression', 'none')
end


end
% 
% %% Sample folders
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V';
% filename = 'zstack_post_sweep1.lsm';


%% Code to save as a single stack instead:
%         % if-else allows program to overwrite previous files.
%         % Use only the if part if you don't want to overwrite
%         if (zframe ~= 1) || (tframe ~=1)
%             imwrite(filteredImage(:,:,zframe), outpath, 'WriteMode', 'append')
%         else
%             imwrite(filteredImage(:,:,zframe), outpath, 'WriteMode', 'overwrite')
%         end

