% nonlinear least squares exponential decay fit

% Define custom nonlinear fittype and use matlab's built in fit function
% for exponential decay with offset

% Author: Eric
% Date: 6-6-18


%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% folder = 'C:\Eric\Xerox Data\30um gap runs\6-14-19 data\0.6V\';
folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
fileList = {'training'};
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
fileList = {'train_ts1'};
folderEnd = '_imageDiff';
% folderEnd = '';

% Trim off points before shear starts and after it ends (mod1 edit)
%%%%%%%%%%%%%%%%%%%%%%% MANUAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tstart = 18;
% tend_trim = 42;

tstart = 20;
tend_trim = 40;
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
    
%     midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
    midpath{i} = [filename{i} '\' fileList{i} '_meanImageDiffCenter_otsu.csv'];
%     midpath{i} = [filename{i} '_meanImageDiffCenter_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

midtrim_init = midtotal(tstart:length(midtotal)-tend_trim);

% Plot patch for showing zero
figure;
hold on

zero_x_vector = [0:5:500, fliplr(0:5:500)];
patch_zero = fill(zero_x_vector, [noise_max*ones(length(zero_x_vector)/2.,1)', ...
    0.02*ones(length(zero_x_vector)/2.,1)'], org, 'FaceAlpha', 0.2);
set(patch_zero, 'edgecolor', 'none');


% Plot trimmed full data set
t = (1:1:length(midtrim_init))';
plot(t,midtrim_init,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference \langle\mid\DeltaI\mid\rangle','FontSize', 18);
% ylim([0.011 0.1])
% xlim([0 500])
axis([0 50 0.02 0.035]);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
box on
hold off

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
plot(tt, midtrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 10)
% plot(myfit, 'r.')
plot(tt, fit_points, 'r', 'LineWidth', 2)
% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off


