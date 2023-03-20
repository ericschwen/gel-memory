%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File for calculating which particles are connected in clusters for a 
% network of particles.

% Originally from Meera 9-13-17. Modified by Eric

% Distances in pixels (with z-axis scaled)
dr = 0.5;
LC = 5;
k = 1;

%%%Calculate the pairs of particles that are closer than a distance dr%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Net is the set of all pairs of particles that are connected.

for i = 1:1:length(ParPos)
center2 = ParPos - repmat(ParPos(i, :), length(ParPos), 1);
center2(:, 4) = sqrt(center2(:, 1).^2 + center2(:, 2).^2 + 0.9 * center2(:, 3).^2);
for j = i:1:length(ParPos)
if center2(j, 4) < ParRad(i) + ParRad(j)+dr
Net(k, :) = [i, j];
k = k+1;
end
end
clear center2
end
Net = Net(Net(:, 1)~= Net(:, 2), :); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

center = ParPos;
center(:, 4) = ParRad;
% Creates a column for cluster number
center(:, 5) = 0;
clusterNo = 1;

%%%%%%%%%% Determine which cluster the particles are in  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:1:length(Net)
    % if the first particle in the pair doesn't have a cluster number set yet
    if center(Net(i, 1), 5) == 0
        
        % if the second particle also doesn't have a cluster,
        % set both to the next new cluster number.
        if center(Net(i, 2), 5) == 0
            center(Net(i, 1), 5) = clusterNo;
            center(Net(i, 2), 5) = clusterNo;
            clusterNo = clusterNo + 1;
            
        % if the second particle does have a cluster number (and the first doesn't),
        % set its cluster number of the first to that of the second.
        else
            center(Net(i, 1), 5) = center(Net(i, 2), 5);
        end
        
    % if the first particle does have a cluster and the second does
    % not, set the particle nubmer for the second to that of the
    % first.
    else if center(Net(i, 2), 5) == 0
            center(Net(i, 2), 5) = center(Net(i, 1), 5);
            
        % if both particles already have cluster numbers, figure out
        % which cluster nubmer is lower and which is higher
        else
            temp = min(center(Net(i, 1), 5), center(Net(i, 2), 5));
            temp2 = max(center(Net(i, 1), 5), center(Net(i, 2), 5));
            
            % iterate through the master list and set all particles with
            % the larger cluster number to that of the smaller cluster
            % nubmer.
            for j = 1:1:length(center)
                if center(j, 5) == temp2
                center(j, 5) = temp;
                end
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get all particles with non-zero cluster nubmers (particles which have
% been assigned to a cluster)
ParNet = center(center(:, 5)~= 0, :);
% Sort the list by cluster number.
ParNetS = sortrows(ParNet, 5);

%%%%%%%%% Count the number of Particles in each cluster %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:1:max(ParNetS(:, 5))
    temp = ParNetS(ParNetS(:, 5) == i, :);
    ParNetS(ParNetS(:, 5)==i, 6) = size(temp, 1);
    clear temp
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LargeClus = ParNetS(ParNetS(:, 6)> LC);
% 
% figure
% scatter3(LargeClus(:, 1), LargeClus(:, 2), LargeClus(:, 3), 50*LargeClus(:, 4),  LargeClus(:, 5), 'Filled')

