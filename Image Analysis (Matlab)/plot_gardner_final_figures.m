% Plot gardner figures. Each section is its own figure.


red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;
aqua = [0, 51, 0]/255.;
yel = [255,255,51]/255.;
pnk = [231,41,138]/255.;
lgrn = [102,166,30]/255.;

%% Plot deltas with error bars

% Individual data points. Volume fraction then Delta
% Volume fraction and delta cutoff set 24px above bottome plate
delta_ab = [
%     .601, .0063 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0029 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)

    .584, .073; % 12-14-21 ts-4-5-6 relative positions
    .610, .024; % 12-14-21 ts-13-14 relative positions
    .585, .058; % 12-7-21 ts-3-4 relative positions
    .605, .034;  % 12-7-21 ts-8-9-10 relative positions
    .623, .015; % 12-7-21 ts-18 relative positions
    .633, .01; % 12-7-21 ts-28-29 relative positions
    ];

% Volume fraction and delta cutoff set 24px above bottome plate with rough
% errobars
delta_ab_yerr = [
%     .601, .0063 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0029 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)

    .584, .073, 0; % 12-14-21 ts-4-5-6 relative positions
    .610, .024, 0; % 12-14-21 ts-13-14 relative positions
    .585, .058, .011; % 12-7-21 ts-3-4 relative positions
    .605, .034, 0;  % 12-7-21 ts-8-9-10 relative positions
    .623, .015, 0; % 12-7-21 ts-18 relative positions
    .633, .01, .005; % 12-7-21 ts-28-29 relative positions
    ];

% delta at 90s
delta_90 = [

    .584, .035; % 12-14-21 ts-6 relative positions
    .610, .018; % 12-14-21 ts-14 relative positions
    .585, .034; % 12-7-21 ts-3 and ts-4 relative positions
    .606, .022; % 12-7-21 ts-8 and ts-9 relative positions
    .623, .0074; % 12-7-21 ts-18 relative positions
    .630, .0027; % 12-7-21 ts-28 and ts-29 relative positions
    ];
    

% delta at 90s with rough errorbars
delta_90_yerr = [

    .584, .035, 0; % 12-14-21 ts-6 relative positions
    .610, .018, 0; % 12-14-21 ts-14 relative positions
    .585, .034, .008; % 12-7-21 ts-3 and ts-4 relative positions
    .606, .022, .008; % 12-7-21 ts-8 and ts-9 relative positions
    .623, .0074, 0; % 12-7-21 ts-18 relative positions
    .630, .0027, 0.004; % 12-7-21 ts-28 and ts-29 relative positions
    ];

% Volume fraction and delta cutoff set 24px above bottome plate.
% error bars from std from t_w variation
delta_ab_yerr_t = [
    .584, .068, .008; % 12-14-21 ts-4-5-6 relative positions
    .610, .027, .003; % 12-14-21 ts-12-13-14 relative positions
    .589, .062, .010; % 12-7-21 ts-3-4-5 relative positions
    .605, .034, .006;  % 12-7-21 ts-8-9-10 relative positions
    .624, .016, .0014; % 12-7-21 ts-17-18-19 relative positions
    .632, .0099, .0011; % 12-7-21 ts-27-28-29 relative positions
    ];

% delta at 90s with error bars from std from t variation
delta_90_yerr_tw = [

    .584, .040, .005; % 12-14-21 ts-4-5-6 relative positions
    .610, .018, .002; % 12-14-21 ts-12-13-14 relative positions
    .589, .032, .004; % 12-7-21 ts-3-4-5 relative positions
    .605, .020, .003; % 12-7-21 ts-8-9-10 relative positions
    .624, .0088, .0013; % 12-7-21 ts-17-18-19 relative positions
    .632, .0032, .0012; % 12-7-21 ts-27-28-29 relative positions
    ];


