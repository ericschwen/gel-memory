

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function lsmTS_3DbandpassFilter_v3(folder, filename)
% Inputs:
%   folder: folder containing the lsm file
%   filename: name of the lsm zstack file


%v2: changes to a function. Inputs are the folder and filename (for .lsm file)
%v3: change to save individual images instead of a stack. 6-13-17
%v4: no shortened segments and only 50 slices.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Need to run bpass3D for each frame and save the result each time.

for i = 5:1:5
    for j = 1:1:1


        folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 postsweep stack';
        filename = 'zstack_post_train_enhanced.tif';
        lobject = i;
        lnoise = j;
        ImComp = 1;

        filepath = [folder, '\', filename];
        % filepath = [folder, filename];
        filebase = filepath(1:length(filepath)-4);

        % Make new output folder
        outfolder = [filebase, '_bpass3D_o', num2str(lobject)];
%         outfolder = [filebase, '_bpass3D_o', num2str(lobject), '_n', num2str(lnoise)];
        % outfolder = [filebase, '_bpass3D'];
        mkdir(outfolder);

        % initiate image array of the correct size.
        xsiz = 512;
        ysiz = 512;
        zsiz = 270;

        imarray = zeros(ysiz, xsiz, zsiz);

        zini = 1;
        dz = 1;
        zfin = zsiz;

%         % lsm version
%         cnt = 1;
%         for zframe = zini:dz:zfin
%             imarray(:, :, cnt) = imread(filepath, 2*zframe-1);
%             cnt = cnt +1;
%         end
        
        % tif version
        cnt = 1;
        for zframe = zini:dz:zfin
            imarray(:, :, cnt) = imread(filepath, zframe);
            cnt = cnt +1;
        end


        % Parameters: image array, particle radius, noise, image complement

        filteredImage = bpass3D_ellipse_v3(imarray, lobject, lnoise, ImComp);

        % imarray = uint8(imarray); % Needs to be uint8 to print correctly.
        % imprint(filteredImage);

        % Write bandpass filtered image to file:
        for zframe = zini:dz:zfin
            writepath = strcat(outfolder, '\z', int2str(zframe), '.tif');
            imwrite(filteredImage(:,:,zframe), writepath ,'WriteMode', 'overwrite', 'Compression', 'none')
        end

    end
end
