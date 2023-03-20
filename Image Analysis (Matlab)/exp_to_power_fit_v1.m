% exp_to_power_fit

% Define custom nonlinear fittype and use matlab's built in fit function
% for crossover from exponential decay to power law with offset.

% mod history:
%   v1: base is working. just fit to coefficients for offset rather than
%       using 0 and inf values. 10-17-18
%   v2:
% 
% 
% Author: Eric
% Date: 6-6-18


%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
folder = 'C:\Eric\Xerox Data\30um gap runs\6-28-18 data\0.6V\';
fileList = {'training'};
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
% fileList = {'train_ts1', 'train_ts2'};
folderEnd = '_imageDiff';

% Trim off points before shear starts and after it ends (mod1 edit)
%%%%%%%%%%%%%%%%%%%%%%% MANUAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tstart = 11;
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
    
    midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
%     midpath{i} = [filename{i} '\' fileList{i} '_meanImageDiffCenter_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end


midtrim_init = midtotal(tstart:length(midtotal)-tend_trim);

% Plot full data set
figure;
t = (1:1:length(midtrim_init))';
% t = t*2;
hold on
plot(t,midtrim_init,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

% %%% remove extreme outliers (not actual data points anyway)
% midtrim = midtrim_init;
% for i=length(midtrim_init):-1:1
%     if midtrim_init(i) > 0.6
%         midtrim(i) = [];
%     end
% end
% tt = (1:1:length(midtrim))';

%%%%%%%%%%%%%
% Set variables for plotting (alternative to the removing outliers part)
midtrim = midtrim_init;
tt = (1:1:length(midtrim))';




%% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables

% Set estimates
b_0 = mean(midtrim(length(midtrim)-20: end)); % offset estimate
a_0 = mean(midtrim(1:5)) - b_0; % start point estimate
lamb_0 = 1/50.;
delt_0 = 0.25;
vars_0 = [a_0 lamb_0 delt_0 b_0];

% Set bounds
lb = [0 0 0 0];
ub = [.2 1/5. 2 .1];

% Define fit
myfittype = fittype('a*exp(-lamb*t)/t^delt+b', 'dependent', {'y'},'independent', {'t'},...
    'coefficients', {'a','lamb', 'delt', 'b'});


% myfittype = fittype('a*exp(-lamb*t)+b', 'dependent', {'y'},'independent', {'t'},...
%     'coefficients', {'a','lamb', 'b'});

% Run fitting
myfit = fit(tt, midtrim, myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0)
fit_coeffs = coeffvalues(myfit);
conf_ints = confint(myfit);
lifetime = 1/fit_coeffs(2)
lifetime_lb = 1/conf_ints(2,2)
lifetime_ub = 1/conf_ints(1,2)

% Extract values for expected mid_0 and mid_inf from fit
% should have a = mid_0 - mid_inf
% should ahve b = mid_inf
mid_inf = fit_coeffs(4);
mid_0 = fit_coeffs(1) + fit_coeffs(4);



% Manually designate points from fit (for plotting)
fit_points = fit_coeffs(1) * exp(-fit_coeffs(2) * tt)./tt.^fit_coeffs(3) + fit_coeffs(4);

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