hold on
% DELTA_AB
% lines(1)= plot(delta_ab(1:5,1), delta_ab(1:5,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% lines(1)=plot(delta_ab(6:9,1), delta_ab(6:9,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% lines(1)=plot(delta_ab(:,1), delta_ab(:,2), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% l1=errorbar(delta_ab_yerr(:,1), delta_ab_yerr(:,2), delta_ab_yerr(:,3), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
l1=errorbar(delta_ab_yerr_t(:,1), delta_ab_yerr_t(:,2), delta_ab_yerr_t(:,3), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');


% DELTA (MSD)
% lines(2) =plot(delta(1:5,1), delta(1:5,2), 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)= plot(delta(6:10,1), delta(6:10,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)=plot(delta(:,1), delta(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)=plot(delta_90(:,1), delta_90(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% l2=errorbar(delta_90_yerr(:,1), delta_90_yerr(:,2), delta_90_yerr(:,3), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
l2=errorbar(delta_90_yerr_tw(:,1), delta_90_yerr_tw(:,2), delta_90_yerr_tw(:,3), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');

% lines(3)=plot(delta_big(:,1), delta_big(:,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta_{big}');
% lines(4)=plot(delta_ab_big(:,1), delta_ab_big(:,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}_{big}');
% optional line to set to semilog
set(gca,'YScale','log');
% Try fixing negative errorbar
ylim manual
l2.LData = l2.YData - max(eps,l2.YData-l2.LData);
leg = legend([l1,l2], 'Location', 'northeast');

xlabel('Volume fraction \phi','FontSize', 18);
ylabel('\mum^2', 'FontSize', 18);

ylim([1e-3 1e-1])
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

box on

hold off

%%
% Plot mean caging neighbors

% number of first neighbors. Single cycle mean of all with >1 and < 16 neighbors
% surface separation
mfn_sep = [
    .581, 6.52; % 12-7-21 ts-3 frames 1-240
    .588, 6.44; % 12-7-21 ts-4 frames 1-240
    .605, 5.99; % 12-7-21 ts-8 frames 1-240
    .607, 5.83; % 12-7-21 ts-9 frames 1-240
    .622, 4.87; % 12-7-21 ts-17 frames 1-240
    .625, 4.75; % 12-7-21 ts-18 frames 1-240
    .624, 4.70; % 12-7-21 ts-19 frames 1-240
    .630, 3.61; % 12-7-21 ts-27 frames 1-240
    .634, 3.57; % 12-7-21 ts-28 frames 1-240
    .632, 3.67; % 12-7-21 ts-29 frames 1-240
    ];

% number of first neighbors. Between jolt mean of all with >1 and < 16 neighbors
% surface separation
mfn_jolt_sep = [
    .585, 8.57; % 12-7-21 ts-3-4 frames 1-240 each
    .593, 8.04; % 12-7-21 ts-4-5 frames 1-240 each
    .605, 6.78; % 12-7-21 ts-7-8 frames 1-240 each
    .606, 7.31; % 12-7-21 ts-8-9 frames 1-240 each
    .624, 6.26; % 12-7-21 ts-17-18 frames 1-360 each
    .625, 5.74; % 12-7-21 ts-18-19 frames 1-360 each
    .632, 4.46; % 12-7-21 ts-27-28 frames 1-360 each
    .633, 4.41; % 12-7-21 ts-28-29 frames 1-360 each
    ];

% number of first neighbors. Between jolt mean of all with >1 and < 16 neighbors
% surface separation. Averaged
mfn_sep_avg = [
%     .584, 0, 0; % 12-14-21 ts-4-5-6 relative positions
%     .610, 0, 0; % 12-14-21 ts-12-13-14 relative positions
    .589, 6.45, 1.95; % 12-7-21 ts-3-4-5 relative positions
    .605, 5.94, 1.85; % 12-7-21 ts-8-9-10 relative positions
    .624, 4.78, 1.61; % 12-7-21 ts-17-18-19 relative positions
    .632, 3.62, 1.34; % 12-7-21 ts-27-28-29 relative positions
    ];

% number of first neighbors. Between jolt mean of all with >1 and < 16 neighbors
% surface separation. averaged
mfn_jolt_sep_avg = [
%     .584, 0, 0; % 12-14-21 ts-4-5-6 relative positions
%     .610, 0, 0; % 12-14-21 ts-12-13-14 relative positions
    .589, 8.28, 3.18; % 12-7-21 ts-3-4-5 relative positions
    .605, 7.27, 2.44; % 12-7-21 ts-8-9-10 relative positions
    .624, 5.78, 1.90; % 12-7-21 ts-17-18-19 relative positions
    .632, 4.26, 1.61; % 12-7-21 ts-27-28-29 relative positions
    ];

figure;
hold on

% patches to fill between error bars
patch1 = fill([mfn_sep_avg(:,1); flipud(mfn_sep_avg(:,1))], ...
    [mfn_sep_avg(:,2)+mfn_sep_avg(:,3);flipud(mfn_sep_avg(:,2)-mfn_sep_avg(:,3))], org);
set(patch1, 'edgecolor', 'none');
set(patch1, 'FaceAlpha', 0.2);
% 
patch2 = fill([mfn_jolt_sep_avg(:,1); flipud(mfn_jolt_sep_avg(:,1))], ...
    [mfn_jolt_sep_avg(:,2)+mfn_jolt_sep_avg(:,3);flipud(mfn_jolt_sep_avg(:,2)-mfn_jolt_sep_avg(:,3))], blu);
set(patch2, 'edgecolor', 'none');
set(patch2, 'FaceAlpha', 0.2);

l1=errorbar(mfn_sep_avg(:,1), mfn_sep_avg(:,2), mfn_sep_avg(:,3), 's', ...
    'Color', org, 'MarkerFaceColor', org, 'MarkerSize', 8, 'LineWidth', 1.5, 'Displayname', '|A|');
l2=errorbar(mfn_jolt_sep_avg(:,1), mfn_jolt_sep_avg(:,2), mfn_jolt_sep_avg(:,3), 's', ...
    'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'LineWidth', 1.5, 'Displayname', '|A\cupB|');



leg = legend([l1,l2], 'Location', 'northeast');
% leg = legend([l1], 'Location', 'northeast');
xlabel('Volume fraction \phi','FontSize', 18);
ylabel('Mean caging neighbors', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
box on
hold off
% leg = legend(lines, 'Location', 'northeast');

% hold on
% lines = zeros(1,2);
% % mfn_jolt
% lines(1)=plot(mfn_jolt_sep(:,1), mfn_jolt_sep(:,2), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '|A\cupB|');
% % mfn
% lines(2)=plot(mfn_sep(:,1), mfn_sep(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '|A|');
% 
% l1=errorbar(delta_ab_yerr_t(:,1), delta_ab_yerr_t(:,2), delta_ab_yerr_t(:,3), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% xlabel('Volume fraction \phi','FontSize', 18);
% ylabel('Mean caging neighbors', 'FontSize', 18);
% 
% 
% % xlim([1 7])
% % ylim([1e-3 1e-1])
% leg = legend('Location', 'northeast');
% 
% % set(leg, 'FontSize', 14)
% 
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% box on
% hold off



%% Plot jaccard index

% Mean jaccard index of first neighbors after jolt (limits:
% 1<neighbors<16). Should probably combine and average some.
% surface separation
jaccard_mean = [
    .585, 0.353; % 12-7-21 ts-3-4 frames 1-240 each
    .593, 0.527; % 12-7-21 ts-4-5 frames 1-240 each
    .605, 0.561; % 12-7-21 ts-7-8 frames 1-240 each
    .606, 0.517; % 12-7-21 ts-8-9 frames 1-240 each
    .624, 0.521; % 12-7-21 ts-17-18 frames 1-360 each
    .625, 0.690; % 12-7-21 ts-18-19 frames 1-360 each
    .632, 0.630; % 12-7-21 ts-27-28 frames 1-360 each
    .633, 0.639; % 12-7-21 ts-28-29 frames 1-360 each
    ];

jaccard_mean_err = [
%     .584, 0, 0; % 12-14-21 ts-4-5-6 relative positions
%     .610, 0, 0; % 12-14-21 ts-12-13-14 relative positions
    .589, .45, .24; % 12-7-21 ts-3-4-5 relative positions
    .605, .58, .22; % 12-7-21 ts-8-9-10 relative positions
    .624, .58, .26; % 12-7-21 ts-17-18-19 relative positions
    .632, .63, .25; % 12-7-21 ts-27-28-29 relative positions
    ];

figure;
hold on

patch1 = fill([jaccard_mean_err(:,1); flipud(jaccard_mean_err(:,1))], ...
    [jaccard_mean_err(:,2)+jaccard_mean_err(:,3);flipud(jaccard_mean_err(:,2)-jaccard_mean_err(:,3))], grn);
set(patch1, 'edgecolor', 'none');
set(patch1, 'FaceAlpha', 0.2);


l1=errorbar(jaccard_mean_err(:,1), jaccard_mean_err(:,2), jaccard_mean_err(:,3), 's', ...
    'Color', grn, 'MarkerFaceColor', grn, 'MarkerSize', 8, 'LineWidth', 1.5, 'Displayname', '|A|');



% plot(jaccard_mean(:,1),jaccard_mean(:,2), 's', ...
%     'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', 'mfn jolt');


% set(gca,'YScale','log');
xlabel('Volume fraction \phi','FontSize', 18);
% ylabel('\mum^2', 'FontSize', 18);
% ylabel('Mean first neighbors', 'FontSize', 18);
% ylabel('First neighbor overlap frac.', 'FontSize', 18);
ylabel('Mean jaccard index', 'FontSize', 18);

% xlim([1 7])
ylim([.0 1])
% leg = legend('Location', 'northeast');

% set(leg, 'FontSize', 14)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

box on

hold off
