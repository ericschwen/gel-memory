# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 16:01:05 2017

@author: Eric
"""

#import pims
#import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# variables if not running as function
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\linked_w_displacements.csv'
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\0.6\u_combined_o5\linked_mod.csv'
c_range = 2.5
t_frame = 0
mobility_cutoff = 0.23
only_mobile = True


#def particle_networks(path, c_range, t_frame):
"""
particle_networks

Takes particle positions and calculates all networks of particles with particle
separation less than the contact range. Saves the cluster nubmer information
to the data frame


Inputs:
    particle positions created by tp.locate
    contact range in um established by first min in g(r)
Outputs:
    cluster number added to dataframe
    
Notes:
    
Modification History:
    v1: 9-14-17
    mod1: restrict to only mobile particles
"""
# Max range to be counted as in contact (in microns)
contact_range = c_range

# filepath to tp trajectories
linked_features_file = path

# sepcific frame to look at
frame = t_frame

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']


# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.127
    linked['yum'] = linked['y'] * 0.127
    linked['zum'] = linked['z'] * 0.12

#if only_mobile:    
mobile = linked.loc[linked['dr_adj_full'] > 0.23]

# create dataframe with just current frame
f_mobile = mobile.loc[mobile['frame'] == frame]

f = f_mobile[['xum', 'yum', 'zum']]
#else:    
#    # create dataframe with just current frame
#    f_frame= linked.loc[linked['frame'] == frame]
#    
#    f = f_frame[['xum', 'yum', 'zum']]

# declare np array for positions
positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))

# define an array for connected pairs of particles
net = []

# define arrays for network number
net_num = np.zeros(len(f)) # Declare an array 

###############################################################################
# Find all particles in contact
for i in range(len(positions)):
    
    # calculate the relative position vector. (Calculate for every other
    # particle in one step with repmat)
    # np.tile takes one row of the center matrix and repeats it for each other
    # row to make it the size of data. Then subtract to have distances.

    shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
    
#     # Limit to selected max range rc if wanted.
#     shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:)

    # declare array for distances from the individual particle.
    distances = np.zeros(len(shift_vector))

    
    for j in range(len(shift_vector)):
        distances[j] = np.linalg.norm(shift_vector[j,:])
        
        # add the particel pair to net if the pair of particle is in contact
        if (distances[j] < contact_range and distances[j] != 0):
            net.append([i, j])
    
#    # print output keeps track of progress.
#    if (i % 1000) == 0:
#        print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')

###############################################################################
# Sort the particles into networks

clusterNo = 1

for i in range(len(net)):
    # if the first particle in the pair doesn't have a cluster number set yet
    if net_num[net[i][0]] == 0:
        # if the second particle also doesn't have a cluster,
        # set both to the next new cluster number.
        if net_num[net[i][1]] == 0:
            net_num[net[i][0]] = clusterNo
            net_num[net[i][1]]= clusterNo
            clusterNo = clusterNo + 1
            
        # if the second particle does have a cluster number (and the first doesn't),
        # set its cluster number of the first to that of the second.
        else:
            net_num[net[i][0]] = net_num[net[i][1]]
            
    
    else:
        # if the first particle DOES have a cluster and the second does
        # not, set the particle nubmer for the second to that of the
        # first.
        if net_num[net[i][1]] == 0:
            net_num[net[i][1]] = net_num[net[i][0]]
            
        # if both particles already have cluster numbers, figure out
        # which cluster number is lower and which is higher
        ######## Could add code to check if they are already the same cluster number.
        ######## might be more efficient.
        else:
            temp1 = min(net_num[net[i][0]], net_num[net[i][1]])
            temp2 = max(net_num[net[i][0]], net_num[net[i][1]])
            
            # iterate through the master list and set all particles with
            # the larger cluster number to that of the smaller cluster
            # nubmer.
            for j in range(len(net_num)):
                if net_num[j] == temp2:
                    net_num[j] = temp1
                

# Save the results to the data frame
f['network'] = net_num

mobile.loc[mobile['frame'] == frame , 'network'] = f['network']

## save file with displacements
#save_filepath = mobile_features_file[:-4] + '_w_network.csv'
#mobile.to_csv(save_filepath, index = False)
#
#save_short_filepath = mobile_features_file[:-4] + '_w_network_short.csv'
#f.to_csv(save_short_filepath, index = False)


##############################################################################
# analysis of network results

## sorted by network number
#fs = f.sort_values( by= 'network')

# count number of particles in each cluster
sizes = []
for i in range(int(max(f.network.values))):
    count = 0
    for num in f.network.values:
        if num == i:
            count = count + 1
    sizes.append([i, count])
    
# remove entries with no particles in them
to_remove = []
for entry in sizes:
    if entry[1] == 0:
#        sizes.remove(entry)
        to_remove.append(entry)
for entry in to_remove:
    sizes.remove(entry)

# sizes array is [network identifier number, size]
sizes = np.array(sizes)
sizes_list = np.array(sizes[1:,1])

sorted_sizes_list = np.flip(np.sort(sizes_list), 0)
 # Optional section to calcualte contact numer distribution 
        
 
plt.hist(sizes_list, bins = np.max(sizes_list))
plt.xlabel('Cluster Size', fontsize = 18)
plt.ylabel('Count', fontsize = 18)
#plt.title('Cluster Size Histogram', fontsize = 18)
#plt.axis([0, 550, 0.1, 0.35 ])
#plt.legend(loc = 'upper right', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show()   

plt.bar(range(len(sorted_sizes_list)),sorted_sizes_list)

plt.xlabel('One bar per cluster', fontsize = 18)
plt.ylabel('Cluster size', fontsize = 18)
#plt.title('Contact Number Histogram', fontsize = 18)
#plt.axis([0, 550, 0.1, 0.35 ])
#plt.legend(loc = 'upper right', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show()   

#print(sizes[0])
percent_singles = sizes[0,1] / float(len(f_mobile))
print('singles = ' + str(sizes[0,1]) + '/' + str(len(f_mobile)))
print('Percent singels: ' + str(percent_singles))

max_cluster_size = np.max(sizes_list)
mean_cluster_size = np.mean(sizes_list)
median_cluster_size = np.median(sizes_list)
print('biggest cluster: ' + str(max_cluster_size))
print('mean size: ' + str(mean_cluster_size))
print('median size: ' + str(median_cluster_size))

###############################################################
## For adding multiple frames
#full_sizes_list = np.append(full_sizes_list, sizes_list)


#####################################################
## analysis of full sizes list
#full_max_cluster_size = np.max(full_sizes_list)
#full_mean_cluster_size = np.mean(full_sizes_list)
#full_median_cluster_size = np.median(full_sizes_list)
#print('biggest cluster: ' + str(max_cluster_size))
#print('mean size: ' + str(mean_cluster_size))
#print('median size: ' + str(median_cluster_size))
#
#
#sorted_full_sizes_list = np.flip(np.sort(full_sizes_list), 0)
#
#plt.hist(full_sizes_list, bins = np.max(full_sizes_list))
#plt.xlabel('Cluster Size', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
##plt.title('Cluster Size Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()   
#
#
#
#plt.bar(range(len(sorted_full_sizes_list)),sorted_full_sizes_list)
#plt.xlabel('One bar per cluster', fontsize = 18)
#plt.ylabel('Cluster size', fontsize = 18)
##plt.title('Contact Number Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()   
#
#
#save_filepath = linked_features_file[:-4] + '-mobile_cluster_sizes.txt'
#np.savetxt(save_filepath, sorted_full_sizes_list)






#==============================================================================
# # add the contact number to the dataframe features object
# mobile.loc[mobile['frame']== frame, 'contacts'] = contacts
#         
#         # save file with contacts
# save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
# mobile.to_csv(save_filepath, index = False)
#==============================================================================
#    return