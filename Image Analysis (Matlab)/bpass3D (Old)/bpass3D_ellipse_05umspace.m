 function filtered = bpass3D_ellipse(image_array, lobject, lnoise, ImComp)

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
%   IMCOMP: To use the bandpass filter the program looks for birght images
%           on a dark background. Set ImComp to 1 if the input image is a dark
%           image on a light background.
% OUTPUTS:
%    FILTERED: 3D array of images with the background noise subracted away 
%               with a band pass filer. 
% PROCEDURE: Uses a gaussian kernell to apply a low pass and a high pass
% filter to the image. The resulting image is enhanced and made to have a
% uniform intensity using the matlab function adapthisteq. 
% MODIFICATION HISTORY: 
%  - Written 30th April 2016 by Meera Ramaswamy. 
%

        if ImComp
            image_array= imcomplement(image_array);
        end
        

        %   image_array = A;
        % Pad array with boundaries on edges made by replicating edges.
        % Reduce edge effects?
        image_array= padarray(image_array, 2*lobject*[1 1 1], 'replicate', 'both');

        %%%%%%%%%%%% Gaussian mask %%%%%%%%%%%%
            [kx, ky, kz] = build_freq3d(image_array);
%             kernel = exp(-(kx.^2+ky.^2+kz.^2)*(lobject^2)/2);
            
%   Use kernal with ellipse instead of square. Multiply by (1?) instead of
%   lobject in the z-direction for spacing of 1um between zstacks (1 zstack
%   is 1/2 radius) Equivalently, divide lobject by 8 (0.5 um equivalent to 4 pixels).
            kernel = exp(-(kx.^2)*(lobject^2)/2 -(ky.^2)*(lobject^2/2)...
                -(kz.^2)*((lobject/4)^2/2));
            
            kernel = permute(kernel,[2,1,3]);
            highPass = real(ifftn(kernel.*fftn(image_array)));
            %figure; imagesc(highPass(:,:,34),[0 250]); colorbar;
            kernel = exp(-(kx.^2+ky.^2)*(lnoise^2)/2 - (kz.^2) * ((lnoise/4)^2/2) );

            kernel = permute(kernel,[2,1,3]);
            lowPass = real(ifftn(kernel.*fftn(image_array)));
            %figure; imagesc(lowPass(:,:,34),[0 250]); colorbar;

            filtered = lowPass - highPass;
            threshold = graythresh(filtered);
            filtered(filtered < threshold) = 0;
            filtered = filtered * 2;
            filtered = uint8(filtered);
            
            %Get rid of padded edges introduced with padarray
            filtered = filtered(1+2*lobject*[1 1 1]:end-2*lobject*[1 1 1], ...
                1+2*lobject*[1 1 1]:end-2*lobject*[1 1 1], ...
                1+2*lobject*[1 1 1]:end-2*lobject*[1 1 1]);
            
            %apply adapthisteq
            for i = 1 : size(filtered,3)
            filtered(:,:,i) = adapthisteq(filtered(:,:,i));
            end
            
            %figure; imagesc(rot90(filtered(:,:,34)'),[0 250]); colorbar;
        %figure; imshow3D(filtered);
        %figure; imshow(rot90(filtered(:,:,34)'), [0 305]);
        %%%%%%%%%%%% Gaussian mask %%%%%%%%%%%%
        
%         
%         if (exist(outPath, 'file'))
%             delete(outPath);
%         end
%         
%             for i=1:numImgs
%                 imwrite(filtered(:,:,i), outPath,'WriteMode', 'append');
%             end
%             clear filtered;
%             clear image_array;
%         end
%         fprintf([outPath '\n']);
%         
 end
% end

% end