% nonlinear least squares exponential decay fit

% Define custom nonlinear fittype and use matlab's built in fit function
% for exponential decay with offset

% Author: Eric
% Date: 6-6-18
% v2: add patch for zero
% v3: move zero patch to fit figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-14-19 data\0.6V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.5V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\';

% folder = 'D:\Xerox Data\30um gap runs\0.2Hz combined runs 1-31-17\0.0V\';
% fileList = {'training'};
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
folder = 'D:\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\1.8V\';
fileList = {'train_ts1', 'train_ts2'};
% fileList = {'train_ts1'};
folderEnd = '_imageDiff';
% folderEnd = '';

% Trim off points before shear starts and after it ends (mod1 edit)
noise_max = 0.0226;
%%%%%%%%%%%%%%%%%%%%%%% MANUAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tstart = 21;
tend_trim = 100;

% tstart = 480;
% tend_trim = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
filebase = cell(numfiles,1);
midpath = cell(numfiles,1);
mid = cell(numfiles,1);
legendInfo = cell(numfiles,1);

for i = fileNumbers
    filename{i} = [folder, fileList{i}, folderEnd];
    
    midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
%     midpath{i} = [filename{i} '\' fileList{i} '_meanImageDiffCenter_otsu.csv'];
%     midpath{i} = [filename{i} '\' fileList{i} '_meanXYDiff_otsu_combined.csv'];
%     midpath{i} = [filename{i} '_meanImageDiffCenter_otsu.csv'];
%     midpath{i} = [filename{i} '_meanImageDiff_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

midtrim_init = midtotal(tstart:length(midtotal)-tend_trim);

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;
aqua = [0, 51, 0]/255.;
yel = [255,255,51]/255.;
pnk = [231,41,138]/255.;

% Plot patch for showing zero
figure;
hold on
% Plot trimmed full data set
t = (1:1:length(midtrim_init))';
plot_train1 = plot(t,midtrim_init,'b.', 'Color', aqua, 'MarkerFaceColor', aqua, 'MarkerSize', 12);
% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);
% ylim([0.011 0.1])
% xlim([0 50])
% axis([0 500 0.02 0.035]);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
box on
hold off
% % lgd.Box = 'off';


% %%% remove extreme outliers (not actual data points anyway)
% midtrim = midtrim_init;
% for i=length(midtrim_init):-1:1
%     if midtrim_init(i) > 0.6
%         midtrim(i) = [];
%     end
% end
% tt = (1:1:length(midtrim))';

% % Plot full data set with outliers removed (checking)
% figure;
% % t = t*2;
% hold on
% plot(tt,midtrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% 
% title('Training','FontSize', 20);
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
% % ylim([0.02 0.05])
% xlim([0 550])
% % axis([0 max(t) 0.02 0.14]);

%%%%%%%%%%%%%
% Set variables for plotting (alternative to the removing outliers part)
midtrim = midtrim_init;
tt = (1:1:length(midtrim))';




%% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables

% Set estimates
b_0 = mean(midtrim(length(midtrim)-20: end)); % offset estimate
a_0 = mean(midtrim(1:5)) - b_0; % start point estimate
lamb_0 = 1/50.;
vars_0 = [a_0 lamb_0 b_0];

% Set bounds
lb = [0 0 0];
ub = [.2 1/5. .1];

% Define fit
myfittype = fittype('a*exp(-lamb*t)+b', 'dependent', {'y'},'independent', {'t'},...
    'coefficients', {'a','lamb', 'b'});

% Run fitting
myfit = fit(tt, midtrim, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0)
fit_coeffs = coeffvalues(myfit);
conf_ints = confint(myfit);
lifetime = 1/fit_coeffs(2)
lifetime_lb = 1/conf_ints(2,2)
lifetime_ub = 1/conf_ints(1,2)


% Manually designate points from fit (for plotting)
fit_points = fit_coeffs(1) * exp(-fit_coeffs(2) * tt) + fit_coeffs(3);

figure;
hold on

zero_x_vector = [0:5:1000, fliplr(0:5:1000)];
patch_zero = fill(zero_x_vector, [noise_max*ones(length(zero_x_vector)/2.,1)', ...
    0.033*ones(length(zero_x_vector)/2.,1)'], org, 'FaceAlpha', 0.2);
set(patch_zero, 'edgecolor', 'none');


plot_train = plot(tt, midtrim,'b.', 'Color', aqua, 'MarkerFaceColor', aqua, 'MarkerSize', 10);
% plot(myfit, 'r.')
% plot_fit = plot(tt, fit_points, 'r-', 'Color', pnk, 'LineWidth', 2.5);
% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);
axis([0 900 0.06 0.11]);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

% [lgd, lgd_icons] = legend([plot_train, plot_fit, patch_zero], ...
%     {'Training', 'Exp. fit', 'Noise floor'},...
%     'Location', 'northeast', 'FontSize', 16);
[lgd, lgd_icons] = legend([plot_train, patch_zero], ...
    {'Training', 'Noise floor'},...
    'Location', 'northeast', 'FontSize', 16);
patch_in_legend = findobj(lgd_icons, 'type', 'patch');
set(patch_in_legend, 'FaceAlpha', 0.3);


box on
hold off

