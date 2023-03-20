function stack_enhance
% From Meera: 9/27/17
% Normalizes brightness across each column in image to remove uneven
% illumination. Applies adapthisteq to enhance contrast afterward. To run
% before bandpass filtering.
% 2D version.

    %bigTifFileName=[bigpath char(pathlist(pcnt))];
    %dotInds = strfind(bigTifFileName, '.');
    %dirPrefix = bigTifFileName(1:dotInds(end) - 1);
    %dirPrefix = [dirPrefix '']
    %mkdir(dirPrefix);
% for k = 10:1:10

for k = 1:1:1
     for l = 1:1:1
        filePath = ['F:\ConfinedShearThickening\2017_08_18\SmallGapAnalysis\Gap_before.lsm'];
        writeFileName = ['F:\ConfinedShearThickening\2017_08_18\SmallGapAnalysis\Enhanced\Gap_before_' num2str(l) '.tif'];
        InfoImage=imfinfo(filePath);
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        numImgs=length(InfoImage);
        imtemp = imread(filePath, 1);
%         maxIn = max(max(imtemp));
%         minIn = min(min(imtemp));
        for i=1:2:300
            imtemp = imread(filePath,'Index',i,'Info',InfoImage);
    %         preOut = imcomplement(imtemp);
            %%%%% adjusting the brightness %%%%%%%%%%
                aveBright = mean(imtemp(:));
    %             modyTemp = zeros(size(imtemp,1),size(imtemp,2));
                modyTemp = double(imtemp);
                for column = 1:size(imtemp,2)
                    modyTemp(:,column) = round(modyTemp(:,column) / mean(imtemp(:,column))*aveBright);
    %                 TempColumn = aveBright* ones(length(modyTemp(:, column)), 1);
    %                 modyTemp(:, column) = TempColumn - modyTemp(:, column);
                    imtemp(:,column) = uint8(modyTemp(:,column));
                end
    % %           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             preOut = imtemp;

            preOut = wiener2(imtemp, [2, 2]);
            preOut = adapthisteq(preOut);
            imwrite(preOut, writeFileName, 'WriteMode', 'append');
        end
     end

            
    
end
end

