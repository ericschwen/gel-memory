%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

% Modification history
% v2: Add color for contact number. 3/7/17
% v4: plotting network number
% v5: plotting displacements magnitude
% v6: plotting contact number again

%% Import Data
filein = 'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200\positions15_mod.csv';

data=xlsread(filein);
% My file is particle #, x, y, z. Start with data(:,2) not data(:,1).

% positions in pixels
xpos_px=data(:,1); 
ypos_px=data(:,2);
zpos_px=data(:,3);
% positions in um
xpos_um=data(:,11); 
ypos_um=data(:,12);
zpos_um=data(:,13);
% contacts
contacts = data(:,14);

% fix height by subtracting off bottom plate part
zpos_um = zpos_um -1;

%% Plot full
figure;
scatter3(xpos_um,ypos_um,zpos_um, 10, 'bo',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor', 'r');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');

%% Plot full with particels colored by contact number
colors = zeros(length(xpos_um),3);

map = colormap(jet);
for i = 1:length(contacts)
    colors(i,:) = map((contacts(i) * 6)+1,:);
end

figure;
scatter3(xpos_um,ypos_um,zpos_um, 10, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (um)');
ylabel('y (um)');
zlabel('z (um)');

%% Plot with axes limits
figure;
s=scatter3(xpos_um,ypos_um,zpos_um, 160, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
xlabel('x (\mum)','FontSize', 18);
ylabel('y (\mum)','FontSize', 18);
zlabel('z (\mum)','FontSize', 18);
% colormap lines
colormap jet
h = colorbar;
caxis([0,10])
% h.Ticks=[0 1 2 3 4 5 6 7 8 9 10];
h.Label.String = 'Contacts';
daspect([1 1 1])
axis([20 40 20 40 5 15]);

% title('Displacement distribution','FontSize', 20);

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);