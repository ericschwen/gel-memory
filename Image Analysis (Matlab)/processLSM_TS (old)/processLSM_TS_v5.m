folder = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.1V 11-21-16';


filename = [folder '\timeseries.lsm'];

% Get particle drift data
shear_band_calculation_v5(filename);

fprintf('%s\n %s\n', 'shift calc done', filename);

% Band Pass filter
lsmTS_BPfilter_v6(filename);

fprintf('%s\n %s\n', 'BP done', filename);

% Otsu filter
filenameBP = [folder '\timeseries_bpass.tif'];

tifstack_otsuFilter_v1(filenameBP);

fprintf('%s\n %s\n', 'otsuFilter done', filename);

% Get image difference data
ShiftedImageDiff_v13_otsu(filename);

fprintf('%s\n %s\n', 'otsu imdiff done', filename);

% Previous image difference method

ShiftedImageDiff_v13_regular(filename);

fprintf('%s\n %s\n', 'imdiff done', filename);
