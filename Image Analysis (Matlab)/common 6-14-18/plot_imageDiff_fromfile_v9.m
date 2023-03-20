%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean image difference

%v4: Start using otsu filter. Also average plotting of xyDiff over multiple
%z layers to get averaged result
%v5: use a file list rather than looping through numbers
%v6: reduced size of xy stuff for 1-17-17 data
%v7: switched to bp difference rather than otsu 1-27-17
%v8: switch back to otsu. Change to process results of parallel processed
%images.
%v9: takes input from parallelized image difference code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import image difference data
folder = 'C:\Eric\Xerox Data\30um gap runs\5-21-18 data\1.4V\';
fileList = {'training'};
% fileList = {'train0', 'train50', 'train100', 'train150', 'train200', 'train300', 'train400'};
% fileList = {'waiting'};
% fileList = {'training_0', 'training_20', 'training_40', 'training_60', 'training_80', 'training_100',...
%     'training_200', 'training_300', 'training_400', };
folderEnd = '_imageDiff';

fileNumbers = 1:1:length(fileList);
numfiles = length(fileList);

% Declare cell array sizes.
filename = cell(numfiles,1);
filebase = cell(numfiles,1);
midpath = cell(numfiles,1);
mid = cell(numfiles,1);
legendInfo = cell(numfiles,1);

xydpath = cell(numfiles,1);
xyd = cell(numfiles,1);



for i = fileNumbers
    filename{i} = [folder, fileList{i}, folderEnd];
    
    midpath{i} = [filename{i} '\meanImageDiff_otsu.csv'];
    mid{i} = xlsread(midpath{i});
%     mid{i} = mid{i}(3:length(mid{i})-2);
    
    if i == 1
        midtotal = mid{i};
    else
        midtotal = cat(1,midtotal,mid{i});
    end
end

% % Trim off points before shear starts
% midtotal = midtotal(20:length(midtotal));


%% Plot full data set

figure;
t = 1:1:length(midtotal);
% t = t*2;
hold on
plot(t,midtotal,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);

% %Plot vertical lines
% for i = 1:1:numfiles-1
%     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% end 


title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Mean image difference','FontSize', 18);
ylim([0.02 0.1])
xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

% %% Log-Log plot
% % Note: can also just do this by editing the plot. (Tools, edit plot, click
% % ont the axes)
% 
% % Trim to only during shear
% tstart = 18;
% tend = length(t)-70;
% tTrim = t(tstart:tend);
% midtotalTrim = midtotal(tstart:tend);
% 
% % % Test trim
% % figure;
% % hold on
% % plot(tTrim,midtotalTrim,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% % hold off
% 
% % Log-Log data
% hold on
% tLog = log(tTrim);
% midtotalLog = log(midtotalTrim);
% plot(tLog,midtotalLog,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
% 
% title('Training','FontSize', 20);
% xlabel('Log(Shear cycles)','FontSize', 18);
% ylabel('Log(Mean image difference)','FontSize', 18);
% % axis([0 max(t) 0.02 0.1]);
% hold off
% 

% %% Plot all parts together (if split into multiple parts)
% % t = t*2;
% t = 1;
% figure;
% hold on
% plotStyle = ':o';
% map = colormap(jet);
% for i = fileNumbers
%     t = (max(t)+1):1:(max(t) + length(mid{i}));
%     plot(t, mid{i}, plotStyle, 'Color', map(i*6,:));
%     legendInfo{i} = ['mid ' num2str(i)];
% end
% % plot(t,mid{1},'b:o');
% % plot(t,mid{2},'c:o');
% % plot(t, mid{3}, 'r:o');
% 
% % plot(t, mid{4}, 'g:o');
% title('Mean difference between images vs time');
% xlabel('Shear cycles');
% ylabel('Mean difference between images');
% legend(legendInfo);
% % axis([0 max(t) 0.02 0.05]);
% hold off
% 
% sortedMidTotal = sort(midtotal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% XY difference over time for different heights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for i = fileNumbers
% %     xydpath{i} = [filebase{i} '_meanXYDiff_normalized_postbpass.csv'];
%     xydpath{i} = [filebase{i} '_meanXYDiff_otsu.csv'];
%     xyd{i} = xlsread(xydpath{i});
%     xyd{i} = xyd{i}(3:size(xyd{i},1)-2, :);
%     
%     if i == 1
%         xydtotal = xyd{i};
%     else
%         xydtotal = cat(1,xydtotal,xyd{i});
%     end
% end
% 
% figure;
% t = 1:1:size(xydtotal,1);
% t = t*2;
% heights_cell = {40:1:60, 90:1:110, 140:1:160, 190:1:210};
% labels = cell(length(heights_cell),1);
% hold on
% 
% for i = 1:1:length(heights_cell)
%     plot(t, mean(xydtotal(:,heights_cell{i}),2),plotStyle, 'Color', map(i*12,:))
%     labels{i} = ['zframe' num2str(mean(heights_cell{i}))];
% end
% 
% % % Plot vertical lines
% % for i = 1:1:numfiles-1
% %     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% % end 
% 
% title('Mean difference between images vs time');
% xlabel('Shear cycles');
% ylabel('Mean difference between images');
% legend(labels, 'Location', 'northeast');
% axis([0 max(t) 0.01 0.08]);
% hold off
% 
% % % Plotting individual layers without averaging
% 
% % figure;
% % t = 1:1:size(xydtotal,1);
% % t = t*4;
% % heights = [50, 100, 150, 200];
% % labels = cell(length(heights),1);
% % hold on
% % for i = 1:1:length(heights)
% %     plot(t, xydtotal(:,heights(i)),plotStyle, 'Color', map(i*12,:))
% %     labels{i} = ['zframe' num2str(heights(i))];
% % end
% % 
% % % % Plot vertical lines
% % % for i = 1:1:numfiles-1
% % %     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% % % end 
% % 
% % title('Mean difference between images vs time');
% % xlabel('Time (s)');
% % ylabel('Mean difference between images');
% % legend(labels, 'Location', 'northeast');
% % axis([0 250 0 0.15]);
% % hold off
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % XY difference over time for different heights using particle 'number'
% % normalization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for i = fileNumbers
%     xydpath{i} = [filebase{i} '_meanXYDiff_otsu_pnumberNorm.csv'];
%     xyd{i} = xlsread(xydpath{i});
%     xyd{i} = xyd{i}(3:size(xyd{i},1)-2, :);
%     
%     if i == 1
%         xydtotal = xyd{i};
%     else
%         xydtotal = cat(1,xydtotal,xyd{i});
%     end
% end
% 
% figure;
% t = 1:1:size(xydtotal,1);
% t = t*2;
% heights_cell = {40:1:60, 90:1:110, 140:1:160, 190:1:210};
% % heights_cell = {30:1:180};
% labels = cell(length(heights_cell),1);
% hold on
% 
% for i = 1:1:length(heights_cell)
%     plot(t, mean(xydtotal(:,heights_cell{i}),2),plotStyle, 'Color', map(i*12,:))
%     labels{i} = ['zframe' num2str(mean(heights_cell{i}))];
% end
% 
% % % Plot vertical lines
% % for i = 1:1:numfiles-1
% %     plot(ones(100,1) * length(mid{1})*6*i, 1:1:100, 'r--')
% % end 
% 
% title('Mean difference between images vs time');
% xlabel('Shear cycles');
% ylabel('Mean difference between images');
% legend(labels, 'Location', 'northwest');
% axis([0 max(t) 0 0.35]);
% hold off
