   function [Centroid, Size] = featuringComponents3D(bpimage, partsize , varargin)
%
% NAME: featuringComponents3D
% SYNTAX: RESULT = featurinComponents3D(BPIMAGE, PARTSIZE, [optionalInputs])
% PURPOSE: Determine the size and the centroid of various clusters in an
% image
% INPUT PARAMETERS: 
%    BPIMAGE: 3D array of images with the background noise subracted away 
%               with a band pass filer. An image with white particles in a
%               black bachground is expected
%   PARTSIZE: Average size of the smallest particle. (Volume.
%             4/3*pi*8^3 ~ 2000) (8 pixels ~ particle radius for 2um SiO2)
%   OPTIONAL INPUTS: Potentially, these values may be specified in this
%    order
%       THRESH:  And array with the same z length as the image with values 
%                 between [0, 1], or a single number which can be used to
%                 set the threshold to convert the image to a black and
%                 white file. If no threshold is specified, GREYTHRESH is 
%                 used to threshold the image.  
%       MASSCUT: Integer scalar. If set, all clusters with pizels fewer 
%                than MASSCUT will be deleted. If not set, then all
%                clusters smaller than 80% of the particle size will be
%                deleted.
% OUTPUTS:
%    CENTROID: The centroid of each cluster. 
%    SIZE: The size of each cluster in pixels
% PROCEDURE: Uses thresholding and the matlabs inbuilt algorithm, bwlabeln, 
% to determine the cebtroid and the area of the connected components. 
% MODIFICATION HISTORY: 
%  - Written 30th April 2016 by Meera Ramaswamy. 
%

%Check if the threshold and the masscut are set, assign values to both masscut. 

flag =1;
if nargin > 2
    if length(varargin(1)) == size(bpimage, 3)
        thresh = varargin(1);
        flag = 0;
    else if length(varargin(1)) == 1
            thresh = varargin(1)*ones(size(bpimage, 3), 1);
            flag = 0;
        else
            error('Input threshold incorrect size!');
        end
    end
    if max(thresh) > 0 || min(thresh)< 0
        error('Thershold must be between 0 and 1!!');
    end
    if nargin > 3
        if varargin(2) > 0.8*partsize
            masscut = varargin(2);
        else 
            masscut = 0.8*partsize;
        end
    else
        masscut = 0.8*partsize;
    end
else
    masscut = 0.8*partsize;    
end


BWImg = zeros(size(bpimage, 1), size(bpimage, 2), size(bpimage, 3));
% FiltImg = zeros(size(BWImg, 1), size(BWImg, 2));
%Covert the image to a black and white image
for i = 1:1:size(bpimage, 3)
    if flag ~= 0
    thresh = graythresh(bpimage(:, :, i));
    end
    BWImg(:, :, i) = im2bw(bpimage(:, :, i), thresh);
end

%Find the connected components in the image
ConCom = bwconncomp(BWImg);

%Find the properties of each component. Discard the components that don't
%satisfy the imput criteria (Eccentricity, particle size etc) (POTENTIALLY
%ADD stuff to do fancey things like brightness filters etc... )

PartProp = regionprops((ConCom), 'Centroid', 'Area');

cnt = 1;

for i = 1:1:length(PartProp)
    if PartProp(i).Area > masscut
        FiltPart(cnt) = PartProp(i);
        Centroid(cnt, :) = PartProp(i).Centroid;
        Size(cnt) = PartProp(i).Area;
        cnt = cnt + 1;
    end
end


% 
% FiltImg = label2rgb(ConCom);
% for j = 1:1:length(PartProp(i).PixelList)
%      temp_X = PartProp(i).PixelList(j, 1);
%      temp_Y = PartProp(i).PixelList(j, 2);
%      temp_Z = PartProp(i).
%      PixelList(j, 2);
%      FiltImg(temp_X, temp_Y) = 1;
% end

end

