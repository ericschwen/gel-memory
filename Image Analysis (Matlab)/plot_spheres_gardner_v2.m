% plot_spheres_gardner
%
% Try using surf to plot spheres based on coordinates and radii. Gardner
% version modified from plot_spheres_v5 to use gardner data
%
% Author: Eric Schwen
% Date: 7-11-22
%
% Mod History:
%   v2: Modify particle size and coloring display. Sphere diamater proportional
%       to |r_i^A - r_i^B| and color for deviation from u_i. In progress 10/25/22

%%%%%%%%%%% Import data and select parts %%%%%%%%%%%%%%%%%%%%
% Adjusted positions data
% file_path = 'E:\Gardner Data\glass_12-7-21\ts-3-stacked\linked_rel_combined_peri_3-4_mod_w_contacts_mod_s2s.csv';
file_path = 'E:\Gardner Data\glass_12-7-21\ts-18-stacked\linked_rel_combined_peri_18-19_mod_w_contacts_mod_neighsort_s2s.csv';
% file_path = 'E:\Gardner Data\glass_12-7-21\ts-28-stacked\linked_rel_combined_peri_28-29_mod_w_contacts_mod_neighsort_s2s.csv';

% Relative positions data
% file_path = 'E:\Gardner Data\glass_12-7-21\ts-3-stacked\linked_rel_combined_peri_3-4_mod_w_contacts_mod_s2srel.csv';
% file_path = 'E:\Gardner Data\glass_12-7-21\ts-18-stacked\linked_rel_combined_peri_18-19_w_contacts_mod_s2srel.csv';
% file_path = 'E:\Gardner Data\glass_12-7-21\ts-28-stacked\linked_rel_combined_peri_28-29_w_contacts_mod_s2srel.csv';
% note: throws error if neighbors are in csv since it can't import correctly


data = readtable(file_path);
data_untrimmed = data;
% select only frame 0
condition_frame = data.frame(:) == 1;
data(~condition_frame,:) = [];

% Limiting to specific section in x,y,z (in microns)
xmin = 1;
xmax = 15;
ymin = 1;
ymax = 15;
zmin = 2;
zmax = 7.4;
condition_xmin = data.xum > xmin;
condition_xmax = data.xum < xmax;
condition_ymin = data.yum > ymin;
condition_ymax = data.yum < ymax;
condition_zmin = data.zum > zmin;
condition_zmax = data.zum < zmax;
conditions_pos = condition_xmin & condition_xmax & ...
    condition_ymin & condition_ymax & condition_zmin & condition_zmax;
data(~conditions_pos,:) = [];


% selecting column cage_space and remove nan rows
condition_nan = ~isnan(data.cage_space(:));
data(~condition_nan,:) = [];
 
% Create tables for relative cage spacing u_i greater or less than zero
% mean cage spacing can be either manually set or determined from data
mean_cage_spacing = 0.016;
% mean_cage_spacing = mean(data.cage_space);
ui = data.cage_space/mean_cage_spacing -1;

% pos_ui = data;
% neg_ui = data;
% cutoff_condition = data.cage_space(:) < mean_cage_spacing;
% pos_ui(cutoff_condition,:) = [];
% neg_ui(~cutoff_condition,:) = [];

%% Plot spheres

% radius scaling factor (radius will be sqrt(mean square distance) * factor)
% just proportional to the distance between compressions
rsf = 3;

% set colormap
colors = winter;

figure;

% % Plot the speres with greater positive rel spacing ui
for j=1:height(data)
  % Generate a sphere consisting of 20 by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(rsf*sqrt(data.cage_space(j))*x+data.xum(j),...
      rsf*sqrt(data.cage_space(j))*y+data.yum(j),...
      rsf*sqrt(data.cage_space(j))*z+data.zum(j));
  hold on
%     set(hSurface,'FaceColor',[1,0,0], ...
%   'FaceAlpha',1.0,...
%   'FaceLighting','gouraud',...
%   'EdgeColor','k', 'EdgeAlpha', 0.1)
  
  set(hSurface,'FaceColor',colors(max(1,uint8((min(ui(j),1)-min(ui))/((1-min(ui))/64.))),:), ...
  'FaceAlpha',1.0,...
  'FaceLighting','gouraud',...
  'EdgeColor','k', 'EdgeAlpha', 0.1)
end

% choose which color to use (on scale of 1-64)
uint8((ui(j)-min(ui))/((max(ui)-min(ui))/64.));
% choose which color to use but all ui>1 as 1
uint8((min(ui(j),1)-min(ui))/((1-min(ui))/64.));

% axis([0 50 0 50 4 12]);
daspect([1 1 1]);

hold off
xlabel('x (?m)', 'FontSize', 18);
ylabel('y (?m)', 'FontSize', 18);
zlabel('z (?m)', 'FontSize', 18);
daspect([1 1 1])

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);

xlim([0, 16])
ylim([0, 16])
zlim([1, 9])

% cb = colorbar;
% ylabel(cb, 'u_i', 'FontSize', 16)

% ylim([2,13])
% axis([0 50 0 50 4 12]);

view(-70,20)
camlight