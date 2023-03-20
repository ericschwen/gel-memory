% Mean contact number over time

% data_path = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\pauses_disp_vs_cycle.csv';
% data = xlsread(data_path);

cycles = [0,50,100,150,200,300,400,500];
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

% %%% Mean contacts mobile vs immobile peri 0.05um surface sep (4-9-19)
% m_contacts_mobile = [1.88 1.98 1.76 2.03 1.82];
% m_contacts_immobile = [3.2 2.44 1.98 2.04 2.07];




%%% Mean contacts mobile vs immobile peri 30nm surface sep (4-17-19)
% m_contacts_mobile = [1.60 1.53 1.24 1.86 1.58 1.65 1.67 2.03];
% m_contacts_immobile = [3.0 1.97 1.53 1.77 1.75 2.02 1.95 2.15];
% m_contacts_all = [1.65 1.64 1.35 1.79 1.68 1.89 1.83 2.10];

% %%% Mean contacts mobile vs immobile peri 50nm surface sep (4-17-19)
m_contacts_mobile = [1.88 1.98 1.76 2.04 1.82 2.16 2.19 2.31];
m_contacts_immobile = [3.2 2.44 1.98 2.02 2.05 2.41 2.39 2.54];
m_contacts_all = [1.93 2.01 1.84 2.03 1.96 2.32 2.30 2.45];

%%% Mean contacts mobile vs immobile peri 100nm surface sep (4-17-19)
% m_contacts_mobile = [2.59 2.65 2.55 2.64 2.51 3.0 2.82 2.86];
% m_contacts_immobile = [3.8 3.22 2.75 2.88 2.79 3.01 3.16 3.43];
% m_contacts_all = [2.63 2.79 2.63 2.83 2.68 3.01 3.01 3.20];

n_particles_mobile = [145 110 62 28 57 55 73 65];
n_particles_immobile = [5 36 40 108 92 106 87 98];
fraction_mobile = [.97 .75 .61 .21 .38 .34 .46 .40];




%%% Mean contacts mobile vs immobile peri 0.1um surface sep (10-4-18)
% m_contacts_mobile = [2.28, 2.22, 2.21, 2.39, 2.27];
% m_contacts_immobile = [3.4, 2.78, 2.32, 2.44, 2.28];

% % % % Mean contacts mobile vs immobile peri 0.2um surface sep (10-4-18)
% m_contacts_mobile = [3.8, 3.75, 3.28, 3.22, 3.36];
% m_contacts_immobile = [3.06, 3.12, 3.16, 3.11, 2.94];



% m_vv_mobile = [14.3, 14.4, 13.9, 13.8, 13.7]/4.2;
% m_vv_immobile = [13.7, 13.3, 13.7, 13.1, 13.5]/4.2;
% cycles = [0,50,100,150,200];

% % 0.6V full stack contact distribution data
% contacts = [0,1,2,3,4,5,6,7,8,9,10,11,12];
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
% 
% xi_xx = [.088, .072, .098, .073, .066, .039, .036, -.002];
% xi_yy = [-.018, -.019, -.056, -.042, -.057, -.060, -.046, 0.005];
% xi_zz = [-.070, -.053, -.041, -.029, -.009, .020, .010, -.003];






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
aqua = [27,158,119]/255.;
yel = [255,255,51]/255.;
pnk = [231,41,138]/255.;
gry = [102,102,102]/255.;
lgrn = [102,166,30]/255.

