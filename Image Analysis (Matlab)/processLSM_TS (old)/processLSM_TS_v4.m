% Script for running shift, bpass and image difference calculations.

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb';


for i = 1:1:10
    filename = [folder '\ts' num2str(i) '.lsm'];
    
%     % Get particle drift data
%     shear_band_calculation_v5(filename);
% 
%     fprintf('%s\n %s\n', 'shift calc done', filename);
% 
%     % Band Pass filter
%     lsmTS_BPfilter_v6(filename);
% 
%     fprintf('%s\n %s\n', 'BP done', filename);
% 
%     % Calculate image difference
%     ShiftedImageDiff_v10(filename);
% 
%     fprintf('%s\n %s\n', 'ImDiff done', filename);
    
%     justfile = ['ts' num2str(i) '.lsm'];
%     lsmTS_3DbandpassFilter_v2(folder, justfile);
%     fprintf('%s\n %s\n', '3D bp filter done', justfile);
    

    justfile = ['ts' num2str(i) '_static_bpass_3D.tif'];
    tifBPass_zstack_series_to_tiffs_static_160(folder, justfile);
    fprintf('%s\n %s\n', 'static folder done', justfile);
end

preshear = 'preshear.lsm';
% lsmTS_3DbandpassFilter_v2_singlestack(folder, preshear);
% fprintf('%s\n %s\n', '3D bp filter done', preshear);

preshear = 'preshear_static_bpass_3D.tif';
tifBPass_zstack_series_to_tiffs_static_160(folder, preshear);
fprintf('%s\n %s\n', 'static folder done', preshear);