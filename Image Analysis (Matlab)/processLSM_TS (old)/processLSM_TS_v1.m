% Script for running shift, bpass and image difference calculations.

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.4V 8-30-16.mdb';
numfiles = 1;

for i = 1:1:numfiles
    filename = [folder '\ts' num2str(i) '_delayed.lsm'];
    
    % Get particle drift data
    shear_band_calculation_v5(filename);

    fprintf('%s\n %s\n', 'shift calc done', filename);

    % Band Pass filter
    lsmTS_BPfilter_v5(filename);

    fprintf('%s\n %s\n', 'BP done', filename);

    % Calculate image difference
    ShiftedImageDiff_v10(filename);

    fprintf('%s\n %s\n', 'ImDiff done', filename);
end
