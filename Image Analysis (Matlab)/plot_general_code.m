% Mean contact number over time

% data_path = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\pauses_disp_vs_cycle.csv';
% data = xlsread(data_path);

% cycles = [0,50,100,150,200,300,400,500];
% contact_num_means = [3.78,3.95,3.9,3.95,4.00,4.13,4.15,4.11];

% % 8-29-17 contact number dist 2.5 um
% bin_edges = [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14];
% untrained = [ 0.01132713,  0.05071851,  0.12003381,  0.21352494,  0.2591716 ,...
%         0.20371936,  0.10177515,  0.03347422,  0.00540997,  0.00084531,...
%         0.        ,  0.        ,  0.        ];
% trained =[ 0.00826841,  0.03291461,  0.08284306,  0.15280649,  0.21863571,...
%         0.23580855,  0.15900779,  0.07727779,  0.02528224,  0.0060423 ,...
%         0.00111305,  0.        ,  0.        ];

% % 1-6-18 peri contact number dist 2.1 um
% bin_edges = [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14];
% untrained = [ 0.00263852,  0.10290237,  0.24274406,  0.36939314,  0.16886544,...
%         0.08970976,  0.01055409,  0.01055409,  0.        ,  0.00263852,...
%         0.        ,  0.        ,  0.        ];
% trained =[ 0.00968523,  0.05326877,  0.1937046 ,  0.27845036,  0.2566586 ,...
%         0.13559322,  0.05326877,  0.00968523,  0.00968523,  0.        ,...
%         0.        ,  0.        ,  0.        ];


% m_contacts_mobile = [3.65,3.5,3.68,3.84,3.61,3.47,3.36,4.20];
% m_contacts_immobile = [3.9,3.96,3.99,4.01,4.04,3.99,3.9,4.00];

% % %%% Mean contacts mobile vs immobile peri 2.5um c2c
% m_contacts_mobile = [6.32, 5.73, 5.95, 5.75, 6.15];
% m_contacts_immobile = [6.6, 6.41, 6.42, 6.26, 6.40];

% % %% Mean contacts mobile vs immobile peri 2.1um c2c
% m_contacts_mobile = [3.29, 3.35, 3.37, 3.32, 3.45];
% m_contacts_immobile = [3.8, 3.83, 3.58, 3.62, 3.63];

% %%% Mean contacts mobile vs immobile peri 0.1um surface sep (3-20-19)
% m_contacts_mobile = [2.59 2.65 2.55 2.64 2.64];
% m_contacts_immobile = [3.8 3.22 2.75 2.88 2.75];

% %%% Mean contacts mobile vs immobile peri 0.05um surface sep (4-9-19)
m_contacts_mobile = [1.88 1.98 1.76 2.03 1.82];
m_contacts_immobile = [3.2 2.44 1.98 2.04 2.07];

% %%% Mean contacts mobile vs immobile peri 0.03um surface sep (4-9-19)
% m_contacts_mobile = [1.60 1.53 1.24 1.86 1.64];
% m_contacts_immobile = [3.0 1.97 1.53 1.77 1.73];

%%% Mean contacts mobile vs immobile peri 0.1um surface sep (10-4-18)
% m_contacts_mobile = [2.28, 2.22, 2.21, 2.39, 2.27];
% m_contacts_immobile = [3.4, 2.78, 2.32, 2.44, 2.28];

% % % % Mean contacts mobile vs immobile peri 0.2um surface sep (10-4-18)
% m_contacts_mobile = [3.8, 3.75, 3.28, 3.22, 3.36];
% m_contacts_immobile = [3.06, 3.12, 3.16, 3.11, 2.94];



m_vv_mobile = [14.3, 14.4, 13.9, 13.8, 13.7]/3.31;
m_vv_immobile = [13.7, 13.3, 13.7, 13.1, 13.5]/3.31;
cycles = [0,50,100,150,200];

vv_edges = 1:0.25:7;
pdf_vv_norm_post = [...
    0         0         0    0.0004    0.0017    0.0090    0.0453    0.0893 ...
    0.1393    0.1640    0.1619    0.1239    0.0859    0.0683    0.0466    0.0286 ...
    0.0154    0.0094    0.0060    0.0021    0.0013    0.0013    0.0004         0];

pdf_vv_norm_pre = [...
         0         0         0         0    0.0009    0.0061    0.0179    0.0442...
    0.0936    0.1288    0.1439    0.1345    0.1077    0.0964    0.0752    0.0536...
    0.0400    0.0188    0.0155    0.0099    0.0047    0.0038    0.0028    0.0014];

