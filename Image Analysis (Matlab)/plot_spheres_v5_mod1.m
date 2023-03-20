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
%   v5: read in data as a table
%       mod1: just plot spheres without displacement reference

%%%%%%%%%%% Import data and select parts %%%%%%%%%%%%%%%%%%%%

% Standard trackpy data
% file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\0.6\u_combined_o5\linked_mod.csv';
file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p400\u_combined_o5\linked_mod.csv';
file_path = 'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p400\s_combined_o5\linked_mod.csv';
% % Some PERI data
% file_path = 'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv';


data = readtable(file_path);

% select only frame 0 (frame column = 10)
condition1 = data.frame(:) == 1;
data(~condition1,:) = [];

% selecting only particles in specific y-range (essentially xz-slice)
ymin = 54;
ymax = 78;
% ymin = 50;
% ymax = 82;
condition2 = data.y > ymin;
condition3 = data.y < ymax;
conditions = condition2 & condition3;
data(~conditions,:) = [];

% % % selecting column dr_adj_full and remove nan rows
% condition4 = ~isnan(data.dr_adj_full(:));
% data(~condition4,:) = [];

% Create mobile and immobile parts
% cutoff = 0.23;
% mobile = data;
immobile = data;
% cutoff_condition = data.dr_adj_full(:) < cutoff;
% mobile(cutoff_condition,:) = [];
% immobile(~cutoff_condition,:) = [];

%% Plot the immobile set of spheres

figure;
% sphere radius a
a = 0.96;

for j=1:height(immobile)
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+immobile.xum(j),a*y+immobile.yum(j),a*z+immobile.zum(j));
  hold on
  set(hSurface,'FaceColor',[0 0 1], ...
  'FaceAlpha',1.0,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.1)
end
% 
% % Plot the mobile set of spheres
% for k=1:height(mobile)
%   % Generate a sphere consisting of 20by 20 faces
%   [x,y,z]=sphere;
%   % use surf function to plot
%   hSurface=surf(a*x+mobile.xum(k),a*y+mobile.yum(k),a*z+mobile.zum(k));
%   hold on
%   set(hSurface,'FaceColor',[0 0 1], ...
%   'FaceAlpha',1.0,...
%   'FaceLighting','gouraud',...
%   'EdgeColor','k', 'EdgeAlpha', 0.1)
% end
% axis([0 50 0 50 4 12]);
daspect([1 1 1]);

hold off
xlabel('x (\mum)');
ylabel('y (\muum)');
zlabel('z (\mum)');
daspect([1 1 1])

xlim([12, 25])
zlim([1,10])

% ylim([2,13])
% axis([0 50 0 50 4 12]);

% % peri limits
% xlim([0 16])
% zlim([0, 12])

view(0,0)
camlight