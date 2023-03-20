% voronoi_tessellation_v1
%
% Use matlab's built in voronoi tessellation on positions of particles in
% gel as found by trackpy or peri.
%
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
ymin = 50;
ymax = 180;
condition2 = data.y > ymin;
condition3 = data.y < ymax;
conditions_y = condition2 & condition3;
data(~conditions_y,:) = [];

% also limit x and z ranges
xmin = 50;
xmax = 180;
condition4 = data.x > xmin;
condition5 = data.x < xmax;
conditions_x = condition4 & condition5;
data(~conditions_x,:) = [];

zmin = 50;
zmax = 100;
condition6 = data.z > zmin;
condition7 = data.z < zmax;
conditions_z = condition6 & condition7;
data(~conditions_z,:) = [];

% create an array for positions
positions = [data.x, data.y, data.z];

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

% number of neighbors for particle i = sum(adj_mat(i,:))

% DT.edges gives all connected verticies. May be easier than adj_mat

% %%%% Count number of nearest neighbors
% % note: should probably remove all columns with a zero (neglect infinity)
% % this also recounts same edges in different polyhedra!
% a = unique(DT.ConnectivityList);
% nnn = [a,histc(DT.ConnectivityList,a)];
% 
% nnn = [a,sum(histc(DT.ConnectivityList,a),2)];

% Convex hull
% full diagram
[C, v] = convexHull(DT);
trisurf(C,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3), ...
       'FaceColor','cyan')


%look only at voronoi volumes not going to infinity
finite_particles = [];
for i = 1:length(r)
    if r{i}(1) ~= 1
        finite_particles = [finite_particles; i];
    end
end

% use convex hull of individual voronoi volumes
indices = r{5};
verts = zeros(length(indices),3);
for i =1:length(verts)
    verts(i, :) = V(indices(i), :);
end
verts

[K, vol] = convhulln(verts);

trisurf(K, verts(:,1), verts(:,2), verts(:,3),'FaceColor','cyan')

