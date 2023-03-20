% Plot general code


vf = [.592, .594];
delta_ab = [.0080, .0114];
delta_80s = [.0038, .0033];
delta_50s = [.0031,.0025];

vf_2_25 = [.617];
delta_ab_2_25 = [.013];
delta_50s_2_25 = [.0044];

vf_2_14 = [.624];
delta_ab_2_14 = [.0031]; % don't trust
delta_50s_2_14 = [.0025];


vf_combined = [.592, .594, .617, .618, .624];
delta_ab_combined = [.0096, .0114, .013, .011, .0031];
delta_50s_combined = [.0031, .0025, .0044, .0030, .0025];

vf_combined_tiled = [.586, .601, .604, .607, .607, .626];
delta_ab_combined_tiled = [.078, .0096, .0113, .0114, .011, .0055];
delta_50s_combined_tiled = [.03, .0031, .0044, .0025, .0030, .0025];


% Volume fraction vs time data 
vf_peri = [.41, .55, .57, .6, .63, .64, .64];
time = [0, 27, 41, 68, 103, 169, 278];

vf_jolts = [.59, .59, .58, .58, .59, .58, .62, .61, .61];
time_jolts = [605, 612, 617, 842, 852, 862, 1659, 1668, 1676];

% Vertical line
vert_x = ones(1,100)*400;
vert_y = linspace(.4, .65);
% 
% % Individual data points. Volume fraction then Delta
% delta_ab = [
% %     .601, .0096; % 11-17-20 ts-3-5
% %     .607, .0114; % 11-17-20 ts-17-19
% %     .604, .013; % 2-25-20 ts-post-p5-1
% %     .607, .011; % 11-17-20 ts-42-44
% %     .626, .0055; % 9-23-21 ts-4-6
% %     .586, .090; % 12-7-21 ts-3-4
% %     .604, .045;  % 12-7-21 ts-8-9
% %     .585, .067; % 12-14-21 ts-5-6
% %     .630, .013; % 12-7-21 ts-28-29
%     .601, .0079 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0052 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)
% 
%     .585, .044; % 12-14-21 ts-5-6 relative positions
%     .607, .021; % 12-14-21 ts-13-14 relative positions
%     .586, .070; % 12-7-21 ts-3-4 relative positions
%     .607, .038;  % 12-7-21 ts-8-9 relative positions
%     .607, .029; % 12-7-21 ts-9-10 relative positions. Should maybe combine
%     .630, .010; % 12-7-21 ts-28-29 relative positions
%     ];
% %     .585, .038 % 12-14-21 ts-5-6 relative positions no outliers
% 
% delta = [
% %     .601, .0031; % 11-17-20 ts-3-5 
% %     .607, .0025; % 11-17-20 ts-17-19
% %     .604, .0044; % 2-25-20 ts-post-p5-1
% %     .607, .0030;  % 11-17-20 ts-42-44
% %     .626, .0025;  % 9-23-21 ts-4-6
% %     .586, .030;  % 12-7-21 ts-3-4
% %     .604, .019; % 12-7-21 ts-8
% %     .585, .033; % 12-14-21 ts-5-6
% %     .564, .056; % 12-7-21 ts-0
% %     .630, .0021; % 12-7-21 ts-28-29
%     .601, .0082 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0037 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)
% 
%     .555, .051; % 12-14-21 ts-0 relative positions
%     .585, .027; % 12-14-21 ts-5 and ts-6 relative positions
%     .607, .014; % 12-14-21 ts-14 relative positions
%     .564, .045; % 12-7-21 ts-0 relative positions
%     .586, .024; % 12-7-21 ts-3 and ts-4 relative positions
%     .606, .016; % 12-7-21 ts-8 and ts-9 relative positions
%     .630, .0023; % 12-7-21 ts-28 and ts-29 relative positions
%     ];

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

