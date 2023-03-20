% shear_voltage_analysis_v1
%
% Comparing shear amplitude sent to piezo to the voltage read back. Taking
% results from plot_shear_voltage_v1 analyzing.
%
% Eric Schwen
% 6-17-19

% % read voltage results from plot_shar_voltage_v1 6-17-19
% in_volt = [0.5 1.0 1.5 2.0 2.5 3.0 3.5];
% read_v_x = [.309 .642 .987 1.338 1.705 2.076 2.46];
% read_v_y = [.415 .855 1.333 1.806 2.323 2.828 3.367];

% % read  voltage results plot_shear_voltage_v1 6-18-19
% in_volt = [0.5 1.0 1.5 2.0 3.0 4.0];
% read_v_x = [.30 .62 .96 1.30 2.02 2.73];
% read_v_y = [.40 .84 1.31 1.79 2.82 3.79];
% amp_um_x = [2.16 4.38 6.86 9.27 14.35 19.86];
% amp_um_y = [2.92 5.91 9.33 12.89 20.13 27.81];

% % Combined voltage vs read voltage
% in_volt = [0.5 1.0 1.5 2.0 2.5 3.0 3.5 0.5 1.0 1.5 2.0 3.0 4.0];
% read_v_x = [.309 .642 .987 1.338 1.705 2.076 2.46 .30 .62 .96 1.30 2.02 2.73];
% read_v_y = [.415 .855 1.333 1.806 2.323 2.828 3.367 .40 .84 1.31 1.79 2.82 3.79];
% restricted to below 2V
in_volt = [0.5 0.5 1.0 1.0 1.5 1.5 2.0 2.0];
read_v_x = [.309 .30 .642 .62 .987 .96 1.338 1.30];
read_v_y = [.415 .40 .855 .84 1.333 1.31 1.806 1.79];

v_over_in_x = read_v_x./in_volt;
v_over_in_y = read_v_y./in_volt;
x_over_y = read_v_x./read_v_y;

% um_over_read_v_x = amp_um_x./read_v_x;
% um_over_read_v_y = amp_um_y./read_v_y;

% fit read voltage to in voltage
myfit_x = fit(in_volt', read_v_x', 'poly1')
myfit_y = fit(in_volt', read_v_y', 'poly1')

figure;
hold on
plot(in_volt, in_volt, 'b:o')
plot(in_volt, read_v_x, 'r:o')
plot(in_volt, read_v_y, 'g:o')
plot(myfit_x, 'r')
plot(myfit_y, 'g')
xlabel('Input voltage (V)','FontSize', 18);
ylabel('Voltage (V)','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off


figure;
hold on
plot(in_volt, x_over_y, 'bo')
plot(in_volt, v_over_in_x, 'ro')
plot(in_volt, v_over_in_y, 'go')
xlabel('Input voltage (V)','FontSize', 18);
ylabel('Normalized voltage (V)','FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16)
legend('off')
hold off

% figure;
% hold on
% plot(in_volt, um_over_read_v_x, 'r:o')
% plot(in_volt, um_over_read_v_y, 'g:o')
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16)
% legend('off')
% hold off

% Comparing some potential inputs
v_in = [0.1 0.2 .3 .4 .5 .6 .7 .8 .9 1.0 1.1 1.2 1.3 1.4 1.5 ...
    1.6 1.7 1.8 1.9 2.0];
eff_v_x = v_in* .68 - .04;
eff_v_y = v_in* .93 -.07;
um_x = 7.17 * eff_v_x;
um_y = 7.17 * eff_v_y;