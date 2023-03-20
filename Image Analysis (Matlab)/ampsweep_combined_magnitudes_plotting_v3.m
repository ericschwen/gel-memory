% Plot image difference over the course of an amplitude sweep.
% Combined version looks at alternating untrained and trained. Modified
% from ampsweep_save_magnitudes_v4
%  5-28-19
%   Mod History:
%     v2: add separate filepaths for strains in x and y
%     v3: use a separate volts-to-strain (v2s) number for y in combined
%     ampsweeps where difference in actual strain applied wasn't accounted
%     for.
%

% Manually written combined ampsweep data 
% % 0.6V 5-2-19 data
% strain_amps = 0.2:0.2:2.6;
% x_im_diff = [.0236 .0257 .0281 .0338 .0370 .0509 .0500 .0644 .0608 .0748 .0721 .0901 .0738];
% y_im_diff = [.0234 .0290 .0380 .0442 .0576 .0641 .0782 .0850 .0971 .1014 .1286 .1309 .1674];
% 
% % 1.0V 5-2-19 data
% x_im_diff = [.0258 .0281 .0290 .0364 .0370 .0471 .0478 .0583 .0543 .0682 .0639 .0855 .0742];
% y_im_diff = [.0265 .0313 .0386 .0456 .0578 .0594 .0756 .0759 .0943 .0961 .1203 .1213 .1592];

% importing data
folder = 'C:\Eric\Xerox Data\30um gap runs\6-14-19 data\';
% fileList = {'0.6V\ampsweep-post-train-combined'};
fileList = {'0.6V\ampsweep-post-train', '0.6V\ampsweep-pre-train'};

% Designate input strain amplitude
% Decide whether to skip first cycle at each amplitude in calculation
% since it has much more variation than the rest.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ampV = 0.6;
skip_first = true;
noise_max = 0.022;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suffix = '_imageDiff';
fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
strainAmpFilepath_x = cell(numfiles,1);
strainAmps_x = cell(numfiles,1);
strainAmpFilepath_y = cell(numfiles,1);
strainAmps_y = cell(numfiles,1);
IDFilepath_x = cell(numfiles,1);
IDErrFilepath_x = cell(numfiles,1);
imageDiff_x = cell(numfiles,1);
imageDiffErr_x = cell(numfiles,1);
IDFilepath_y = cell(numfiles,1);
IDErrFilepath_y = cell(numfiles,1);
imageDiff_y = cell(numfiles,1);
imageDiffErr_y = cell(numfiles,1);
% legendInfo = cell(numfiles,1);

for i = 1:length(fileList)
    filename{i} = [folder, fileList{i}, suffix];
    
    % strain amplitude and image difference file paths
    strainAmpFilepath_x{i} = [filename{i} '\strainAmplitudes_x.csv'];
    strainAmpFilepath_y{i} = [filename{i} '\strainAmplitudes_y.csv'];
    
    if skip_first == false
        IDFilepath_x{i} = [filename{i} '\imageDifferenceAmpsweep_x.csv'];
        IDErrFilepath_x{i} = [filename{i}, '\imageDifferenceAmpsweepErr_x.csv'];
        IDFilepath_y{i} = [filename{i} '\imageDifferenceAmpsweep_y.csv'];
        IDErrFilepath_y{i} = [filename{i}, '\imageDifferenceAmpsweepErr_y.csv'];
    else
        IDFilepath_x{i} = [filename{i} '\imageDifferenceAmpsweep_x_no1.csv'];
        IDErrFilepath_x{i} = [filename{i}, '\imageDifferenceAmpsweepErr_x_no1.csv'];
        IDFilepath_y{i} = [filename{i} '\imageDifferenceAmpsweep_y_no1.csv'];
        IDErrFilepath_y{i} = [filename{i} '\imageDifferenceAmpsweepErr_y_no1.csv'];
    end
    
    strainAmps_x{i} = xlsread(strainAmpFilepath_x{i});
    strainAmps_y{i} = xlsread(strainAmpFilepath_y{i});
    imageDiff_x{i} = xlsread(IDFilepath_x{i});
    imageDiffErr_x{i} = xlsread(IDErrFilepath_x{i});
    imageDiff_y{i} = xlsread(IDFilepath_y{i});
    imageDiffErr_y{i} = xlsread(IDErrFilepath_y{i});
end


% Conversion Volts to strain
v2s = 0.14;
v2s_y = v2s/.74;

%% Plot area error bar (test version)

options.x_axis{1} = strainAmps_x{1}*v2s;
options.y_axis{1} = strainAmps_y{1}*v2s_y;
options.x_axis{2} = strainAmps_x{2}*v2s;
options.y_axis{2} = strainAmps_y{2}*v2s_y;

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;

