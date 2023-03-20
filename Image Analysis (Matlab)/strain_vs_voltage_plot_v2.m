% strain_vs_voltage plot

% Plot (and optionally calculate) the strain over time

%%
nfiles = 4;
filepath = cell(nfiles,1);
strains = ones(nfiles,1);
voltages = [1; 3; 5; 8];

%% 
filebase = 'C:\Users\Eric\Documents\Xerox Data\strain voltage measurements 2-1-17\';
fileList = {'1V_ts.lsm' , '3V_ts.lsm', '5V_ts.lsm', '8V_ts.lsm'};
%%
for i = 1:nfiles
    filepath{i} = [filebase, fileList{i}];
%     % Comment out the shear band calcuation if it's already done to just
%     % plot the results
%     shear_band_calculationv6_2D(filepath{i});
    strains(i) = strain_calc_2D_v2(filepath{i});
end

%%
figure;
plot(voltages, strains, 'b:o')
hold on
title('Strain vs Voltage');
xlabel('Voltage');
ylabel('Strain');
axis([0 10 0 350]);
hold off
