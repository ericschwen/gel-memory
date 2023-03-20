% plot lifetime vs amplitude
%
% Author: Eric
% Date: 6-8-18
%
% Mod History:
% v3 (1/14/18): Nonlinear least squares fit for critical strain. Also try
% combining data sets before fitting

% Conversion from volts to strain
v2s = 4.1/30.;

% 10-10-18 data
% amplitudes in V
amplitudes1010 = [0.8 0.9 1.1];
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
% lifetimes in shear cycles
lifetimes628 = [48 68 64 106 179];


%%%% NOTE: only 5-21 and 6-3 with lower volume fraction gel
% 6-3-18 data
% lifetimes in shear cycles
lifetimes63 = [36 56 58 272 267];
% amplitudes in V
amplitudes63 = [0.4 0.5 0.6 0.8 1.0];

% 5-21-18 data
amplitudes521 = [0.1 0.4 0.6 0.6 0.8 1.0 1.0 1.0 1.4];
lifetimes521 = [31 110 17 31 248 78 85 118 224];

% 5-21-18 first 8 data taken
amplitudes521_8 = [0.6 0.6 1.0 1.0 1.0 1.4];
lifetimes521_8 = [17 31 78 85 110 224];

% 5-21-18 only triain well
amplitudes521_well = [0.1 0.6 1.0 1.0 1.0 1.4];
lifetimes521_well = [22 29 78 85 110 224];

