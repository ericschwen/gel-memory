% g(r) plot from file
%
% import data from trackpy created by gr_save.py

gr_data = xlsread('C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_post_train_bpass3D_o5\200\gr.csv');
% edges_px = gr_data(:,1);
% edges_um = gr_data(:,2);
% g_r = gr_data(:,3);
gr_data_pre = xlsread('C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200\gr.csv');

figure;
hold on;
plot(gr_data_pre(:,2)/2, gr_data_pre(:,3),'b:.', 'MarkerFaceColor', 'b', 'MarkerSize', 18)
legendInfo{1} = 'Before training';
plot(gr_data(:,2)/2, gr_data(:,3),'r:.', 'MarkerFaceColor', 'r', 'MarkerSize', 18)
legendInfo{2} = 'After training';


title('3D pair distribution','FontSize', 20);
xlabel('r/2a','FontSize', 18);
ylabel('g(r)','FontSize', 18);

xlim([0 3])
% ylim([0.1 0.4])


leg = legend(legendInfo, 'Location', 'northeast');
set(leg, 'FontSize', 16)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

hold off