% plot(cycles, data(:,2), 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
figure;
hold on;
plot(cycles(2:8), m_contacts_immobile(2:8), ':o', 'Color', pnk, 'MarkerFaceColor', pnk, 'MarkerSize', 7, 'DisplayName', 'Reversible')
% plot(cycles(1:8), m_contacts_immobile(1:8), ':o', 'Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 7, 'DisplayName', 'Reversible')
plot(cycles(1:8), m_contacts_mobile(1:8), ':o', 'Color', lgrn, 'MarkerFaceColor', lgrn, 'MarkerSize', 7, 'DisplayName', 'Irreversible')

for i = 2:8
    plot(cycles(i), m_contacts_immobile(i), ':o','Color', pnk, 'MarkerFaceColor', pnk,...
        'MarkerSize', int32((1-fraction_mobile(i))*30),'HandleVisibility','off')
    plot(cycles(i), m_contacts_mobile(i), ':o', 'Color', lgrn,'MarkerFaceColor', lgrn, ...
        'MarkerSize', int32(fraction_mobile(i)*30),'HandleVisibility','off')
end

plot(cycles(1), m_contacts_mobile(1), ':o', 'Color', lgrn,'MarkerFaceColor', lgrn, ...
    'MarkerSize', int32(fraction_mobile(1)*30),'HandleVisibility','off')

% for i = 2:8
%     plot(cycles(i), m_contacts_immobile(i), ':o','Color', pur, 'MarkerFaceColor', pur,...
%         'MarkerSize', int32(n_particles_immobile(i)/5),'HandleVisibility','off')
%     plot(cycles(i), m_contacts_mobile(i), ':o', 'Color', org,'MarkerFaceColor', org, ...
%         'MarkerSize', int32(n_particles_mobile(i)/5),'HandleVisibility','off')
% end
% 
% plot(cycles(1), m_contacts_mobile(1), ':o', 'Color', org,'MarkerFaceColor', org, ...
%     'MarkerSize', int32(n_particles_mobile(1)/5),'HandleVisibility','off')

% plot(cycles(1:8), m_contacts_all(1:8), ':d', 'Color', grn, 'MarkerFaceColor', grn, 'MarkerSize', 7, 'DisplayName', 'All')


% plot(cycles(1), m_contacts_immobile(1), ':o','Color', pur, 'MarkerFaceColor', pur,'MarkerSize', 10,'HandleVisibility','off')
% plot(cycles(1), m_contacts_mobile(1), ':o', 'Color', org,'MarkerFaceColor', org, 'MarkerSize', 20,'HandleVisibility','off')
% plot(cycles(2), m_contacts_immobile(2), ':o','Color', pur, 'MarkerFaceColor', pur, 'MarkerSize', 15,'HandleVisibility','off')
% plot(cycles(2), m_contacts_mobile(2), ':o', 'Color', org,'MarkerFaceColor', org, 'MarkerSize', 12,'HandleVisibility','off')
% plot(cycles(3), m_contacts_immobile(3), ':o', 'Color', pur,'MarkerFaceColor', pur,'MarkerSize', 20,'HandleVisibility','off')
% plot(cycles(3), m_contacts_mobile(3), ':o', 'Color', org,'MarkerFaceColor', org, 'MarkerSize', 10,'HandleVisibility','off')
% plot(cycles(4), m_contacts_immobile(4), ':o', 'Color', pur,'MarkerFaceColor', pur, 'MarkerSize', 25,'HandleVisibility','off')
% plot(cycles(4), m_contacts_mobile(4), ':o', 'Color', org,'MarkerFaceColor', org, 'MarkerSize', 7,'HandleVisibility','off')
% plot(cycles(5), m_contacts_immobile(5), ':o', 'Color', pur,'MarkerFaceColor', pur, 'MarkerSize', 25,'HandleVisibility','off')
% plot(cycles(5), m_contacts_mobile(5), ':o', 'Color', org, 'MarkerFaceColor', org, 'MarkerSize', 5,'HandleVisibility','off')
% plot(cycles(6), m_contacts_immobile(6), ':o', 'Color', pur,'MarkerFaceColor', pur, 'MarkerSize', 25,'HandleVisibility','off')
% plot(cycles(6), m_contacts_mobile(6), ':o', 'Color', org, 'MarkerFaceColor', org, 'MarkerSize', 5,'HandleVisibility','off')
% plot(cycles(7), m_contacts_immobile(7), ':o', 'Color', pur,'MarkerFaceColor', pur, 'MarkerSize', 25,'HandleVisibility','off')
% plot(cycles(7), m_contacts_mobile(7), ':o', 'Color', org, 'MarkerFaceColor', org, 'MarkerSize', 5,'HandleVisibility','off')
% plot(cycles(8), m_contacts_immobile(8), ':o', 'Color', pur,'MarkerFaceColor', pur, 'MarkerSize', 25,'HandleVisibility','off')
% plot(cycles(8), m_contacts_mobile(8), ':o', 'Color', org, 'MarkerFaceColor', org, 'MarkerSize', 5,'HandleVisibility','off')

% plot(cycles, m_vv_mobile, 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'Mobile')
% plot(cycles, m_vv_immobile, 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'Immobile')

% plot(vedges(1:end-1), vHpre, 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'DisplayName', 'Before training')
% plot(vedges(1:end-1), vHpost, 'r:o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'DisplayName', 'After training')

% bar(vedges(1:end-1)/ 4.19, vHpre, 1.0, 'DisplayName', 'Before training', 'FaceAlpha', 0.5, 'EdgeColor', 'b')
% bar(vedges(1:end-1) / 4.19, vHpost, 1.0, 'DisplayName', 'After training', 'FaceAlpha', 0.5, 'EdgeColor', 'r')

% bar(bin_edges(1:end-2), untrained, 1.0, 'DisplayName', 'Before training', 'FaceAlpha', 0.5, 'EdgeColor', 'b')
% bar(bin_edges(1:end-2), trained, 1.0, 'DisplayName', 'After training', 'FaceAlpha', 0.5, 'EdgeColor', 'r')

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

% ylabel('Probability','FontSize', 18);
% xlabel('Contact number \it z', 'FontSize', 18);



ylabel('Mean contact number \langlez\rangle','FontSize', 18);
xlabel('Shear cycles', 'FontSize', 18);

xlim([0 500])
% ylim([1.6 2.6])
% legend('Immobile', 'Mobile', 'All')
leg = legend('Location', 'southeast');
set(leg, 'FontSize', 14)


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