
%%

filepath_1V = 'C:\Users\Eric\Documents\Xerox Data\strain voltage measurements 2-1-17\1V_ts.lsm';

shear_band_calculation_v6_2D(filepath_1V)

strain_1V = strain_calc_2D_v2(filepath_1V);

%%
filepath_3V = 'C:\Users\Eric\Documents\Xerox Data\strain voltage measurements 2-1-17\3V_ts.lsm';

shear_band_calculation_v6_2D(filepath_3V)

strain_3V = strain_calc_2D_v2(filepath_3V);
%%
filepath_5V = 'C:\Users\Eric\Documents\Xerox Data\strain voltage measurements 2-1-17\5V_ts.lsm';

shear_band_calculation_v6_2D(filepath_5V)

strain_5V = strain_calc_2D_v2(filepath_5V);
%%
filepath_8V = 'C:\Users\Eric\Documents\Xerox Data\strain voltage measurements 2-1-17\8V_ts.lsm';

shear_band_calculation_v6_2D(filepath_8V)

strain_8V = strain_calc_2D_v2(filepath_8V);
%%
% strain = [strain2;strain3;strain4;strain5;strain6];
% height = [5.1;7.9;12.7;17.5;22.7];

% figure;
% plot(strain, height, 'b:o')
% hold on
% title('Strain vs Height');
% xlabel('strain (pixels)');
% ylabel('Height (um)');
% hold off


strains = ones(4,1);
voltages = [1; 3; 5; 8];
