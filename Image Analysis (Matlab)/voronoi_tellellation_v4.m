% voronoi_tessellation_v3
%
% Use matlab's built in voronoi tessellation on positions of particles in
% gel as found by trackpy or peri.
%
% Mod history:
% v2: switch to um
% v3: play with histograms
% v4: try using 8-29-17 pauses. Try restricting boundaries only at end.
%
% Author: Eric Schwen
% Date: 7-20-18
% Author: Eric Schwen
% Date: 7-20-18

% Import positions data
% trackpy 2.2 um range
file_path ='F:\30 um runs backup\8-29-17 0.3333Hz\0.6\p300\u_combined_o5\linked15_mod.csv';

data = readtable(file_path);

% select only frame 0 (frame column = 10)
condition1 = data.frame(:) == 0;
data(~condition1,:) = [];

% % restrict to only nonzero displacements
% condition_nzd = dr_adj_full(:) > 0;
% data(~condition_nzd,:) = [];

% %%%%%%% selecting only particles in specific y-range (essentially xz-slice labels)
% % cutoffs chosen by slices. Positions are in pixels
% ymin = 50;
% ymax = 460;
% condition2 = data.y > ymin;
% condition3 = data.y < ymax;
% conditions_y = condition2 & condition3;
% data(~conditions_y,:) = [];
% 
% % also limit x and z ranges
% xmin = 50;
% xmax = 460;
% condition4 = data.x > xmin;
% condition5 = data.x < xmax;
% conditions_x = condition4 & condition5;
% data(~conditions_x,:) = [];
% 
% zmin = 10;
% zmax = 38;
% condition6 = data.z > zmin;
% condition7 = data.z < zmax;
% conditions_z = condition6 & condition7;
% data(~conditions_z,:) = [];

% create an array for positions
positions = [data.xum, data.yum, data.zum];

% % create voronoi diagram
% [vert, cel] = voronoin(positions);

% create delaunay triangulation
DT = delaunayTriangulation(positions);

% create voronoi diagramD
[V, r] = voronoiDiagram(DT);

% Check neighbors with isConnected
adj_mat = zeros(length(DT.Points), length(DT.Points));
for i = 1:length(DT.Points)
    for j = 1:length(DT.Points)
        if isConnected(DT, i, j)
            adj_mat(i, j) = 1;
            adj_mat(j, i) = 1;
        end
    end
end

nnn = sum(adj_mat,1);

% Convex hull
% full diagram
[C, v] = convexHull(DT);
% trisurf(C,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3), ...
%        'FaceColor','cyan')


%look only at voronoi volumes not going to infinity
% also make sure to only look at vertices within range

% basic bounds
xmin = 50;
xmax = 460;
zmin = 0;
zmax = 50;
horzmin = xmin *.125;
horzmax = xmax * .125;
vertmin = zmin * .12;
vertmax = zmax * .12;
% % more stringent bounds
% horzmin = 10;
% horzmax = 54;
% vertmin = 4;
% vertmax = 12;

valid_particles = [];
for i = 1:length(r)
    % make sure not infinite
    if r{i}(1) ~= 1
        if min(V(r{i},1)) > horzmin && min(V(r{i},2)) > horzmin && min(V(r{i},3)) > vertmin
            if max(V(r{i},1)) < horzmax && max(V(r{i},2)) < horzmax && max(V(r{i},3)) < vertmax
                valid_particles = [valid_particles; i];
            end
        end
    end
end

% calculate voronoi volues
vor_vols = zeros(length(valid_particles),1);
for i = 1:length(valid_particles)
    [K,vol] = convhulln(V(r{valid_particles(i)},:));
    vor_vols(i) = vol;
end

% create list of nnn for valid particles
nnn_valid = zeros(length(valid_particles),1);
for i = 1:length(valid_particles)
    nnn_valid(i) = nnn(valid_particles(i));
end

% valid particle labels and nnn and voronoi volumes in one list
particle_stats = [valid_particles, vor_vols, nnn_valid];
    
% make histogram of voronoi volumes
figure
vhist = histogram(vor_vols, 'Normalization', 'probability');
xlabel('Voronoi vol (\mum^3)','FontSize', 18);
ylabel('Probability', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

% make histogram of topographical contacts
figure
nnnhist = histogram(nnn_valid, 'Normalization', 'probability');
xlabel('Topographical neighbors','FontSize', 18);
ylabel('Probability', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

% scatter plot to see how voronoi volumes compare to nnn
figure;
hold on;
scatter(nnn_valid, vor_vols, 'bo', 'MarkerFaceColor', 'b')
% plot(cycles(1:end-3), m_contacts_immobile(1:end), 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7,'DisplayName', 'Immobile')
% title('Mean contact numbers','FontSize', 20);
xlabel('topological neighbors','FontSize', 18);
ylabel('Voronoi vol (\mum^3)', 'FontSize', 18);
% xlim([0 510])
% ylim([-.1 .1])
% leg = legend('Location', 'northeast');
% set(leg, 'FontSize', 16)
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
hold off

% some statistic
min(vor_vols)
max(vor_vols)
mean(vor_vols)
min(nnn_valid)
max(nnn_valid)
mean(nnn_valid)
