% plot lifetime vs amplitude
%
% Author: Eric
% Date: 6-8-18
%
% Mod History:
% v3 (1/14/18): Nonlinear least squares fit for critical strain. Also try
% combining data sets before fitting
% v4 (2/14-19): use effective strain
% v5 (9-17-19): new experimentation. Try fitting right side.
% v6 (9-27-19): just copy fit from left side to right side.
% v7: (11-17-22): fix axes labels.
% v8: 11-17-22: swap to real strain units

red = [228,26,28]/255;
blu = [55,126,184]/255;
grn = [77,175,74]/255;
pur = [152,78,163]/255;
org = [255,127,0]/255;
brn = [166,86,40]/255;

% Conversion from volts to strain
v2s = 4.1/30.;

% 10-10-18 data
% amplitudes in V
amplitudes1010 = [0.8 0.9 1.1];
% raw strains = amplitudes * v2s
% effective strains (post train)
estrains1010 = [.035 .047 .053];
% lifetimes in shear cycles
lifetimes1010 = [88 114 378];

% 10-10-18 data
% amplitudes in V
amplitudes1010_ext = [0.8 0.9 1.1];
% lifetimes in shear cycles
lifetimes1010_ext = [88 114 378];


% 10-1-18 data
% amplitudes in V
amplitudes101 = [0.1 0.2 0.4 0.6 0.7 0.8 1.0];
% lifetimes in shear cycles
lifetimes101 = [1 76 104 192 142 216 142];


% 10-1-18 data -- first 4 runs taken
% amplitudes in V 
amplitudes101_4 = [0.1 0.4 0.6 0.8];
% lifetimes in shear cycles
lifetimes101_4 = [1 104 192 216];

% 8-29-18 data
% amplitudes in V
amplitudes829 = [0.4 0.6 0.7 0.8 0.9 1.0];
% lifetimes in shear cycles
lifetimes829 = [86 51 127 118 153 105];

% 8-15-18 data
% amplitudes in V
amplitudes815 = [0.4 0.6 0.7 0.8];
% lifetimes in shear cycles
lifetimes815 = [109 151 176 127];

% 6-28-18 data
% amplitudes in V
amplitudes628 = [0.4 0.6 0.8 1.0 1.2];
% effective strains (post train)
estrains628 = [.041 .045 .041 .045 .067];
% lifetimes in shear cycles
lifetimes628 = [48 68 64 106 179];


%%%% NOTE: only 5-21 and 6-3 with lower volume fraction gel
% 6-3-18 data
% lifetimes in shear cycles
lifetimes63 = [36 56 58 272 267];
% amplitudes in V
amplitudes63 = [0.4 0.5 0.6 0.8 1.0]*v2s;

% 5-21-18 data
amplitudes521 = [0.1 0.4 0.6 0.6 0.8 1.0 1.0 1.0 1.4];
lifetimes521 = [31 110 17 31 248 78 85 118 224];

% 5-21-18 first 8 data taken
amplitudes521_8 = [0.6 0.6 1.0 1.0 1.0 1.4]*v2s;
lifetimes521_8 = [17 31 78 85 110 224];

% 5-21-18 only triain well
amplitudes521_well = [0.1 0.6 1.0 1.0 1.0 1.4]*v2s;
lifetimes521_well = [22 29 78 85 110 224];