% Volume fraction and delta cutoff set 24px above bottome plate. Bootstrap
% error bars
delta_ab_yerr_bs = [
    .584, .0, .0; % 12-14-21 ts-4-5-6 relative positions
    .610, .0, .0; % 12-14-21 ts-12-13-14 relative positions
    .585, .0, .0; % 12-7-21 ts-3-4-5 relative positions
    .605, .0, .0;  % 12-7-21 ts-7-8-9-10 relative positions
    .623, .0, .0; % 12-7-21 ts-17-18-19 relative positions
    .633, .0, .0; % 12-7-21 ts-27-28-29 relative positions
    ];

% delta at 90s with bootstrap errorbars
delta_90_yerr_bs = [

    .584, .0, 0; % 12-14-21 ts-4-5-6 relative positions
    .610, .0, 0; % 12-14-21 ts-12-13-14 relative positions
    .585, .0, .0; % 12-7-21 ts-3-4-5 relative positions
    .606, .0, .0; % 12-7-21 ts-7-8-9-10 relative positions
    .623, .0, 0; % 12-7-21 ts-17-18-19 relative positions
    .630, .0, 0.0; % 12-7-21 ts-27-28-29 relative positions
    ];


% delta at 50s
delta = [
%     .601, .0024 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0012 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)

    .555, .060; % 12-14-21 ts-0 relative positions
    .584, .029; % 12-14-21 ts-5 and ts-6 relative positions
    .610, .014; % 12-14-21 ts-14 relative positions
    .565, .056; % 12-7-21 ts-0 relative positions
    .585, .025; % 12-7-21 ts-3 and ts-4 relative positions
    .606, .018; % 12-7-21 ts-8 and ts-9 relative positions
    .623, .0061; % 12-7-21 ts-18 relative positions
    .630, .0027; % 12-7-21 ts-28 and ts-29 relative positions
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

% Individual data points. Volume fraction then Delta
% Volume fraction for only big particles. Delta cutoff set 2um from
% bottom of image. Vol frac 24px above bottom plate.
delta_ab_big = [
%     .601, .0049 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .0045 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)

    .584, .051; % 12-14-21 ts-5-6 relative positions
    .610, .018; % 12-14-21 ts-12-13 and ts-13-14 relative positions
    .585, .060; % 12-7-21 ts-3-4 relative positions
    .605, .027;  % 12-7-21 ts-8-9-10 relative positions
    .633, .0078; % 12-7-21 ts-28-29 relative positions
    ];

delta_big = [
%     .601, .002 % % 12-14-21 ts-33-34 relative positions (DONT TRUST PHI)
%     .603, .001 % % 12-14-21 ts-43-44 relative positions (DONT TRUST PHI)

    .555, .039; % 12-14-21 ts-0 relative positions
    .584, .019; % 12-14-21 ts-5 and ts-6 relative positions
    .610, .0093; % 12-14-21 ts-14 relative positions
    .565, .032; % 12-7-21 ts-0 relative positions
    .585, .017; % 12-7-21 ts-3 and ts-4 relative positions
    .606, .012; % 12-7-21 ts-8 and ts-9 relative positions
    .630, .0019; % 12-7-21 ts-28 and ts-29 relative positions
    ];

pressures = [
    .564 8.3
    .585 9.1
    .604 12.7
    .609 12.3
    .630 22
    ];

% number of first neighbors. Single cycle mean of all with < 10 neighbors.
% center-to-center distance
mfn = [
    .581, 3.26; % 12-7-21 ts-3 frames 1-240
    .588, 3.12; % 12-7-21 ts-4 frames 1-240
    .605, 3.17; % 12-7-21 ts-8 frames 1-240
    .607, 2.95; % 12-7-21 ts-9 frames 1-240
    .625, 2.51; % 12-7-21 ts-18 frames 1-360
    .624, 2.69; % 12-7-21 ts-19 frames 1-360
    .634, 2.23; % 12-7-21 ts-28 frames 1-360
    .632, 2.17; % 12-7-21 ts-29 frames 1-360
    ];

