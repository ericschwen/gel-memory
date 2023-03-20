 function filtered = bpass3D_ellipse_v3(image_array, lobject, lnoise, ImComp)
% v2: just clean up some of the commented lines. No real change to code.
 
 %
% NAME: bpass3D_ellipse
% SYNTAX: RESULT = bpass3D_ellipse(image_array, lobject, lnoise, ImComp)
% PURPOSE:  Return a grayscale image with the low frequncy and high
% frequency noise removed
% INPUT PARAMETERS: 
%   IMAGE_ARRAY: A three dimensional image array with particles in a background 
%   LOBJECT: The radius of the particle in pixels. (About 8 for 2um
%            particle).
%   LNOISE: The size of the background noise also in pixels. Using (1-4)
%           typically works well.
%   IMCOMP: To use the bandpass filter the program looks for bright images
%           on a dark background. Set ImComp to 1 if the input image is a dark
%           image on a light background. (Use 1 for all of my images
%           (Eric)).
% OUTPUTS:
%    FILTERED: 3D array of images with the background noise subracted away 
%               with a band pass filer. 
% PROCEDURE: Uses a gaussian kernell to apply a low pass and a high pass
% filter to the image. The resulting image is enhanced and made to have a
% uniform intensity using the matlab function adapthisteq. 
% MODIFICATION HISTORY: 
%  - Written 30th April 2016 by Meera Ramaswamy. 
%   v3: changed object size to adjust for smaller z pixels. Using ratios
%   for xy = 0.127 um/px and z = 0.12 um/px. 9-22-17

        if ImComp
            image_array= imcomplement(image_array);
        end
        
        % Make lobject into a 1x3 array (3 dimensions) and scale the z-dim
        % to account for pixel size.
        % [x y z] = [1 1 1.0583] instead of [1 1 1].
        lobject = [1 1 1.0583] * lobject;
        lnoise = [1 1 1.0583] * lnoise;
        
%         %%% Equal pixel size version %%%
%         lobject = [1 1 1] * lobject;
%         lnoise = [1 1 1] * lnoise;
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Pad array with boundaries on edges made by replicating edges.
        % Have to make sure sizes are still doubles but integers.
        padding = double(int32(2*lobject));
        image_array= padarray(image_array, padding, 'replicate', 'both');

        %%%%%%%%%%%% Gaussian mask %%%%%%%%%%%%
        [kx, ky, kz] = build_freq3d(image_array);
        kernel = exp(-(kx.^2 * (lobject(1)^2) + ky.^2 * (lobject(2)^2) + kz.^2 * (lobject(3)^2))/2);
        kernel = permute(kernel,[2,1,3]);
        highPass = real(ifftn(kernel.*fftn(image_array)));
        kernel = exp(-(kx.^2 * (lnoise(1)^2) + ky.^2 * (lnoise(2)^2) + kz.^2 * (lnoise(3)^2))/2);
        kernel = permute(kernel,[2,1,3]);
        lowPass = real(ifftn(kernel.*fftn(image_array)));

        filtered = lowPass - highPass;
        
        % Set otsu thresheold and set non-particle pixels to zero
        threshold = graythresh(filtered);
        filtered(filtered < threshold) = 0;
        
        % Scale filtered image to make intensity greater.
        filtered = filtered * 2;
%         disp(max(max(max(filtered))));
        filtered = uint8(filtered);

        %Get rid of padded edges introduced with padarray
        filtered = filtered(1+padding(1):end-padding(1), ...
            1+padding(2):end-padding(2), ...
            1+padding(3):end-padding(3));

        % Apply adapthisteq to enhance contrast in grayscale image.
        % Makes intensities larger to make tracking easier. Could also try
        % multiplying entire image by a scaling factor to increase
        % intensity.
        for i = 1 : size(filtered,3)
            filtered(:,:,i) = adapthisteq(filtered(:,:,i));
        end        

 end
