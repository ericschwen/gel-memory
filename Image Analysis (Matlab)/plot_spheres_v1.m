% plot_spheres
%
% Try using surf to plot spheres based on coordinates and radii
%
% Author: Eric Schwen
% Date: 2-2-18

% Example stolen from forums

% number of spheres N
N = 15;
% sphere radius a
a = 1/8;
% arrays for x,y,z sphere coordinates
XT = randn(1,N)/6;
YT = randn(1,N)/6;
ZT = randn(1,N)/6;
for j=1:N
  % Generate a sphere consisting of 20by 20 faces
  [x,y,z]=sphere;
  % use surf function to plot
  hSurface=surf(a*x+XT(j),a*y+YT(j),a*z+ZT(j));
  hold on
  set(hSurface,'FaceColor',[0 0 1], ...
      'FaceAlpha',0.5,...
      'FaceLighting','gouraud',...
      'EdgeColor','k', 'EdgeAlpha', 0.05)
  axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
  daspect([1 1 1]);
end
hold off
xlabel('X')
ylabel('Y')
zlabel('Z')
camlight