% number of first neighbors. Between jolt mean of all with < 10 neighbors.
% Center-to-center distance
mfn_jolt = [
    .585, 3.95; % 12-7-21 ts-3-4 frames 1-240 each
    .593, 3.83; % 12-7-21 ts-4-5 frames 1-240 each
    .605, 3.54; % 12-7-21 ts-7-8 frames 1-240 each
    .606, 3.79; % 12-7-21 ts-8-9 frames 1-240 each
    .633, 2.56; % 12-7-21 ts-28-29 frames 1-360 each
    ];

% lines = zeros(1,2);
% % DELTA_AB
% lines(1)= plot(delta_ab(:,1), delta_ab(:,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% % DELTA (MSD)
% lines(2) =plot(delta(:,1), delta(:,2), 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');

% %%
% figure;
% hold on
% bar_pre = stairs(contacts, pdf_pre, 'b', 'LineWidth', 2);
% 
% bar_post = stairs(contacts, pdf_post, 'r', 'LineWidth', 2);
% 
% xlim([0 10])
% % ylim([0.13 0.26])

%%

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


figure;
% hold on;

% plot(vf_combined(1:4), delta_ab_combined(1:4), 'o', 'Color', blu, 'MarkerFaceColor', blu,...
%     'MarkerSize', 8, 'Displayname', '\Delta_{AB}')
% plot(vf_combined, delta_50s_combined, 'o', 'Color', red, 'MarkerFaceColor', red,...
%     'MarkerSize', 8, 'Displayname', '\Delta')

% plot(vf_combined_tiled, delta_ab_combined_tiled, 'o', 'Color', blu, 'MarkerFaceColor', blu,...
%     'MarkerSize', 8, 'Displayname', '\Delta_{AB}')
% plot(vf_combined_tiled, delta_50s_combined_tiled, 'o', 'Color', red, 'MarkerFaceColor', red,...
%     'MarkerSize', 8, 'Displayname', '\Delta')

% % Somewhat weird versoin where i plot each point independently. Using base
% % PERI volume fractions.
% lines = zeros(1,2);
% lines(1)= plot(.592, .0096, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}'); % 11-17-20 ts-3-5
% plot(.594, .0114, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 11-17-20 ts-17-19
% plot(.617, .013, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 2-25-20 ts-post-p5-1
% plot(.618, .011, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 11-17-20 ts-42-44
% plot(.624, .0031, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 2-14-20 ts-post-p5-1-2
% 
% lines(2) =plot(.592, .0031, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta'); % 11-17-20 ts-3-5
% plot(.594, .0025, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 11-17-20 ts-17-19
% plot(.617, .0044, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 2-25-20 ts-post-p5-1
% plot(.618, .0030, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 11-17-20 ts-42-44
% plot(.624, .0025, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 2-14-20 ts-post-p5-1-2

% % Somewhat weird versoin where i plot each point independently
% lines = zeros(1,2); % DELTA_AB
% lines(1)= plot(.601, .0096, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}'); % 11-17-20 ts-3-5
% plot(.607, .0114, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 11-17-20 ts-17-19
% plot(.604, .013, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 2-25-20 ts-post-p5-1
% plot(.607, .011, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 11-17-20 ts-42-44
% % plot(.620, .0031, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 2-14-20 ts-post-p5-1-2. Don't trust this point
% plot(.626, .0055, 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 9-23-21 ts-4-6
% plot(.586, .090, 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-7-21 ts-3-4
% plot(.604, .045, 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-7-21 ts-8-9
% plot(.585, .067, 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-14-21 ts-5-6
% plot(.630, .013, 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-7-21 ts-28-29
% plot(.585, .044, 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-14-21 ts-5-6 relative positions
% % plot(.585, .038, 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-14-21 ts-5-6 relative positions no outliers
% plot(.586, .070, 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8) % 12-7-21 ts-3-4 relative positions
% 
% % DELTA (MSD)
% lines(2) =plot(.601, .0031, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta'); % 11-17-20 ts-3-5
% plot(.607, .0025, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 11-17-20 ts-17-19
% plot(.604, .0044, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 2-25-20 ts-post-p5-1
% plot(.607, .0030, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 11-17-20 ts-42-44
% % plot(.620, .0025, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 2-14-20 ts-post-p5-1-2 Don't trust this point
% plot(.626, .0025, 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 9-23-21 ts-4-6
% plot(.586, .030, 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-3-4
% plot(.604, .019, 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-8
% plot(.585, .033, 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-14-21 ts-5-6
% plot(.564, .056, 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-0
% plot(.630, .0021, 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-28-29
% plot(.585, .027, 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-14-21 ts-5-6 relative positions
% plot(.586, .024, 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-3-4 relative positions
% plot(.564, .044, 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8) % 12-7-21 ts-0 relative positions


% most recent delta plotting %%%
hold on
% DELTA_AB
% lines(1)= plot(delta_ab(1:5,1), delta_ab(1:5,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% lines(1)=plot(delta_ab(6:9,1), delta_ab(6:9,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% lines(1)=plot(delta_ab(:,1), delta_ab(:,2), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
l1=errorbar(delta_ab_yerr(:,1), delta_ab_yerr(:,2), delta_ab_yerr(:,3), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');


% DELTA (MSD)
% lines(2) =plot(delta(1:5,1), delta(1:5,2), 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)= plot(delta(6:10,1), delta(6:10,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)=plot(delta(:,1), delta(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)=plot(delta_90(:,1), delta_90(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
l2=errorbar(delta_90_yerr(:,1), delta_90_yerr(:,2), delta_90_yerr(:,3), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');

% lines(3)=plot(delta_big(:,1), delta_big(:,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta_{big}');
% lines(4)=plot(delta_ab_big(:,1), delta_ab_big(:,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}_{big}');
% optional line to set to semilog
set(gca,'YScale','log');
% Try fixing negative errorbar
ylim manual
l2.LData = l2.YData - max(eps,l2.YData-l2.LData);
leg = legend([l1,l2], 'Location', 'northeast');

% hold on
% plot(pressures(:,1), pressures(1:5,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8);

% % mean first neighbors plotting
% hold on
% lines = zeros(1,2);
% % mfn_jolt
% lines(1)=plot(mfn_jolt(:,1), mfn_jolt(:,2), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', 'mfn jolt');
% 
% % mfn
% lines(2)=plot(mfn(:,1), mfn(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', 'mfn');
% 
% 
% leg = legend(lines, 'Location', 'northeast');

% plot(time, vf_peri, 'o', 'Color', blu, 'MarkerFaceColor', blu,...
%     'MarkerSize', 8, 'Displayname', 'Settling')
% plot(vert_x, vert_y, '-', 'Color', grn);
% plot(time_jolts, vf_jolts, 'o', 'Color', red, 'MarkerFaceColor', red,...
%     'MarkerSize', 8, 'Displayname', 'Jolts')

xlabel('Vol. Frac.','FontSize', 18);
ylabel('\mum^2', 'FontSize', 18);
% ylabel('Pressure (mPa)', 'FontSize', 18);

% title('Voronoi volume distribution','FontSize', 20);
% ylabel('Mean contact number \langlez\rangle','FontSize', 18);
% xlabel('Shear cycles', 'FontSize', 18);


% ylabel('Mean contact number \langlez\rangle','FontSize', 18);
% xlabel('Shear cycles', 'FontSize', 18);

% ylabel('Probability','FontSize', 18);
% xlabel('Voronoi volume (V/V_0)', 'FontSize', 18);


% xlim([1 7])
ylim([1e-3 1e-1])
% leg = legend('Location', 'northeast');

% set(leg, 'FontSize', 14)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

box on

hold off