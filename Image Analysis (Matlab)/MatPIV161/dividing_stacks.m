%%%%%%%%%%%%%%%%%%%%%%% below are the input parameters!! %%%%%%%%%%%%%%%%%%2
bigTifFileName='/Volumes/ebarn/colloidal_liquid/JP_particle_1um_20110915_2s_200.mdb/JP_particle_1um_20110915_2s_200/raw/JP_particle_1um_20110915_2s_200.tif';
dotInds = strfind(bigTifFileName, '.');
dirPrefix = bigTifFileName(1:dotInds(end) - 1);


h1 = 1;             %threshold reference head1
h2 = 50;            %threshold reference head2
t1 = 9950;          %threshold reference tail1
t2 = 10000;          %threshold reference tail2
stacktot = 200;      %the total number of stacks

%%%%%%%%%%%%%%%%%%%%%%% above are the input parameters!! %%%%%%%%%%%%%%%%%%


info = imfinfo(bigTifFileName);   %get the information of the images
numImgs = numel(info);            %get the total number of images in this stack
bundle = round(numImgs / stacktot) ;   %number of images in a sub-stack
if (mod(numImgs,stacktot)==0)
    fprintf('\n\nGood input stacktot!\n Let us start running!\n');
else
    fprintf('\n\nBad input stacktot!!!!\n');
    
end

im1 = imread(bigTifFileName, h1);
im2 = imread(bigTifFileName, h2);
im3 = imread(bigTifFileName, t1);
im4 = imread(bigTifFileName, t2);

hcut = min( [ mean(mean(im1)) mean(mean(im3)) ] );    %truncation for head
tcut = min( [ mean(mean(im2)) mean(mean(im4)) ] );    %truncation for tail


for stackcnt = 1 : stacktot;

    last = stackcnt*bundle;
    for cnt = stackcnt*bundle:-1:stackcnt*bundle-10
        imtemp = imread(bigTifFileName, cnt);
        if (mean(mean(imtemp)) < tcut);
            last = cnt;
        end
    end
    

    writeFileName = [dirPrefix '_' num2str(stackcnt) '.tif'];
    if (exist(writeFileName, 'file'))
        delete(writeFileName);
    end

    for cnt = (stackcnt-1)*bundle+1:last
    
        imtemp = imread(bigTifFileName, cnt);
    
        if (mod(cnt,bundle)>10 || mean(mean(imtemp)) > hcut)
        imwrite(imtemp, writeFileName, 'WriteMode', 'append');
        end
    end
   
   fprintf(['Bundle ' num2str(stackcnt) ' is done. \n']);
   
end