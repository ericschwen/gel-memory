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

%%%%%%%%%%% Import data and select parts %%%%%%%%%%%%%%%%%%%%
file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.4\u_combined_o5\linked_mod.csv';

data=xlsread(file_path);

% sphere radius a
a = 1;

% select only frame 0 (frame column = 10)
condition1 = data(:,10) == 0;
data(~condition1,:) = [];

% % selecting only particles in specific y-range (essentially xz-slice)
% ymin = 200;
% ymax = 212;
% condition2 = data(:,2) > ymin;
% condition3 = data(:,2) < ymax;
% conditions = condition2 & condition3;
% data(~conditions,:) = [];

% % selecting column dr_adj_full and remove nan rows
dr_column = 22;
condition4 = isnan(data(:,dr_column));
data(condition4,:) = [];
% dr = data(:,dr_column);

% Create mobile and immobile parts
cutoff = 0.23;
mobile = data;
immobile = data;
cutoff_condition = data(:,dr_column) < 0.23;
mobile(cutoff_condition,:) = [];
immobile(~cutoff_condition,:) = [];

% Set columns for x,y,z in um in data (check excel file for them)
xum_col = 11;
yum_col = 12;
zum_col = 13;

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

% Plot the immobile set of spheres
for j=1:length(immobile)
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+immobile(j, xum_col),a*y+immobile(j,yum_col),a*z+immobile(j,zum_col));
  hold on
  set(hSurface,'FaceColor',[0 0 1], ...
  'FaceAlpha',0.5,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.05)
end

% Plot the mobile set of spheres
for k=1:length(mobile)
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+mobile(k, xum_col),a*y+mobile(k,yum_col),a*z+mobile(k,zum_col));
  hold on
  set(hSurface,'FaceColor',[1 0 0], ...
  'FaceAlpha',0.5,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.05)
end
% axis([0 50 0 50 4 12]);
daspect([1 1 1]);

hold off
xlabel('x')
ylabel('y')
zlabel('z')
camlight