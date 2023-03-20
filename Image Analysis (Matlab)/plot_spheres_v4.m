% plot_spheres
%
% Try using surf to plot spheres based on coordinates and radii
%
% Author: Eric Schwen
% Date: 2-2-18
%
% Mod History:
%   v2: add in two sphere colors
%   v3: Import and plot tracked particles
%   v4: restrict to specifc slices of particles

%%%%%%%%%%% Import data and select parts %%%%%%%%%%%%%%%%%%%%

% Standard trackpy data
file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.4\u_combined_o5\linked_mod.csv';
% Set columns in data (check excel file for them)
frame_col = 10;
dr_col = 22;
xum_col = 11;
yum_col = 12;
zum_col = 13;

% % Some PERI data
% file_path = 'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv';
% frame_col = 5;
% dr_col = 17;
% xum_col = 6;
% yum_col = 7;
% zum_col = 8;

data=xlsread(file_path);

t = readtable(file_path);


% select only frame 0 (frame column = 10)
condition1 = data(:,frame_col) == 0;
data(~condition1,:) = [];

% % selecting only particles in specific y-range (essentially xz-slice)
% ymin = 200;
% ymax = 232;
% condition2 = data(:,2) > ymin;
% condition3 = data(:,2) < ymax;
% conditions = condition2 & condition3;
% data(~conditions,:) = [];

% % selecting column dr_adj_full and remove nan rows

condition4 = isnan(data(:,dr_col));
data(condition4,:) = [];
% dr = data(:,dr_column);

% Create mobile and immobile parts
cutoff = 0.23;
mobile = data;
immobile = data;
cutoff_condition = data(:,dr_col) < 0.23;
mobile(cutoff_condition,:) = [];
immobile(~cutoff_condition,:) = [];



% % Set variables for x,y,z
% x_px = data(:,1); 
% y_px = data(:,2);
% z_px = data(:,3);
% 
% x_um = data(:,11);
% y_um = data(:,12);
% z_um = data(:,13);

% % number of spheres N
% N = 15;
% % arrays for random x,y,z sphere coordinates
% XT = randn(1,N)/6;
% YT = randn(1,N)/6;
% ZT = randn(1,N)/6;
% N2 = 10;
% XT2 = randn(1,N)/6;
% YT2 = randn(1,N)/6;
% ZT2 = randn(1,N)/6;

%% Plot the immobile set of spheres

% sphere radius a
a = 0.96;

for j=1:length(immobile(:,1))
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+immobile(j, xum_col),a*y+immobile(j,yum_col),a*z+immobile(j,zum_col));
  hold on
  set(hSurface,'FaceColor',[0 0 1], ...
  'FaceAlpha',1.0,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.1)
end

% Plot the mobile set of spheres
for k=1:length(mobile(:,1))
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+mobile(k, xum_col),a*y+mobile(k,yum_col),a*z+mobile(k,zum_col));
  hold on
  set(hSurface,'FaceColor',[1 0 0], ...
  'FaceAlpha',1.0,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.1)
end
% axis([0 50 0 50 4 12]);
daspect([1 1 1]);

hold off
xlabel('x (\mum)');
ylabel('y (\muum)');
zlabel('z (\mum)');
daspect([1 1 1])
xlim([3, 60])
% ylim([ymin*0.127, ymax*0.127])
zlim([0,15])
% axis([0 50 0 50 4 12]);
view(0,0)
camlight