figure;
hold on
plot(amplitudes63, lifetimes63,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot(amplitudes521, lifetimes521,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
plot(amplitudes521_8, lifetimes521_8,'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
plot(amplitudes815, lifetimes815,'.', 'Color', [153, 102, 51]/256,'MarkerSize', 16);
plot(amplitudes829, lifetimes829,'.', 'Color', [204, 0, 204]/256,'MarkerSize', 16);


% plot(amplitudes101, lifetimes101, '.', 'Color', [51, 153, 51]/256,'MarkerSize', 16);

% title('Training','FontSize', 20);
xlabel('Shear cycles','FontSize', 18);
ylabel('Characteristic cycles \tau','FontSize', 18);
% ylim([0.02 0.05])
% xlim([0 550])
% axis([0 max(t) 0.02 0.14]);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16)

hold off

%%%%%%%%%%%%%
%% Fit to power law
% lifetimes to fit

% life = lifetimes829(1:end);
% gam = amplitudes829(1:end);
% gc = 1.1;

life = lifetimes628(1:end);
gam = amplitudes628(1:end);
gc = 1.4;

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

% life = [lifetimes521_well(1:end-1), lifetimes63(1:end-1)];
% gam = [amplitudes521_well(1:end-1)-0.3, amplitudes63(1:end-1)];
% gc = 0.9;

figure;
loglog(gc-gam, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% figure;
% plot(log10(gc-gam), log10(life), 'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);

myfit = fit(log10((gc-gam))', log10(life)', 'poly1');
fit_coeffs = coeffvalues(myfit);

figure;
hold on
plot(log10(gc-gam), fit_coeffs(1)* log10(gc-gam) + fit_coeffs(2))
plot(log10(gc-gam), log10(life),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16)
xlabel('Log \gamma-\gamma_c','FontSize', 16);
ylabel('Log Lifetime \tau','FontSize', 16);
hold off

% wrong!
% figure;
% xs = 0.01: 0.01: 0.07;
% hold on
% loglog(gc-gam, life,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot(xs,exp(fit_coeffs(1)* log(xs)) + fit_coeffs(2))
% hold off 

% plot lifetimes with power law fit
figure;
xs = logspace(log10(0.1), log10(gc-.05));
hold on
plot(amplitudes63(1:end-1), lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
plot(amplitudes521_well(1:end-1)-0.3, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628, lifetimes628,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(amplitudes101_4, lifetimes101_4,'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
% plot(amplitudes1010, lifetimes1010, 'g.', 'MarkerFaceColor', 'g', 'MarkerSize', 16);
plot(xs, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
% xlim([0 1.0])

ylim([0 400])
hold off

xlabel('Strain (V)','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);


%% figure shifting to plot gamma_c - gamma
figure;
xs = logspace(log10(0.1), log10(gc-.05));
hold on
plot(xs - gc, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
plot(amplitudes63(1:end-1) - gc, lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
plot(amplitudes521_well(1:end-1) -gc - 0.3, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
% plot(amplitudes628 - gc, lifetimes628,'.', 'Color', [255, 153, 0]/256, 'MarkerSize', 16);
% plot(amplitudes829-gc+0.2, lifetimes829,'.', 'Color', [0, 255, 0]/256,'MarkerSize', 16);
% plot(amplitudes815-gc+0.4, lifetimes815,'.', 'Color', [102, 51, 0]/256,'MarkerSize', 16);
% plot(amplitudes101(2:6)-gc+0.5, lifetimes101(2:6),'.', 'Color', [51, 153, 51]/256, 'MarkerSize', 16);
% plot(amplitudes1010-gc+0.2, lifetimes1010,'.', 'Color', 'k', 'MarkerSize', 16);
xlim([-1.4 0.2])

ylim([0 400])
hold off

xlabel('\gamma_c - \gamma (V)','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);

%%
% with fixed strain units
figure;
xs = logspace(log10(0.1), log10(gc-.05));
hold on
plot((xs - gc)*v2s, 10^(fit_coeffs(2))*(gc-xs).^(fit_coeffs(1)), 'r')
% plot((amplitudes63(1:end-1) - gc)*v2s, lifetimes63(1:end-1),'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 16);
% plot((amplitudes521_well(1:end-1) -gc-0.3)*v2s, lifetimes521_well(1:end-1),'r.', 'MarkerFaceColor', 'r', 'MarkerSize', 16);
plot((amplitudes628 - gc)*v2s, lifetimes628,'.', 'Color', [255, 153, 0]/256, 'MarkerSize', 16);
% plot((amplitudes829-gc+0.2)*v2s, lifetimes829,'.', 'Color', [0, 255, 0]/256,'MarkerSize', 16);
% plot((amplitudes815-gc+0.4)*v2s, lifetimes815,'.', 'Color', [102, 51, 0]/256,'MarkerSize', 16);
% plot((amplitudes101(2:6)-gc+0.5)*v2s, lifetimes101(2:6),'.', 'Color', [51, 153, 51]/256, 'MarkerSize', 16);
plot((amplitudes1010-gc+0.2)*v2s, lifetimes1010,'.', 'Color', [255, 0, 255]/256, 'MarkerSize', 16);
% plot((amplitudes1010_ext-gc+0.2)*v2s, lifetimes1010_ext,'.', 'Color', [255, 0, 255]/256, 'MarkerSize', 16);
% xlim([-1.4 0.2])

ylim([0 400])
hold off

xlabel('\gamma_c - \gamma','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);

%% Create Custom Nonlinear Models and Specify Problem Parameters and Independent Variables

life2fit = life;
gam2fit = gam;


% Set estimates
a_0 = 40;
gc_0 = 1.4;
nu_0 = 0.85;
vars_0 = [a_0 gc_0 nu_0];

% Set bounds
lb = [5 0.8 0.2];
ub = [1000 1.8 2];

% Define fit
myfittype = fittype('a*(gc-gam)^(-nu)', 'dependent', {'tau'}, 'independent', {'gam'},...
    'coefficients', {'a', 'gc', 'nu'});

% Run fitting
nl_fit = fit(gam2fit', life2fit', myfittype, 'Lower', lb, 'Upper', ub, 'StartPoint', vars_0);
fit_coeffs = coeffvalues(nl_fit);
conf_ints = confint(nl_fit);

% Manually designate points from fit (for plotting)
xx = min(gam2fit):0.01:max(gam2fit);
fit_points = fit_coeffs(1) * (fit_coeffs(2)-xx).^(-fit_coeffs(3));

figure;
hold on
plot(xx-fit_coeffs(2), fit_points, 'r', 'LineWidth', 2)
plot(gam2fit-fit_coeffs(2), life2fit,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 14)
% title('Training','FontSize', 20);
xlabel('\gamma_c - \gamma','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off

% Plot fixing strain units
figure;
hold on
plot((xx-fit_coeffs(2))*v2s, fit_points, 'r', 'LineWidth', 2)
plot((gam2fit-fit_coeffs(2))*v2s, life2fit,'b.', 'MarkerFaceColor', 'b', 'MarkerSize', 14)
% title('Training','FontSize', 20);
xlabel('\gamma_c - \gamma','FontSize', 18);
ylabel('Lifetime \tau','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off

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
