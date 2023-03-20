% training_plotting_pretty
%
% Plot the gel training plot in a pretty way for the figures.
% 
% Mod History:
% v1_mod1: change start point to work with data without pauses 4-11-17,
% etc. (1-29-18)
%
% Date: 1-19-18
% Author: Eric Schwen

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %% Import image difference data
% % folder = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\';
% % folder = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\';
% % fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
% 
% folder = 'D:\Xerox Data\30um gap runs\5-21-18 data\0.6V orthogonal\';
% % folder = 'C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\';
% fileList = {'training'};
% 
% folderEnd = '_imageDiff';
% 
% fileNumbers = 1:1:length(fileList);
% numfiles = length(fileList);
% 
% % Declare cell array sizes.
% filename = cell(numfiles,1);
% filebase = cell(numfiles,1);
% midpath = cell(numfiles,1);
% mid = cell(numfiles,1);
% legendInfo = cell(numfiles,1);
% 
% for i = fileNumbers
%     filename{i} = [folder, fileList{i}, folderEnd];
%     
%     midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
%     
%     mid{i} = xlsread(midpath{i});
% %     mid{i} = mid{i}(3:length(mid{i})-2);
%     
%     if i == 1
%         midtotal = mid{i};
%     else
%         midtotal = cat(1,midtotal,mid{i});
%     end
% end
% 
% % Trim off points before shear starts (mod1 edit)
% % also trim end points
% tstart = 9;
% tend_trim = 42;
% midtotal = midtotal(tstart:length(midtotal)-tend_trim);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Old file version (SAVE DATA)

folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\0.4V\';
% folder = 'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\1.8V\';
fileList = {'train_ts1', 'train_ts2'};

folderEnd = '';

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
%     midpath{i} = [filename{i} '_meanXYDiff_otsu.csv'];
    midpath{i} = [filename{i} '_meanImageDiffCenter_otsu.csv'];
    
    mid{i} = xlsread(midpath{i});
    
    % extra line for averaging meanXYDiff only (otherwise takes only first slice)
    if length(midpath{i}) == length([filename{i} '_meanXYDiff_otsu.csv'])
        mid{i} = mean(mid{i},2);
    end
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

% Trim off points before shear starts (mod1 edit)
% also trim end points
tstart = 20;
tend_trim = 500;
% tend_trim = 498;
midtotal = midtotal(tstart:length(midtotal)-tend_trim);


%% Plot full data set
figure;
t = (1:1:length(midtotal))';
% t = t*2;
hold on
plot(t,midtotal,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

% %Plot vertical lines
% for i = 1:1:numfiles-1
%     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% end 

% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean image difference','FontSize', 18);
ylabel('\langle\mid\DeltaI\mid\rangle','FontSize', 18);
% ylim([0.02 0.05])
xlim([0 400])
% xticks([0.0:0.1:0.4])
yticks([0.02:0.01:0.5]);

box on

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old file version (SAVE DATA)
% 
% folder = 'E:\30um gap runs 1-17 -- 2-17\0.5Hz combined gel runs 1-17-17\1.4V\';
% fileList = {'train_ts1', 'train_ts2'};
% 
% folderEnd = '';
% 
% fileNumbers = 1:1:length(fileList);
% numfiles = length(fileList);
% 
% % Declare cell array sizes.
% filename = cell(numfiles,1);
% filebase = cell(numfiles,1);
% midpath = cell(numfiles,1);
% mid = cell(numfiles,1);
% legendInfo = cell(numfiles,1);
% 
% for i = 2
%     filename{i} = [folder, fileList{i}, folderEnd];
%     
% %     midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
%     midpath{i} = [filename{i} '_meanxYDiff_otsu.csv'];
%     
%     mid{i} = xlsread(midpath{i});
% %     mid{i} = mid{i}(3:length(mid{i})-2);
%     
%     if i == i
%         midtotal = mid{i};
%     else
%         midtotal = cat(1,midtotal,mid{i});
%     end
% end
% meanImageDiff = zeros(length(midtotal),1);
% 
% for tframe = 1:1:length(midtotal)
% %     center_section = zini + uint32(zsiz/4):1:zfin - uint32(zsiz/4);
%     meanImageDiff(tframe) = mean(midtotal(tframe,:));
% end
% 
% 
% meanImageDiffpath = [folder fileList{i} '_meanImageDiff_otsu.csv'];
% 
% csvwrite(meanImageDiffpath, meanImageDiff);
% 
% % % Trim off points before shear starts (mod1 edit)
% % % also trim end points
% % tstart = 18;
% % tend_trim = 42;
% % midtotal = midtotal(tstart:length(midtotal)-tend_trim);