% % 0.6V full stack contact distribution data
% contacts = [0,1,2,3,4,5,6,7,8,9,10,11];
% pdf_pre = [0.00545564760558,...
% 0.0343503738129,...
% 0.102040816327,...
% 0.210143463326,...
% 0.270559709032,...
% 0.219842392403,...
% 0.11234592847,...
% 0.038189533239,...
% 0.00606183067286,...
% 0.00101030511214,...
% 0.0,...
% 0.0,...
% 0.0];
% pdf_post = [0.00446677833613,...
% 0.0187976921645,...
% 0.0668155592779,...
% 0.148148148148,...
% 0.226502884794,...
% 0.249767355295,...
% 0.172157081705,...
% 0.0804020100503,...
% 0.0256839754327,...
% 0.00614182021217,...
% 0.00111669458403,...
% 0.0,...
% 0.0];
% 

% % 0.6V peri contact distribution
bin_edges = [0,1,2,3,4,5,6,7,8,9,10,11];
%%% 30 nm surface separation
% pdf_pre = [ 0.17  , 0.33  , 0.29 ,  0.135 , 0.07   ,0.   ,  0.  ,   0.  ,   0. ,    0.     ,0.005];
% pdf_post = [ 0.06451613 , 0.21658986 , 0.40552995 , 0.22119816 ,0.05529954,  0.01843318,...
%   0.00460829 , 0.00921659  ,0.00460829  ,0.   ,       0.        ];

%%% 50 nm surface separation
pdf_pre = [ 0.1  ,  0.28 ,  0.35 ,  0.16 ,  0.105,  0.   ,  0.   ,  0.   ,...
        0.   ,  0.   ,  0.005];
pdf_post = [ 0.01382488,  0.13824885 , 0.41474654 , 0.31797235  ,0.06451613 , 0.03225806,...
  0.     ,     0.00460829 , 0.01382488  ,0.    ,      0.   ,     ];
% 
% xi_xx = [.088, .072, .098, .073, .066, .039, .036, -.002];
% xi_yy = [-.018, -.019, -.056, -.042, -.057, -.060, -.046, 0.005];
% xi_zz = [-.070, -.053, -.041, -.029, -.009, .020, .010, -.003];


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

% plot(cycles(1:5), m_contacts_immobile(1:5), 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 8,'DisplayName', 'Immobile')
% plot(cycles(1:5), m_contacts_mobile(1:5), 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 8,'DisplayName', 'Mobile')

% plot(cycles(1:5), m_vv_immobile(1:5), ':o', 'Color', pnk, 'MarkerFaceColor', pnk,...
%     'MarkerSize', 8,'DisplayName', 'Reversible')
% plot(cycles(1:5), m_vv_mobile(1:5), ':o', 'Color', lgrn, 'MarkerFaceColor', lgrn,...
%     'MarkerSize', 8,'DisplayName', 'Irreversible')
% xlabel('Shear cycles','FontSize', 18);
% ylabel('Mean Voronoi volume \langleV\rangle/V_0', 'FontSize', 18);


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

