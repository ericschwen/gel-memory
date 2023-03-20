function [VV, VV_mean] = void_volume_v4(File_in, Dx)

% Author: Eric Schwen
% Date: 5-22-17
% Purpose: Calculate the Void Volume (VV) to quantify the volume of empty
% space (voids) in a colloidal gel. Takes position info for all particles
% from trackpy output.
%
% Inputs:
% File_in: file path to trackpy particle locations
% Dx: length steps for volume elements in um. 
%
% Outputs:
% VV: array of all void volume resuts
% VV_mean: mean void volume
%
% void volume is the volume of a void "sphere" in contact with the nearest
% particle surface
% R_void = abs(r_dv - r_sphere) - R_sphere
% where r_dv and r_sphere are vectors. r_dv is the center of the a void
% sphere and r_sphere is the center of the nearest particle. R_sphere is
% the radius of the particle.
% VV = 4/3*pi*R_void^3
% Calculation based on SI from "tuning colloidal gels by oscillatory shear"
% by koumakis et. al.
%
% Size division of space into dV probably important. Probably use one pixel
% for now (0.125 um) but might make sense to go smaller.

% Modification history
% v2: rewrite the norms calculation.
% v3: parallelize.
% v4: make a function.
% v5: fix R_void to subtract R_sphere

% % Sample file_in and dx
% file_in = ['C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17\'...
%     '1.0V (2nd)\zstack_post_train_static_bpass_3D_static_160\post_train_features.csv'];
% % Distance for one side of volume elements dV to iterate through
% dx = 0.125;

file_in = File_in;
dx = Dx;

% Radius of particles (in microns)
radius = 2.0;

data = xlsread(file_in);

% Load x, y, z data and convert distances into um.
data(:,2)=data(:,2)*(0.125);
data(:,3)=data(:,3)*(0.125);
data(:,4)=data(:,4)*(0.12);

xmin = min(data(:,2));
ymin = min(data(:,3));
zmin = min(data(:,4));

xmax=max(data(:,2));
ymax=max(data(:,3));
zmax=max(data(:,4));

xmid = (xmin+xmax)/2;
ymid = (ymin+ymax)/2;
zmid = (zmin+zmax)/2;


% position of every particle (x,y,z)
particle_positions = data(:,2:4); 

% define 3D lattice of dV's to iterate through for calcuating void volume.
% Probably limit to a specific volume by creating buffers on the edges
% since particle tracking isn't great near the edges of my images.

% Using positions from middle region
xrange = 15;
yrange = 10;
zrange = 8;
xiter = xmid-xrange/2:dx:xmid+xrange/2;
yiter = ymid-yrange/2:dx:ymid+yrange/2;
ziter = zmid-zrange/2:dx:zmid+zrange/2;

% Using mins and maxs of particle positions to define the space
% xiter = xmin:dx:xmax;
% yiter = ymin:dx:ymax;
% ziter = zmin:dx:zmax;


dV_positions = zeros(length(xiter)*length(yiter)*length(ziter), 3);
VV = zeros(length(dV_positions),1);
% Create a matrix dV_positions of all posible combinations of xiter, yiter,
% and ziter. Could possibly be really big. Can also make this more
% efficient for sure

% Old implementation (only slightly slower)
% iter = 1;
% for x = 1:length(xiter)
%     for y = 1:length(yiter)
%         for z = 1:length(ziter)
%             dV_positions(iter, :) = [xiter(x) yiter(y) ziter(z)];
%             iter = iter + 1;
%         end
%     end
% end

[X,Y,Z] = meshgrid(xiter, yiter, ziter);
dV_positions = [X(:),Y(:),Z(:)];

% Calculate VV for each dV
displacements = zeros(length(particle_positions),3);
distances = zeros(length(particle_positions),1);

parfor ff = 1:length(dV_positions)
    % Calcuate vector from dV from all particle positions. repmat creates a
    % matrix of just the single position repeated.
    displacements = abs(particle_positions - ...
        repmat(dV_positions(ff,:), length(particle_positions), 1));
    % Calculate norms (distances)
    norms = sqrt(sum(displacements.^2,2));
    radius_void = min(norms);
    VV(ff) = 4/3*pi*radius_void^3;
    % Void volume expressed in um^3.
end

VV_scaled = VV/radius^3;

figure;
histogram(VV_scaled)
xlabel('VV/R^3')
ylabel('number')
title('VV histogram')

VV_mean = mean(VV);
VV_mean_scaled = VV_mean/radius^3;
