function [VV, VV_mean_scaled, count] = void_volume_v5(File_in, Dx)

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
% VV_mean: mean void volume scaled by dividing by R^3
% count: number of positive entries in VV
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
% v5: fix R_void to subtract R_sphere 5-23-17.
% v6: added count and changed plotting 6-15-17.

%%
% % Sample file_in and dx
% File_in = ['C:\Eric\Xerox Data\30um gap runs\0.3333Hz 4-11-17\1.4V\zstack_post_sweep2_bpass3D_100slices\features.csv'];
% % Distance for one side of volume elements dV to iterate through
% Dx = 0.125;

file_in = File_in;
dx = Dx;

% Radius of particles (in microns)
radius = 1.0;

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

% Using positions from middle region. Set range in microns to survey over
% for each dimension.
xrange = 50;
yrange = 20;
zrange = 5;
xiter = xmid-xrange/2:dx:xmid+xrange/2;
yiter = ymid-yrange/2:dx:ymid+yrange/2;
ziter = zmid-zrange/2:dx:zmid+zrange/2;
% Should probably add a check here to make sure the choices don't go
% outside of the range of where the particles are.

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

% Create a matrix dV_positions with the x, y, and z positions for each site
% dV to be surveyed.
[X,Y,Z] = meshgrid(xiter, yiter, ziter);
dV_positions = [X(:),Y(:),Z(:)];


% Calculate VV for each dV
parfor ff = 1:length(dV_positions)
    % Calcuate vector from dV from all particle positions. repmat creates a
    % matrix of just the single position repeated.
    displacements = abs(particle_positions - ...
        repmat(dV_positions(ff,:), length(particle_positions), 1));
    % Calculate norms (distances)
    norms = sqrt(sum(displacements.^2,2));
    radius_void = min(norms)-radius;
    % Ignore norms that are less than the radius (point is inside a
    % particle)
    VV(ff) = 4/3*pi*radius_void^3;

end

% Note: need to remove/ignore all 'volumes' less than 0. These are the
% points that are actually inside the particles.

VV_scaled = VV/radius^3;
% note that for radius = 1um, VV_scaled = VV.

% Take mean by summing VV and dividing by the number of summed terms.
% Unclear whether I should be excluding 0 and negative terms (though I
% could probalby set all negative terms to 0 anyway. These should just come
% from 
% Need to exclude negative values from mean
total = 0;
count = 0;
for i = 1:length(VV)
    if VV(i) > 0
        total = total + VV(i);
        count = count + 1;
    end
end
VV_mean = total/count;
% VV_mean = mean(VV);
VV_mean_scaled = VV_mean/radius^3;


% %% Plotting Histogram
% 
% % Plot a histogram of the void volume. normalize by the count of positive
% % VV entries
% figure;
% h = histogram(VV_scaled);
% normValues = h.Values/count;
% binEdges = h.BinEdges(1:end-1);
% binLimits = h.BinLimits;
% binWidth = h.BinWidth;
% 
% loglog(binEdges, normValues, 'bo', 'MarkerSize', 3)
% xlabel('VV/R^3')
% ylabel('VV PDF')
% title('VV histogram')
% xlim([10^(-3) 2])
% 
% % % Checking to see that positive histogram entries now add to 1.
% % sum(normValues(138:end));
end
