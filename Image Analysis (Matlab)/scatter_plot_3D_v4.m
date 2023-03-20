%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

% Modification history
% v2: Add color for contact number. 3/7/17
% v4: plotting network number

%% Import Data
filein = ['C:\Eric\Xerox Data\test displacements\'...
    'linked_w_displacements_w_network_short.csv'];

% filein = ['C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\preshear_static_bpass_3D_static_160'...
%     '\preshear_features_w_contacts.csv']

data=xlsread(filein);
% My file is particle #, x, y, z. Start with data(:,2) not data(:,1).
xPositions=data(:,1); 
yPositions=data(:,2);
zPositions=data(:,3);
network = data(:,4);

%% Plot full
figure;
scatter3(xPositions,yPositions,zPositions, 10, 'bo',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor', 'r');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');

%% Plot full with particels colored by contact number
map = colormap(lines);

colors = zeros(length(xPositions),3);
for i = 1:length(network)
    if network(i) == 0
        colors(i,:) = [0,0,0];
    end
    colors(i,:) = map(int16(network(i)/max(network) * 63 + 1),:);
end

figure;
scatter3(xPositions,yPositions,zPositions, 10, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');
daspect([1 1 1])

%% Plot with axes limits
figure;
s=scatter3(xPositions,yPositions,zPositions, 60, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');
daspect([1 1 1])
axis([0 50 0 50 0 6]);