figure;
hold on
plot(amplitudes63, lifetimes63, 'd', 'color', pur, 'MarkerFaceColor', pur, 'MarkerSize',8);
% plot(amplitudes521, lifetimes521,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
plot(amplitudes521_8, lifetimes521_well, 'o', 'color', org, 'MarkerFaceColor', org, 'MarkerSize', 8);
% plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(amplitudes815, lifetimes815,'.', 'Color', [153, 102, 51]/256,'MarkerSize', 16);
% plot(amplitudes829, lifetimes829,'.', 'Color', [204, 0, 204]/256,'MarkerSize', 16);

plot_gc1 = plot(ones(100,1) * 0.9*v2s, 1:4:400, 'color', pur, 'LineStyle', '--',...
    'LineWidth', options.line_width);

plot_gc2 = plot(ones(100,1) * 1.2*v2s, 1:4:400, 'color', org, 'LineStyle', '--',...
    'LineWidth', options.line_width);


% plot(amplitudes101, lifetimes101, '.', 'Color', [51, 153, 51]/256,'MarkerSize', 16);

% title('Training','FontSize', 20);
xlabel('\gamma_0','FontSize', 16);
ylabel('Characteristic time \tau','FontSize', 16);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
box on

hold off

%%%%%%%%%%%%%
%% Fit to power law
% lifetimes to fit

% life = lifetimes829(1:end);
% gam = amplitudes829(1:end);
% gc = 1.1;

% life = lifetimes628(1:end);
% gam = amplitudes628(1:end)*v2s;
% gc = 1.4*v2s;
% gam = estrains628(1:end);
% gc = 0.085;


% life = lifetimes63(1:end-1);
% gam = amplitudes63(1:end-1);
% gc = 0.9;

% life = lifetimes521_well(1:end-1);
% gam = amplitudes521_well(1:end-1);
% gc = 1.2;

% life = lifetimes101_4(1:end);
% gam = amplitudes101_4(1:end);
% gc = 0.75;

% life = lifetimes1010(1:end);
% gam = amplitudes1010(1:end);
% gc = 1.2;

% Combined lifetimes
% life = [lifetimes1010(1:end), lifetimes628(1:end)];
% gam = [amplitudes1010(1:end)+0.2, amplitudes628(1:end)];
% gc = 1.4;

life = [lifetimes521_well(1:end-1), lifetimes63(1:end-1)];
gam = [amplitudes521_well(1:end-1)-0.3*v2s, amplitudes63(1:end-1)];
gc = 0.83*v2s;

figure;
loglog(gc-gam, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% figure;
% plot(log10(gc-gam), log10(life), 'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);

mylogfit = fit(log10((gc-gam))', log10(life)', 'poly1');
logfit_coeffs = coeffvalues(mylogfit);

% mylogfit = fit((gc-gam)', life', 'poly1');
% logfit_coeffs = coeffvalues(mylogfit);

figure;
hold on
plot(log10(gc-gam), logfit_coeffs(1)* log10(gc-gam) + logfit_coeffs(2))
plot(log10(gc-gam), log10(life),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16)
xlabel('Log \gamma-\gamma_0^c','FontSize', 16);
ylabel('Log Lifetime \tau','FontSize', 16);
% xlim([
hold off

ls = logspace(-3, 0);

figure;
ax = gca;
% plot(gc-gam, 10.^(fit_coeffs(1)* log10(gc-gam)+ fit_coeffs(2)))
loglog(ls, (ls).^(logfit_coeffs(1)) * 10^logfit_coeffs(2), 'b', 'LineWidth', 1)
hold on
loglog(gc-gam, life,'bd', 'MarkerFaceColor', 'b', 'MarkerSize', 6)
xlim([10^(-3) 10^0])
xlabel('\gamma_0-\gamma_0^c','FontSize', 16);
ylabel('Characteristic time \tau','FontSize', 16);
box on
ax.TickLength = [0.04 2];
ax.FontSize = 16;

% wrong!
% figure;
% xs = 0.01: 0.01: 0.07;
% hold on
% loglog(gc-gam, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot(xs,exp(fit_coeffs(1)* log(xs)) + fit_coeffs(2))
% hold off 

% plot lifetimes with power law fit
figure;
xs = logspace(log10(0.02), log10(gc-.01));
hold on
plot(amplitudes63(1:end-1), lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
plot(amplitudes521_well(1:end-1)-0.3*v2s, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628*v2s, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(estrains628, lifetimes628, 'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes101_4, lifetimes101_4,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(amplitudes1010, lifetimes1010, 'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(amplitudes829, lifetimes829, 'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
plot(xs, 10^(logfit_coeffs(2))*(gc-xs).^(logfit_coeffs(1)), 'r')
% xlim([0 1.0])

ylim([0 400])
hold off

xlabel('\gamma_0','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);


%% figure shifting to plot gamma_c - gamma
figure;
xs = logspace(log10(0.1), log10(gc*v2s-.05*v2s));
hold on
% plot(xs - gc, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
plot(amplitudes63(1:end-1) - gc, lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
plot(amplitudes521_well(1:end-1) -gc - 0.3*v2s, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628 - gc, lifetimes628,'.', 'Color', [255, 153, 0]/256, 'MarkerSize', 16);
% plot(amplitudes829-gc+0.2, lifetimes829,'.', 'Color', [0, 255, 0]/256,'MarkerSize', 16);
% plot(amplitudes815-gc+0.4, lifetimes815,'.', 'Color', [102, 51, 0]/256,'MarkerSize', 16);
% plot(amplitudes101(2:6)-gc+0.5, lifetimes101(2:6),'.', 'Color', [51, 153, 51]/256, 'MarkerSize', 16);
% plot(amplitudes1010-gc+0.2, lifetimes1010,'.', 'Color', 'k', 'MarkerSize', 16);
% xlim([-1.4 0.2])

ylim([0 400])
hold off

xlabel('\gamma_c - \gamma','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);

% %%
% % with fixed strain units
% figure;
% xs = logspace(log10(0.1), log10(gc-.05*v2s));
% hold on
% plot((xs - gc)*v2s, 10^(logfit_coeffs(2))*(gc-xs).^(logfit_coeffs(1)), 'r')
% plot((amplitudes63(1:end-1) - gc)*v2s, lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot((amplitudes521_well(1:end-1) -gc-0.3)*v2s, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% % plot((amplitudes628 - gc)*v2s, lifetimes628,'.', 'Color', [255, 153, 0]/256, 'MarkerSize', 16);
% % plot((amplitudes829-gc+0.2)*v2s, lifetimes829,'.', 'Color', [0, 255, 0]/256,'MarkerSize', 16);
% % plot((amplitudes815-gc+0.4)*v2s, lifetimes815,'.', 'Color', [102, 51, 0]/256,'MarkerSize', 16);
% % plot((amplitudes101(2:6)-gc+0.5)*v2s, lifetimes101(2:6),'.', 'Color', [51, 153, 51]/256, 'MarkerSize', 16);
% % plot((amplitudes1010-gc+0.2)*v2s, lifetimes1010,'.', 'Color', [255, 0, 255]/256, 'MarkerSize', 16);
% % plot((amplitudes1010_ext-gc+0.2)*v2s, lifetimes1010_ext,'.', 'Color', [255, 0, 255]/256, 'MarkerSize', 16);
% % xlim([-1.4 0.2])
% 
% ylim([0 400])
% hold off
% 
% xlabel('\gamma_c - \gamma','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);

%% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables

life2fit = life;
gam2fit = gam;
% gam2fit = estrains628;

life_end = [lifetimes521_well(end), lifetimes63(end)];
gam_end = [amplitudes521_well(end)-0.3*v2s, amplitudes63(end)];

% Set estimates
a_0 = 40*v2s;
gc_0 = 0.85*v2s;
nu_0 = -0.85;
vars_0 = [a_0 gc_0 nu_0];

% Set bounds
lb = [1*v2s 0.05*v2s 0.2];
ub = [1000*v2s 1*v2s 2];

% Define fit
myfittype = fittype('a*(gc-gam)^(-nu)', 'dependent', {'tau'}, 'independent', {'gam'},...
    'coefficients', {'a', 'gc', 'nu'});

% Run fitting
nl_fit = fit(gam2fit', life2fit', myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
fit_coeffs = coeffvalues(nl_fit);
conf_ints = confint(nl_fit);

% Manually designate points from fit (for plotting)
xx = min(gam2fit):0.01:max(gam2fit);

xx = -.4*v2s:0.001:0.82*v2s;
fit_points = fit_coeffs(1) * (fit_coeffs(2)-xx).^(-fit_coeffs(3));

%flipped plot
xx_rt = fit_coeffs(2) - max(xx):0.01: fit_coeffs(2) - max(xx)+1;
fit_flip = fit_coeffs(1) * (xx_rt).^-(fit_coeffs(3));
fit_flip_basic = fliplr(fit_points);
fit_rt = 150*v2s * (xx_rt).^-(fit_coeffs(3));

figure;
hold on

plot(gam2fit-fit_coeffs(2), life2fit,'bd', 'MarkerFaceColor', 'b', 'MarkerSize', 6)
plot(gam_end-fit_coeffs(2), life_end,'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 6)
plot(xx-fit_coeffs(2), fit_points, 'b', 'LineWidth', 1.5)
% plot(xx_rt, fit_flip, 'r:', 'LineWidth', 1.5)
plot(xx_rt, fit_rt, 'r:', 'LineWidth', 1.5)
% title('Training','FontSize', 20);
xlabel('\gamma_0 - \gamma_0^c','FontSize', 18);
ylabel('Characteristic time \tau','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
% legend('off')
xlim([-1.2*v2s 1*v2s])
ylim([0 400])
box on
hold off

% %% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables
% % RIGHT SIDE OF EQUATION
% 
% 
% life2fit = [lifetimes521_well(end), lifetimes63(end)];
% gam2fit = [amplitudes521_well(end)-0.3, amplitudes63(end)];
% gc = 0.9;
% 
% % life2fit = life;
% % gam2fit = gam;
% % % gam2fit = estrains628;
% 
% 
% % Set estimates
% a_0 = 40;
% gc_0 = 0.85;
% nu_0 = -0.85;
% vars_0 = [a_0 gc_0 nu_0];
% 
% % Set bounds
% lb = [1 0.05 0.2];
% ub = [1000 1 2];
% 
% % Define fit
% myfittype = fittype('a*(gc-gam)^(-nu)', 'dependent', {'tau'}, 'independent', {'gam'},...
%     'coefficients', {'a', 'gc', 'nu'});
% 
% % Run fitting
% nl_fit = fit(gam2fit', life2fit', myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
% fit_coeffs = coeffvalues(nl_fit);
% conf_ints = confint(nl_fit);
% 
% % Manually designate points from fit (for plotting)
% xx = min(gam2fit):0.01:max(gam2fit);
% fit_points = fit_coeffs(1) * (fit_coeffs(2)-xx).^(-fit_coeffs(3));
% 
% figure;
% hold on
% plot(xx-fit_coeffs(2), fit_points, 'r', 'LineWidth', 2)
% plot(gam2fit-fit_coeffs(2), life2fit,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 14)
% % title('Training','FontSize', 20);
% xlabel('\gamma_c - \gamma','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% legend('off')
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot fixing strain units
% figure;
% hold on
% plot((xx-fit_coeffs(2))*v2s, fit_points, 'r', 'LineWidth', 2)
% plot((gam2fit-fit_coeffs(2))*v2s, life2fit,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 14)
% % title('Training','FontSize', 20);
% xlabel('\gamma_c - \gamma','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% legend('off')
% hold off

% %% Fix strain units
% 
% figure;
% loglog((gc-gam)*v2s, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% % figure;
% % plot(log10(gc-gam), log10(life), 'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% 
% myfit = fit(log10((gc-gam))', log10(life)', 'poly1');
% fit_coeffs = coeffvalues(myfit);
% 
% figure;
% hold on
% plot(log10((gc-gam)*v2s), fit_coeffs(1)* log10(gc-gam) + fit_coeffs(2))
% plot(log10((gc-gam)*v2s), log10(life),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16)
% xlabel('Log \gamma-\gamma_c','FontSize', 16);
% ylabel('Log Lifetime \tau','FontSize', 16);
% hold off
% 
% % plot lifetimes with power law fit IN STRAIN UNITS
% figure;
% xs = logspace(log10(0.1), log10(gc-.05));
% hold on
% plot(amplitudes63*v2s, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% % plot(amplitudes521_well, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% % plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(xs*v2s, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
% xlim([0 .16])
% 
% ylim([0 400])
% hold off
% 
% xlabel('Training strain (\gamma_0)','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);
% 
% % figure shifting to plot gamma_c - gamma
% figure;
% xs = logspace(log10(0.1), log10(gc-.05));
% hold on
% plot((amplitudes63 - gc+0.3)*v2s, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot((amplitudes521_well -gc)*v2s, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot((xs - gc)*v2s, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
% % plot(amplitudes628 - gc, lifetimes628,'.', 'Color', [255, 153, 0]/256, 'MarkerSize', 16);
% % plot(amplitudes829-gc+0.2, lifetimes829,'.', 'Color', [0, 255, 0]/256,'MarkerSize', 20);
% % plot(amplitudes815-gc+0.4, lifetimes815,'.', 'Color', [102, 51, 0]/256,'MarkerSize', 20);
% % plot(amplitudes101(2:6)-gc+0.5, lifetimes101(2:6),'.', 'Color', 'b', 'MarkerSize', 20);
% % xlim([-1.0 0.4])
% 
% ylim([0 400])
% hold off
% 
% xlabel('\gamma_c - \gamma','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);
% 
% %% Plotting with vertical lines (can move parts of this up if wanted)
% 
% figure;
% hold on
% plot(amplitudes63, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% % plot(amplitudes521_8, lifetimes521_8,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
% plot(amplitudes521_well, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% 
% % title('Training','FontSize', 20);
% xlabel('Training strain (V)','FontSize', 18);
% ylabel('lifetimes','FontSize', 18);
% % ylim([0.02 0.05])
% % xlim([0 550])
% % axis([0 max(t) 0.02 0.14]);
% 
% % % Plot vertical line for training amplitude
% trainingAmplitude = 0.9;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'b--');
% trainingAmplitude = 1.2;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'r--');
% 
% trainingAmplitude = 1.4;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'g--');
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% 
% hold off
% 
% %%%%%%% Fixing volts to strain
% figure;
% hold on
% plot(amplitudes63*v2s, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% % plot(amplitudes521_8, lifetimes521_8,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
% plot(amplitudes521_well*v2s, lifetimes521_well,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628*v2s, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% 
% plot(amplitudes829*v2s, lifetimes829,'.', 'Color', [204, 0, 204]/256,'MarkerSize', 16);
% plot(amplitudes815*v2s, lifetimes815,'.', 'Color', [153, 102, 51]/256,'MarkerSize', 16);
% 
% % title('Training','FontSize', 20);
% xlabel('Training strain \gamma_0','FontSize', 18);
% ylabel('Lifetime \tau','FontSize', 18);
% % ylim([0.02 0.05])
% % xlim([0 550])
% % axis([0 max(t) 0.02 0.14]);
% 
% % % Plot vertical line for training amplitude
% trainingAmplitude = 0.9*v2s;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'b--');
% trainingAmplitude = 1.2*v2s;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'r--');
% 
% trainingAmplitude = 1.4*v2s;
% plot(ones(100,1) * trainingAmplitude, linspace(1, 500, 100), 'g--');
% 
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% 
% hold off
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Attempt at using nonlinear least squares to fit for gamma_c
