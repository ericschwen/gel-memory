p = 'E:\cool confocal tilescans\more tilescan testing 6-26-17\tilescan2_256x256.lsm';
im = imread(p);
im_cell = mat2cell(im, [1 1]*256, [1 1]*256);
im_cell_fixed = flipud(fliplr(im_cell'));
im_fixed = cell2mat(im_cell_fixed);
figure;
imshow(im_fixed)

%%
p_still = 'E:\cool confocal tilescans\more tilescan testing 6-26-17\still2.lsm';
figure;
imshow(p_still)

%%
figure;
imshow(p)

%%
p_10 = 'C:\Eric\cool confocal tilescans\10x tilescans 6-26-17\still1.lsm';
im_10 = imread(p_10);
figure;
imshow(p_10)