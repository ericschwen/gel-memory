% voronoi_tessellation_v3
%
% Use matlab's built in voronoi tessellation on positions of particles in
% gel as found by trackpy or peri.
%
% Mod history:
% v2: switch to um
% v3: play with histograms
% v4: try using 8-29-17 pauses. Try restricting boundaries only at end.
% v5: look at displacements
% v6: adjust particle numbering and FIXED displacements stuff
% 
% 
% Author: Eric Schwen
% Date: 7-20-18
% Author: Eric Schwen
% Date: 7-20-18

% Import positions data
% trackpy 2.2 um range
file_path ='F:\30 um runs backup\8-29-17 0.3333Hz\0.6\p50\u_combined_o5\linked15_mod.csv';

data_full = readtable(file_path);
data = readtable(file_path);

% select only frame 0 (frame column = 10)
condition1 = data.frame(:) == 0;
data(~condition1,:) = [];

% to search for particle 3: data(data.particle==3,:)

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
% [C, v] = convexHull(DT);
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
    
% % make histogram of voronoi volumes
% figure
% vhist = histogram(vor_vols, 'Normalization', 'probability');
% xlabel('Voronoi vol (\mum^3)','FontSize', 18);
% ylabel('Probability', 'FontSize', 18);
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% % make histogram of topographical contacts
% figure
% nnnhist = histogram(nnn_valid, 'Normalization', 'probability');
% xlabel('Topographical neighbors','FontSize', 18);
% ylabel('Probability', 'FontSize', 18);
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% 
% % scatter plot to see how voronoi volumes compare to nnn
% figure;
% hold on;
% scatter(nnn_valid, vor_vols, 'bo', 'MarkerFaceColor', 'b')
% % plot(cycles(1:end-3), m_contacts_immobile(1:end), 'b:o', 'MarkerFaceColor', 'b', 'MarkerSize', 7,'DisplayName', 'Immobile')
% % title('Mean contact numbers','FontSize', 20);
% xlabel('topological neighbors','FontSize', 18);
% ylabel('Voronoi vol (\mum^3)', 'FontSize', 18);
% % xlim([0 510])
% % ylim([-.1 .1])
% % leg = legend('Location', 'northeast');
% % set(leg, 'FontSize', 16)
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);
% hold off

% add dr_adj_full to particle stats
dr_adj_full_valid = zeros(length(particle_stats), 1);
official_particle_number = zeros(length(particle_stats),1);
reduced_positions = zeros(length(particle_stats),3);
for i = 1:length(particle_stats)
    dr_adj_full_valid(i) = data.dr_adj_full(particle_stats(i,1));
    official_particle_number(i) = data.particle(particle_stats(i,1));
    reduced_positions(i,:) = positions(particle_stats(i),:);
end
particle_stats_dr = [particle_stats, dr_adj_full_valid, official_particle_number, reduced_positions];

% restrict to particles with nonzero dr
particle_stats_nonan = particle_stats_dr(particle_stats_dr(:,4)>0,:);

% separate into mobile and immobile particles
mobility_cutoff = 0.23;
max_dr = 0.8;
immobile = particle_stats_nonan(particle_stats_nonan(:,4) < mobility_cutoff,:);
mobile = particle_stats_nonan(particle_stats_nonan(:,4) > mobility_cutoff & particle_stats_nonan(:,4)< max_dr,:);

% stats = particle, vv, nnn, dr
mean(mobile(:,2))
mean(mobile(:,3))
length(mobile)
mean(immobile(:,2))
mean(immobile(:,3))
length(immobile)

% % make histogram of voronoi volumes
% figure
% vhist = histogram(mobile(:,2), 'Normalization', 'probability');
% xlabel('Voronoi vol (\mum^3)','FontSize', 18);
% ylabel('Probability', 'FontSize', 18);
% xt = get(gca,'XTick');
% set(gca, 'FontSize', 16);


% get neighbors for particle a (labelled according to DT.Points, not
% trackpy particle number)

a = 562;
neighbors = [];
for i = 1:length(adj_mat)
    if adj_mat(a, i) ==1
        neighbors = [neighbors, i];
    end
end
official_neighbors = neighbors;
for i = 1:length(neighbors)
    official_neighbors(i) = data.particle(neighbors(i));
end

official_neighbors

% use convex hull of individual voronoi volumes
indices = r{562};
verts = zeros(length(indices),3);
for i =1:length(verts)
    verts(i, :) = V(indices(i), :);
end
verts

[K, vol] = convhulln(verts);
figure;
trisurf(K, verts(:,1), verts(:,2), verts(:,3),'FaceColor','cyan')
axis([25 30 12 16 0 4])


