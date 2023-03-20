%% 3D Scatter plot
% Date: 3/3/17
% Author: Eric Schwen
% Scatter plot particle positions in 3D. Takes input of position data from
% trackpy featuring.

% Modification history
% v2: Add color for contact number. 3/7/17
% v4: plotting network number
% v5: plotting displacements magnitude
% v7: plotting only sliced segments (IN PROGREESS) 

%% Import Data
% filein = ['C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\'...
%     'linked_w_displacements_w_contacts_w_adj_disp_t0.csv'];

% filein = ['C:\Users\Eric\Documents\Xerox Data\30um gap runs\0.5Hz 0.1V 9-12-16.mdb\preshear_static_bpass_3D_static_160'...
%     '\preshear_features_w_contacts.csv']

% filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.2\u_combined_o5\linked_mod.csv';
% filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\3.6\u_combined_o5\linked_mod.csv';
filein = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.0\u_combined_o5\linked_mod.csv';

data=xlsread(filein);

% select only frame 0 (frame column = 10)
condition1 = data(:,10) == 0;
data(~condition1,:) = [];

% selecting only particles in specific y-range (essentially xz-slice)
ymin = 200;
ymax = 212;
condition2 = data(:,2) > ymin;
condition3 = data(:,2) < ymax;
conditions = condition2 & condition3;
data(~conditions,:) = [];

% % selecting column dr_adj_full and remove nan rows
dr_column = 22;
condition4 = isnan(data(:,dr_column));
data(condition4,:) = [];
dr = data(:,dr_column);

cutoff = 0.23;

xPositions=data(:,1) * 0.127; 
yPositions=data(:,2) * 0.127;
zPositions=data(:,3) * 0.12;



%% particels colored by contact number
colors = zeros(length(xPositions),3);
for i = 1:length(dr)
    if dr(i) > cutoff
        colors(i,:) = [1,0,0];
    else
    colors(i,:) = [0,0,1];
    end
end

% figure;
% scatter3(xPositions,yPositions,zPositions, 10, colors, 'MarkerFaceColor', 'flat', 'Marker','o');
% xlabel('x (um)');
% ylabel('y (um)');
% zlabel('z (um)');

%% Plot with axes limits
figure;
s=scatter3(xPositions,yPositions,zPositions, 180, colors, 'MarkerFaceColor', 'flat', 'Marker','o', 'MarkerEdgeColor', 'k');
xlabel('x (\mum)');
ylabel('y (\muum)');
zlabel('z (\mum)');
daspect([1 1 1])
% zlim([4,12])
% axis([0 50 0 50 4 12]);
view(0,0)