hold on
lines = zeros(1,2);
% DELTA_AB
% lines(1)= plot(delta_ab(1:5,1), delta_ab(1:5,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
% lines(1)=plot(delta_ab(6:9,1), delta_ab(6:9,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');
lines(1)=plot(delta_ab(:,1), delta_ab(:,2), 's', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}');

% DELTA (MSD)
% lines(2) =plot(delta(1:5,1), delta(1:5,2), 'o', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
% lines(2)= plot(delta(6:10,1), delta(6:10,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');
lines(2)=plot(delta(:,1), delta(:,2), 's', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta');

% lines(3)=plot(delta_big(:,1), delta_big(:,2), 'd', 'Color', red, 'MarkerFaceColor', red, 'MarkerSize', 8, 'Displayname', '\Delta_{big}');
% lines(4)=plot(delta_ab_big(:,1), delta_ab_big(:,2), 'd', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8, 'Displayname', '\Delta_{AB}_{big}');

leg = legend(lines, 'Location', 'northeast');

% % Semilog plot of delta data
% % slg = semilogy(delta_ab(:,1), delta_ab(:,2), 's', delta(:,1), delta(:,2), 's');
% slg = semilogy(delta_ab(:,1), delta_ab(:,2), 's', delta_90(:,1), delta_90(:,2), 's');
% % slg = semilogy(delta_ab_big(:,1), delta_ab_big(:,2), 's', delta_big(:,1), delta_big(:,2), 's');
% slg(1).Color = blu;
% slg(1).MarkerFaceColor = blu;
% slg(1).MarkerSize = 8;
% slg(1).DisplayName = '\Delta_{AB}';
% slg(2).Color = red;
% slg(2).MarkerFaceColor = red;
% slg(2).MarkerSize = 8;
% slg(2).DisplayName = '\Delta';
% leg = legend(slg, 'Location', 'southwest');

% hold on
% plot(pressures(:,1), pressures(1:5,2), 'o', 'Color', blu, 'MarkerFaceColor', blu, 'MarkerSize', 8);


% plot(time, vf_peri, 'o', 'Color', blu, 'MarkerFaceColor', blu,...
%     'MarkerSize', 8, 'Displayname', 'Settling')
% plot(vert_x, vert_y, '-', 'Color', grn);
% plot(time_jolts, vf_jolts, 'o', 'Color', red, 'MarkerFaceColor', red,...
%     'MarkerSize', 8, 'Displayname', 'Jolts')

xlabel('Vol. Frac.','FontSize', 18);
ylabel('\mum^2', 'FontSize', 18);
% ylabel('Pressure (mPa)', 'FontSize', 18);

% bar(bin_edges(1:end-1), pdf_pre, 1.0, 'DisplayName', 'Before training', 'FaceAlpha', 0.5, 'FaceColor', org, 'EdgeColor', org)
% bar(bin_edges(1:end-1), pdf_post, 1.0, 'DisplayName', 'After training', 'FaceAlpha', 0.5, 'FaceColor', blu, 'EdgeColor', blu)
% ylabel('Probability','FontSize', 18);
% xlabel('Contact number \it z', 'FontSize', 18);

% bar(vv_edges(1:end-1), pdf_vv_norm_pre, 1.0, 'DisplayName','Before training',...
%     'FaceAlpha', 0.5, 'FaceColor', org, 'EdgeColor', org)
% bar(vv_edges(1:end-1), pdf_vv_norm_post, 1.0, 'DisplayName','After training',...
%     'FaceAlpha', 0.5, 'FaceColor', blu, 'EdgeColor', blu)

% plot(cycles, m_vv_mobile, 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'Mobile')
% plot(cycles, m_vv_immobile, 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'Immobile')

% plot(vedges(1:end-1), vHpre, 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'Before training')
% plot(vedges(1:end-1), vHpost, 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'After training')

% bar(vedges(1:end-1)/ 4.19, vHpre, 1.0, 'DisplayName', 'Before training', 'FaceAlpha', 0.5, 'EdgeColor', 'b')
% bar(vedges(1:end-1) / 4.19, vHpost, 1.0, 'DisplayName', 'After training', 'FaceAlpha', 0.5, 'EdgeColor', 'r')

% plot(nnnedges(1:end-1), nnnHpre, 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'Before training')
% plot(nnnedges(1:end-1), nnnHpost, 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'After training')

% bar(nnnedges(1:end-1), nnnHpre, 1.0, 'DisplayName', 'Before training', 'FaceAlpha', 0.5, 'EdgeColor', 'b')
% bar(nnnedges(1:end-1), nnnHpost, 1.0, 'DisplayName', 'After training', 'FaceAlpha', 0.5, 'EdgeColor', 'r')

% plot(cycles(1:end-1), xi_xx(1:end-1), 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'xx')
% plot(cycles(1:end-1), xi_yy(1:end-1), 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'yy')
% plot(cycles(1:end-1), xi_zz(1:end-1), 'g:o', 'MarkerFaceColor', 'g', 'MarkerSize', 7, 'DisplayName', 'zz')

% title('Voronoi volume distribution','FontSize', 20);
% ylabel('Mean contact number \langlez\rangle','FontSize', 18);
% xlabel('Shear cycles', 'FontSize', 18);


% ylabel('Mean contact number \langlez\rangle','FontSize', 18);
% xlabel('Shear cycles', 'FontSize', 18);

% ylabel('Probability','FontSize', 18);
% xlabel('Voronoi volume (V/V_0)', 'FontSize', 18);


% xlim([1 7])
% ylim([3.1 3.5])
% leg = legend('Location', 'northeast');

% set(leg, 'FontSize', 14)


xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

box on

hold off

% %%
% % histogram of contacts mobile and immobile
% bin_edges = 0.0:0.02:0.48;
% h_mobile = [0,  0,  0, 41, 27, 22, 15,  6,  3,  2,  2,  0,  0,  0,  1,  0,  0,...
%         0,  0,  0,  0,  0,  0,  0,  0];
% 
% h_immobile = [7, 33, 43,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,...
%         0,  0,  0,  0,  0,  0,  0,  0];
%         
% tot = sum(h_immobile) + sum(h_mobile);
% figure;
% hold on
% mobile = bar(bin_edges, h_mobile/tot, 1.0, 'b', 'EdgeColor', 'b');
% immobile = bar(bin_edges, h_immobile/tot, 1.0, 'b', 'EdgeColor', 'b');
% % mobile = bar(bin_edges, h_mobile/tot, 1.0, 'r', 'EdgeColor', 'r', 'DisplayName', 'Mobile');
% % immobile = bar(bin_edges, h_immobile/tot, 1.0, 'b', 'EdgeColor', 'b', 'DisplayName', 'Immobile');
% xlim([0 0.5])
% 
% 
% title('Displacement distribution','FontSize', 20);
% xlabel('Displacement (\mum)','FontSize', 18);
% ylabel('Probability','FontSize', 18);
% 
% 
% % leg = legend('Location', 'northeast');
% set(leg, 'FontSize', 16)
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% hold off