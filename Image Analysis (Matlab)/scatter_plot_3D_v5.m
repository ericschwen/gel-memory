%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

% Modification history
% v2: Add color for contact number. 3/7/17
% v4: plotting network number
% v5: plotting displacements magnitude

%% Import Data
% filein = ['C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\'...
%     'linked_w_displacements_w_contacts_w_adj_disp_t0.csv'];

% filein = ['C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\preshear_static_bpass_3D_static_160'...
%     '\preshear_features_w_contacts.csv']

% filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.2\u_combined_o5\linked_mod.csv';
filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.4\u_combined_o5\linked_mod.csv';

data=xlsread(filein);

% select only frame 0 (frame column = 10)
condition1 = data(:,10) ~= 0;
data(condition1,:) = [];

% selecting column dr_adj_full and making sure result is real
dr_column = 22;
condition2 = isnan(data(:,dr_column));
data(condition2,:) = [];

dr = data(:,dr_column);
xPositions=data(:,1) * 0.127; 
yPositions=data(:,2) * 0.127;
zPositions=data(:,3) * 0.12;

cutoff = 0.23;

% 
% dr_real = dr(~isnan(dr));
% 
% dr_sort = sort(dr_real);
% p90 = dr_sort(0.9*length(dr_sort));

% %% Plot full
% figure;
% scatter3(xPositions,yPositions,zPositions, 10, 'bo',...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor', 'r');
% xlabel('x (um)');
% ylabel('y (um)');
% zlabel('z (um)');

%% Plot full with particels colored by contact number
colors = zeros(length(xPositions),3);
for i = 1:length(dr)
    if dr(i) > cutoff
        colors(i,:) = [1,0,0];
    else
    colors(i,:) = [0,0,1];
    end
end

figure;
scatter3(xPositions,yPositions,zPositions, 10, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');

%% Plot with axes limits
figure;
s=scatter3(xPositions,yPositions,zPositions, 60, colors, 'MarkerFaceColor', 'flat', 'Marker','o', 'MarkerEdgeColor', 'k');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');
% colormap lines
% h = colorbar;
% caxis([0,10])
% h.Ticks=[0 1 2 3 4 5 6 7 8 9 10 11 12];
% h.Label.String = '';
daspect([1 1 1])
axis([0 50 0 50 4 12]);