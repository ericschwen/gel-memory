% subplots
%
% Basic code for plotting a graph with a subplot. Import data or use
% with data already in workspace.

% Colors

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;

options.line_width = 1.0;
mean_diameter = 1.85;



figure;
ax1 = gca;
hold(ax1, 'on')
plot_trackpy_post = plot((norm_gr_trackpy_avg_post(1:end-1,1)-dr/2)/mean_diameter, norm_gr_trackpy_avg_post(1:end-1, 2), ':', ...
    'Color', blu, 'Marker', '.', 'MarkerFaceColor', blu, 'MarkerSize', 20, ...
    'LineWidth', options.line_width);
plot_trackpy_pre = plot((norm_gr_trackpy_avg_pre(1:end-1,1)-dr/2)/mean_diameter, norm_gr_trackpy_avg_pre(1:end-1, 2), ':', ...
    'Color', pur, 'Marker', '.', 'MarkerFaceColor', pur, 'MarkerSize', 20, ...
    'LineWidth', options.line_width);

lgd = legend([plot_trackpy_pre, plot_trackpy_post], {'Untrained', 'Trained'}, 'Location', 'southeast', 'FontSize', 12);
xlabel('r/2a');
ylabel('g(r)');
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on
% axis([0 0.4 0.02 0.16]);

% ax2 = axes('Position',[.55 .22 .3 .25]);
ax2 = axes('Position',[.55 .65 .3 .25]);
hold(ax2,'on')
% axis([0 0.12 0.02 0.05]);
plot_trackpy_post = plot((norm_gr_peri_avg_post(1:end-1,1)-dr/2)/mean_diameter, norm_gr_peri_avg_post(1:end-1, 2), ':', ...
    'Color', blu, 'Marker', '.', 'MarkerFaceColor', blu, 'MarkerSize', 12, ...
    'LineWidth', options.line_width);
plot_trackpy_pre = plot((norm_gr_peri_avg_pre(1:end-1,1)-dr/2)/mean_diameter, norm_gr_peri_avg_pre(1:end-1, 2), ':', ...
    'Color', pur, 'Marker', '.', 'MarkerFaceColor', pur, 'MarkerSize', 12, ...
    'LineWidth', options.line_width);
box on