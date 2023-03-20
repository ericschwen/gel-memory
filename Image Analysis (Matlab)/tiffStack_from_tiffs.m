
folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\2.4\u2_bpass3D_o5';
fsplit = strsplit(folder, '\');
base = strjoin(fsplit(1:length(fsplit)-1), '\');

file = fsplit(length(fsplit));
file = file{1}(1:2);

outpath = [base, '\', file, '_o5.tif'];

for i = 1:50
    file = ['\z', num2str(i), '.tif'];
    path = [folder, file];
    image = imread(path);
    
    if i ~= 1
        imwrite(image, outpath, 'WriteMode', 'append')
    else
        imwrite(image, outpath, 'WriteMode', 'overwrite')
%         imshow(image)
    end
end
