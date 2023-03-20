% filename = 'C:\Users\Eric\Documents\Xerox Data\0.5Hz_1Amp_5-27-16.mdb\zstack_1.lsm';


% filename = ['C:\Users\Eric\Documents\Xerox Data\Meeras Data\'...
%     '2016_04_27\0.5V_1Hz.mdb\zstack4.lsm']

filepath = 'C:\Users\Eric\Documents\Xerox Data\2Hz Data Runs\2Hz 1.4V 7-11-16.mdb\timeseries1.lsm';
filebase = filepath(1:length(filepath)-4);
outpath = [filebase, '_bpass.tif'];
zini = 1;
dz = 1;
zsiz = 100;
zfin = 100;

imarray3D = zeros(256,512, zsiz);

imarray2D = zeros(256, 512);

cnt = 1;
for i = 1:1:zsiz
    imarray3D(:, :, cnt) = imread(filepath, 2*i -1);
    cnt = cnt +1;
end



for zframe = zini:dz:zfin
    % if-else allows program to overwrite previous files.
    % Use only the if part if you don't want to overwrite
    imarray2D(:,:) = imarray3D(:,:,zframe);
    
    filteredImage = bpass2D(imarray2D, 8, 2, 1);

    % Changes the image from white particles on black background to black
    % particles on white background.
    filteredImage = imcomplement(filteredImage);
    
    if (zframe ~= 1)
        imwrite(filteredImage, outpath, 'WriteMode', 'append')
    else
    imwrite(filteredImage, outpath, 'WriteMode', 'overwrite')
    end
end