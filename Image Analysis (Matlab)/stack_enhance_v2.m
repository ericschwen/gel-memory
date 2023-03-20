% function stack_enhance_v2
% From Meera: 9/27/17
% Normalizes brightness across each column in image to remove uneven
% illumination. Applies adapthisteq to enhance contrast afterward. To run
% before bandpass filtering.
% 2D version.
%
% Mod history:
% v2: Eric's cleanup
% v3: use mean for full image

filePath = ['C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 postsweep stack\zstack_post_train.lsm'];
writeFileName = [filePath(1:length(filePath)-4), '_enhanced_singles.tif'];
InfoImage=imfinfo(filePath);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
numImgs=length(InfoImage)/2;
imtemp = imread(filePath, 1);
%         maxIn = max(max(imtemp));
%         minIn = min(min(imtemp));
for i=1:1:numImgs
    imtemp = imread(filePath,'Index',2*i-1,'Info',InfoImage);
%     preOut = imcomplement(imtemp);
    %%%%% adjusting the brightness %%%%%%%%%%
    % average brightness of total image
    aveBright = mean(imtemp(:));
%     modyTemp = zeros(size(imtemp,1),size(imtemp,2));
    modyTemp = double(imtemp);
    for column = 1:size(imtemp,2)
        % divide each column by its mean then muiltiply by the average
        % brightness to set mean on each column
        modyTemp(:,column) = round(modyTemp(:,column) / mean(imtemp(:,column))*aveBright);
        % change back to uint8
        imtemp(:,column) = uint8(modyTemp(:,column));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % apply filters
%     preOut = wiener2(imtemp, [2, 2]);
    preOut = adapthisteq(imtemp);
    if i ~= 1
        imwrite(preOut, writeFileName, 'WriteMode', 'append');
    else
        imwrite(preOut, writeFileName, 'WriteMode', 'overwrite');
    end
end
% end

