
file2 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts2_5075.lsm';
file3 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts3_7925.lsm';
file4 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts4_12650.lsm';
file5 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts5_17475.lsm';
file6 = 'C:\Users\Eric\Documents\Xerox Data\30um gap runs\1Hz 0.4V 8-17-16.mdb\xyts6_22725.lsm';

strain2 = strain_calc_2D(file2);
strain3 = strain_calc_2D(file3);
strain4 = strain_calc_2D(file4);
strain5 = strain_calc_2D(file5);
strain6 = strain_calc_2D(file6);

strain = [strain2;strain3;strain4;strain5;strain6];
height = [5.1;7.9;12.7;17.5;22.7];

figure;
plot(strain, height, 'b:o')
hold on
title('Strain vs Height');
xlabel('strain (pixels)');
ylabel('Height (um)');
hold off