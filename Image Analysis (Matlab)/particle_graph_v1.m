% particle_graph
%
% Creates and plots a graph of edges between nearest neighbor particles
% from peri
%
% Author: Eric Schwen
% Date: 2-11-18
%

%%%%%%%%%%% Import data and select parts %%%%%%%%%%%%%%%%%%%%

% Standard trackpy data
% file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\0.6\u_combined_o5\linked_mod.csv';
% file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p50\u_combined_o5\linked_mod.csv';
% file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p400\s_combined_o5\linked_mod.csv';
% % Some PERI data
% file_path = 'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv';
file_path = 'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p50\linked_peri.csv';

adj_mat_path = 'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p50\linked_mod_adj_matrix.csv';

%%%%%%%% CURRENTLY GETTING ERROR WITH this non-peri data. 
file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod.csv';
adj_mat_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod_adj_matrix.csv';

% data = xlsread(file_path);
data = readtable(file_path);
adj_mat = xlsread(adj_mat_path);

% select only frame 0 (frame column = 10)
condition1 = data.frame(:) == 1;
data(~condition1,:) = [];

% create graph
G = graph(adj_mat);


%% Plot the immobile set of spheres

% figure;

% plot(G,'XData',data.xum(:),'YData',data.zum(:))

plot(G,'XData',data.x(:),'YData',data.y(:),'ZData',data.z(:), 'MarkerSize', 10)

% % peri limits
xlim([0 128])
ylim([0 128])
zlim([0, 50])
% zlim([0, 6])

xlabel('x (px)', 'FontSize', 18);
ylabel('y (px)', 'FontSize', 18);
zlabel('z (px)', 'FontSize', 18);

daspect([1 1 1]);
view(0,90)


% axis([0 50 0 50 4 12]);
% daspect([1 1 1]);
% 
% xlabel('x (\mum)');
% ylabel('y (\muum)');
% zlabel('z (\mum)');
% daspect([1 1 1])

% xlim([4, 60])
% zlim([1,15])

% ylim([2,13])
% axis([0 50 0 50 4 12]);
% 
% % peri limits
% xlim([0 16])
% zlim([0, 12])
% zlim([0, 6])
% 
% view(0,0)
% camlight