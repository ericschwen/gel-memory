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
% v7: return to static large images
% v8: modify bounds and such to work with glass data. Split x and y. 3-7-20
% 
% Author: Eric Schwen
% Date: 7-20-18
% Author: Eric Schwen
% Date: 7-20-18

% Import positions data
% trackpy 2.5 um range
% file_path ='D:\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200\positions15_mod.csv';

file_path = 'E:\Gardner Data\piezo 2-13-20\2-14-20 testing\ts-post-1-stacked-featured\linked_peri_mod.csv';

data_full = readtable(file_path);
data = readtable(file_path);

% select only specific frame
condition1 = data.frame(:) == 1;
data(~condition1,:) = [];

% create an array for positions
positions = [data.xum, data.yum, data.zum];

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

% Set bounds within a range
xmin = 1;
xmax = 15;
ymin = 1;
ymax = 15;
zmin = 4;
zmax = 7.4;

valid_particles = [];
for i = 1:length(r)
    % make sure not infinite and within bounds
    % NOTE: NOT SURE X AND Y ARE CORRECTLY LABELED. CHECK.
    if r{i}(1) ~= 1
        if min(V(r{i},1)) > xmin && min(V(r{i},2)) > ymin && min(V(r{i},3)) > zmin
            if max(V(r{i},1)) < xmax && max(V(r{i},2)) < ymax && max(V(r{i},3)) < zmax
                valid_particles = [valid_particles; i];
            end
        end
    end
end

% calculate voronoi volumes for valid particles
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

% some statistic
min(vor_vols)
max(vor_vols)
mean(vor_vols)
min(nnn_valid)
max(nnn_valid)
mean(nnn_valid)
    
% make histogram of voronoi volumes
figure
vhist = histogram(vor_vols, 6:1:24, 'Normalization', 'probability');
xlabel('Voronoi vol (\mum^3)','FontSize', 18);
ylabel('Probability', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
[vH, vedges] = histcounts(vor_vols, 6:1:24, 'Normalization', 'probability');

% normalized voronoi volumes
V_0 = 4/3. * pi * (1.85/2) ^ 3;
figure
vhist_norm = histogram(vor_vols/V_0, 1:0.25:7, 'Normalization', 'probability');
xlabel('Voronoi vol (V/V_0)','FontSize', 18);
ylabel('Probability', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
xlim([1 7])
[vH_norm, vedges_norm] = histcounts(vor_vols/V_0, 1:0.25:7, 'Normalization', 'probability');

% make histogram of topographical contacts
figure
nnnhist = histogram(nnn_valid, 9:1:23, 'Normalization', 'probability');
xlabel('Topographical neighbors','FontSize', 18);
ylabel('Probability', 'FontSize', 18);
xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
[nnnH, nnnedges] = histcounts(vor_vols, 9:1:23, 'Normalization', 'probability');

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

% %%%%% MOBILITY STUFF %%%%%%%%
% 
% % add dr_adj_full to particle stats
% dr_adj_full_valid = zeros(length(particle_stats), 1);
% official_particle_number = zeros(length(particle_stats),1);
% reduced_positions = zeros(length(particle_stats),3);
% for i = 1:length(particle_stats)
%     dr_adj_full_valid(i) = data.dr_adj_full(particle_stats(i,1));
%     official_particle_number(i) = data.particle(particle_stats(i,1));
%     reduced_positions(i,:) = positions(particle_stats(i),:);
% end
% particle_stats_dr = [particle_stats, dr_adj_full_valid, official_particle_number, reduced_positions];
% 
% % restrict to particles with nonzero dr
% particle_stats_nonan = particle_stats_dr(particle_stats_dr(:,4)>0,:);
% 
% % separate into mobile and immobile particles
% mobility_cutoff = 0.23;
% max_dr = 0.8;
% immobile = particle_stats_nonan(particle_stats_nonan(:,4) < mobility_cutoff,:);
% mobile = particle_stats_nonan(particle_stats_nonan(:,4) > mobility_cutoff & particle_stats_nonan(:,4)< max_dr,:);
% 
% % stats = particle, vv, nnn, dr
% mean(mobile(:,2))
% mean(mobile(:,3))
% length(mobile)
% mean(immobile(:,2))
% mean(immobile(:,3))
% length(immobile)
% 
% % % make histogram of voronoi volumes
% % figure
% % vhist = histogram(mobile(:,2), 'Normalization', 'probability');
% % xlabel('Voronoi vol (\mum^3)','FontSize', 18);
% % ylabel('Probability', 'FontSize', 18);
% % xt = get(gca,'XTick');
% % set(gca, 'FontSize', 16);
% 
