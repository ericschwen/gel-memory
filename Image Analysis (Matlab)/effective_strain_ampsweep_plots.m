% effective strain ampsweep plots
%
% Read amplitude sweep and effective strain data from file. Files created
% by displacement_analysis_v3.py and strain_amp_calc_script.m (using
% strain_amp_calc_pcycle_v2.m). 
%
% Plot amplitude sweep comparison


% % 8-29-17 data
% eff_strain_paths = {'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\effective_strain_sweep.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\effective_strain_sweep.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained long\effective_strain_sweep.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\effective_strain_sweep.csv'};
% disp_vs_strain_paths = {'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\disp_vs_strain.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\disp_vs_strain.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained long\disp_vs_strain.csv',...
%     'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\disp_vs_strain.csv'};

% 1-6-18 data
eff_strain_paths = {'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\effective_strain_sweep.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\effective_strain_sweep.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained 1.0\effective_strain_sweep.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained 0.6\effective_strain_sweep.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained delayed\effective_strain_sweep.csv'};
disp_vs_strain_paths = {'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\disp_vs_strain.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\0.6V\disp_vs_strain.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained 1.0\disp_vs_strain.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained 0.6\disp_vs_strain.csv',...
    'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained delayed\disp_vs_strain.csv'};

eff_strain_data = cell(length(eff_strain_paths),1);
disp_data = cell(length(eff_strain_paths),1);
displacements = cell(length(eff_strain_paths),1);
eff_strains = cell(length(eff_strain_paths),1);

for i = 1:length(eff_strain_paths)
    eff_strain_data{i} = xlsread(eff_strain_paths{i});
    disp_data{i} = xlsread(disp_vs_strain_paths{i});
    displacements{i} = disp_data{i}(:,1);
    eff_strains{i} = eff_strain_data{i}(:,6);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot ampsweep data with vertical line at training amplitude


figure;
hold on;
plot(eff_strains{1}(1:end-2), displacements{1}(1:end-2),'r:o', 'MarkerFaceColor', 'r','DisplayName', 'After training')

% plot(eff_strains{2}(1:end-1), displacements{2}(1:end-1),'r:o','MarkerFaceColor', 'r')
% legendInfo{2} = '0.6V';
plot(eff_strains{3}(1:end-2), displacements{3}(1:end-2),'b:o','MarkerFaceColor', 'b', 'DisplayName', 'Before training')

% plot(eff_strains{4}(1:end-1), displacements{4}(1:end-1),'r:o','MarkerFaceColor', 'c')
% legendInfo{4} = 'U0.6';
% plot(eff_strains{5}(1:end-1), displacements{5}(1:end-1),'r:o','MarkerFaceColor', 'y')
% legendInfo{5} = 'U Del';

% plot(eff_strains{3}(1:end-1), displacements{3}(1:end-1),'r:o','MarkerFaceColor', 'r')
% legendInfo{2} = 'After training';

title('Strain Amplitude Sweeps','FontSize', 20);
% xlabel('Effective strain \gamma_{eff}','FontSize', 18);
xlabel('Strain \gamma','FontSize', 18);
ylabel('Mean displacement (\mum)','FontSize', 18);

% Plot vertical line for training amplitude
trainingAmplitude = 0.133;
plot(ones(100,1) * trainingAmplitude, 0.004:0.004:0.4, 'g--', 'DisplayName', 'Training strain \gamma_0');

xlim([0 0.3])
ylim([0.1 0.3])
leg = legend('Location', 'northwest');
set(leg, 'FontSize', 16)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off