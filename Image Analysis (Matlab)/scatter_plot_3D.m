%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

%% Import Data
filein = ['E:\Xerox Data\30um gap runs 2016\0.5Hz 0.1V 9-12-16.mdb\ts5_static_bpass_3D_static_160\'...
    'ts5_features.csv'];

data=xlsread(filein);
% My file is particle #, x, y, z. Start with data(:,2) not data(:,1).
xPositions=data(:,2)*(0.125); % Or 0.127?
yPositions=data(:,3)*(0.125);
zPositions=data(:,4)*(0.135);

%% Plot
figure;
scatter3(xPositions,yPositions,zPositions, 10, 'bo',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor', 'r');
xlabel('x (um)');
ylabel('y (um)');
zlabel(' (um)');
% axis([0 30 100 200 0 400]);
%% More Plotting
figure;
scatter3(xPositions,yPositions,zPositions, 80, 'bo',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor', 'r');
xlabel('x (um)');
ylabel('y (um)');
zlabel(' (um)');
axis([20 50 5 25 5 15]);

%%
% figure;
% scatter3(xPositions,yPositions,zPositions, 60, 'b.');
% view(40,35)
% 
% figure;
% scatter3(xPositions,yPositions,zPositions, 60, 'b.');
% view(-30,10)