% red = [255, 0, 0]/255;
% brn = [153, 102, 0]/255;
% pur = [153, 0, 204]/255;
% blu = [128 193 219]./255;
% org = [243 169 114]./255; 

options.color_area_x{1} = blu;
options.color_line_x{1} = options.color_area_x{1};
options.color_area_y{1} = red; 
options.color_line_y{1} = options.color_area_y{1};
options.color_area_x{2} = pur;
options.color_line_x{2} = options.color_area_x{2};
options.color_area_y{2} = grn;
options.color_line_y{2} = options.color_area_y{2};
options.alpha      = 0.2;
options.line_width = 1.5;
options.marker_size = 22;

figure;
hold on;

zero_x_vector = [0:0.2:4.2, fliplr(0:0.2:4.2)];
% zero_x_vector = [options.x_axis{1}', fliplr(options.x_axis{1}')];
patch_zero = fill(zero_x_vector, [noise_max*ones(length(zero_x_vector)/2.,1)', ...
    0.02*ones(length(zero_x_vector)/2.,1)'], org, 'FaceAlpha', 0.2);
set(patch_zero, 'edgecolor', 'none');

% Plot vertical line for training amplitude
trainingAmplitude = ampV*v2s;
plot_train = plot(ones(100,1) * trainingAmplitude, 0.002:0.002:0.2, 'k--', ...
    'LineWidth', options.line_width);

% Plot image difference
y_vector{1} = [options.y_axis{1}', fliplr(options.y_axis{1}')];
patch_y{1} = fill(y_vector{1}, [imageDiff_y{1}'+imageDiffErr_y{1}',...
    fliplr(imageDiff_y{1}'-imageDiffErr_y{1}')], options.color_area_y{1});
set(patch_y{1}, 'edgecolor', 'none');
set(patch_y{1}, 'FaceAlpha', options.alpha);
plot_y{1} = plot(strainAmps_y{1}*v2s_y, imageDiff_y{1}, '-k.', ...
    'MarkerSize', options.marker_size,  'color', options.color_line_y{1}, ...
    'LineWidth', options.line_width);

x_vector{1} = [options.x_axis{1}', fliplr(options.x_axis{1}')];
patch_x{1} = fill(x_vector{1}, [imageDiff_x{1}'+imageDiffErr_x{1}',...
    fliplr(imageDiff_x{1}'-imageDiffErr_x{1}')], options.color_area_x{1});
set(patch_x{1}, 'edgecolor', 'none');
set(patch_x{1}, 'FaceAlpha', options.alpha);
plot_x{1} = plot(strainAmps_x{1}*v2s, imageDiff_x{1}, '-k.', ...
    'MarkerSize', options.marker_size, 'color', options.color_line_x{1}, ...
    'LineWidth', options.line_width);

y_vector{2} = [options.y_axis{2}', fliplr(options.y_axis{2}')];
patch_y{2} = fill(y_vector{2}, [imageDiff_y{2}'+imageDiffErr_y{2}',...
    fliplr(imageDiff_y{2}'-imageDiffErr_y{2}')], options.color_area_y{2});
set(patch_y{2}, 'edgecolor', 'none');
set(patch_y{2}, 'FaceAlpha', 0.3);
plot_y{2} = plot(strainAmps_y{2}*v2s_y, imageDiff_y{2}, '-k.', ...
    'MarkerSize', options.marker_size,  'color', options.color_line_y{2}, ...
    'LineWidth', options.line_width);

x_vector{2} = [options.x_axis{2}', fliplr(options.x_axis{2}')];
patch_x{2} = fill(x_vector{2}, [imageDiff_x{2}'+imageDiffErr_x{2}',...
    fliplr(imageDiff_x{2}'-imageDiffErr_x{2}')], options.color_area_x{2});
set(patch_x{2}, 'edgecolor', 'none');
set(patch_x{2}, 'FaceAlpha', options.alpha);
plot_x{2} = plot(strainAmps_x{2}*v2s, imageDiff_x{2}, '-k.', ...
    'MarkerSize', options.marker_size, 'color', options.color_line_x{2}, ...
    'LineWidth', options.line_width);

xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);

[lgd, lgd_icons] = legend([plot_x{2}, plot_y{2}, plot_x{1}, plot_y{1}, plot_train, patch_zero], ...
    {'Untrained x', 'Untrained y', 'Trained x', 'Trained y', 'Training strain', 'Noise floor'},...
    'Location', 'northwest', 'FontSize', 16);

patch_in_legend = findobj(lgd_icons, 'type', 'patch');
set(patch_in_legend, 'FaceAlpha', 0.3);

axis([0 0.25 0.02 0.1]);

% xticks(0.0:0.1:0.3)
% yticks(0.02:0.02:0.16);
yticks(0.02:0.02:0.16);

% axis([0 max(strainAmps_x{1})*v2s 0.02 0.3]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on
hold off;
