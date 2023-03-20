%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

% Modification history
% v2: Add color for contact number. 3/7/17

%% Import Data
filein = ['E:\Xerox Data\30um gap runs 2016\0.5Hz 0.1V 9-12-16.mdb\ts5_static_bpass_3D_static_160\'...
    'ts5_features_w_contacts.csv'];

% filein = ['C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\preshear_static_bpass_3D_static_160'...
%     '\preshear_features_w_contacts.csv']

data=xlsread(filein);
% My file is particle #, x, y, z. Start with data(:,2) not data(:,1).
xPositions=data(:,2); 
yPositions=data(:,3);
zPositions=data(:,4);
contacts = data(:,16);

%% Plot full
figure;
scatter3(xPositions,yPositions,zPositions, 10, 'bo',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor', 'r');
xlabel('x (um)');
ylabel('y (um)');
zlabel(' (um)');

%% Plot full with particels colored by contact number
map = colormap(jet);

colors = zeros(length(xPositions),3);
for i = 1:length(contacts)
    colors(i,:) = map((contacts(i) * 5)+1,:);
end

figure;
scatter3(xPositions,yPositions,zPositions, 10, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');

%% Plot with axes limits
figure;
s=scatter3(xPositions,yPositions,zPositions, 90, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');
colormap jet
h = colorbar;
caxis([0,12])
h.Ticks=[0 1 2 3 4 5 6 7 8 9 10 11 12];
h.Label.String = 'Contacts';
axis([30 60 0 30 0 20]);

%% Plot with axes limits
figure;
s=scatter3(xPositions,yPositions,zPositions, 200, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');
colormap jet
h = colorbar;
caxis([0,12])
h.Ticks=[0 1 2 3 4 5 6 7 8 9 10 11 12];
h.Label.String = 'Contacts';
axis([30 50 10 20 0 20]);