
% Meera's original data.
figure;
pm_absorb = semilogy(0.023, 0.1, 'bo', 0.23, 0.1, 'bo', 0.23, 1.0, 'bo', 0.23, 10, 'bo',...
    0.68, 1.0, 'bo', 1.36, 0.1, 'bo');
set(pm_absorb, 'MarkerFaceColor','b');
hold on
pm_nonab = semilogy(0.68, 10, 'rs', 1.36, 1, 'rs', 2.3, 0.1, 'rs', 2.3, 1, 'rs');
set(pm_nonab, 'MarkerFaceColor', 'r');
xlim([0 2.5]);
title('Absorbing and Non-absorbing states')
xlabel('Strain');
ylabel('Frequency (Hz)');
hold off

% Include 2Hz data
figure;
pm_absorb = semilogy(0.023, 0.1, 'bo', 0.23, 0.1, 'bo', 0.23, 1.0, 'bo', 0.23, 10, 'bo',...
    0.68, 1.0, 'bo', 1.36, 0.1, 'bo');
set(pm_absorb, 'MarkerFaceColor','b');
hold on

absorb_strain_2Hz = [0.045, 0.23, 0.36, 0.55, 0.59, 0.64];
absorb_freq_2Hz = 2 * ones(1,6);
p2Hz_absorb = semilogy(absorb_strain_2Hz, absorb_freq_2Hz, 'bo');
set(p2Hz_absorb, 'MarkerFaceColor', 'b');

pm_nonab = semilogy(0.68, 10, 'rs', 1.36, 1, 'rs', 2.3, 0.1, 'rs', 2.3, 1, 'rs');
set(pm_nonab, 'MarkerFaceColor', 'r');

nonab_strain_2Hz = [0.82, 1.0];
nonab_freq_2Hz = [2, 2];
p2Hz_nonab = semilogy(nonab_strain_2Hz, nonab_freq_2Hz, 'rs');
set(p2Hz_nonab, 'MarkerFaceColor', 'r');

xlim([0 2.5]);
title('Absorbing and Non-absorbing states')
xlabel('Strain');
ylabel('Frequency (Hz)');
legend([p2Hz_absorb, p2Hz_nonab],'Absorbing', 'Non-absorbing')
hold off