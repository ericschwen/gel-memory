% voronoi_tessellation_v2
%
% Use matlab's built in voronoi tessellation on positions of particles in
% gel as found by trackpy or peri.
%
% Mod history:
% v2: switch to um
%
% Author: Eric Schwen
% Date: 7-20-18
% Author: Eric Schwen
% Date: 7-20-18

% Import positions data
% trackpy 2.2 um range
file_path ='C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\u_combined_o5\linked_mod.csv';

data = readtable(file_path);

% select only frame 0 (frame column = 10)
condition1 = data.frame(:) == 0;
data(~condition1,:) = [];

% selecting only particles in specific y-range (essentially xz-slice labels)
% cutoffs chosen by slices. Positions are in pixels
ymin = 100;
ymax = 400;
condition2 = data.y > ymin;
condition3 = data.y < ymax;
conditions_y = condition2 & condition3;
data(~conditions_y,:) = [];

% also limit x and z ranges
xmin = 100;
xmax = 400;
condition4 = data.x > xmin;
condition5 = data.x < xmax;
conditions_x = condition4 & condition5;
data(~conditions_x,:) = [];

zmin = 15;
zmax = 130;
condition6 = data.z > zmin;
condition7 = data.z < zmax;
conditions_z = condition6 & condition7;
data(~conditions_z,:) = [];

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
horzmin = xmin *.125;
horzmax = xmax * .125;
vertmin = zmin * .12;
vertmax = zmax * .12;
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

% voronoi volumes and particle labels
particle_vor_vol = [valid_particles, vor_vols];
    

% trisurf(K, verts(:,1), verts(:,2), verts(:,3),'FaceColor','cyan')

