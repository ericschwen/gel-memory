% Script for running shift, bpass and image difference calculations.

folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\Gel 1Hz 0.8V 11-8-16';

filename = [folder '\ampsweep.lsm'];

% Get particle drift data
shear_band_calculation_v5_sweep(filename);

fprintf('%s\n %s\n', 'shift calc done', filename);

% Band Pass filter
lsmTS_BPfilter_v6_sweep(filename);

fprintf('%s\n %s\n', 'BP done', filename);

% Calculate image difference
ShiftedImageDiff_v10_sweep(filename);

fprintf('%s\n %s\n', 'ImDiff done', filename);
