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
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.8\u_combined_o5\linked_mod.csv'
c_range = 2.5
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
    mod2: Average over multiple frames. NOT WORKING YET
"""
# Max range to be counted as in contact (in microns)
contact_range = c_range

# filepath to tp trajectories
linked_features_file = path

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']


# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.127
    linked['yum'] = linked['y'] * 0.127
    linked['zum'] = linked['z'] * 0.12


mobile = linked.loc[linked['dr_adj_full'] > 0.23]

# create dataframe with just current frame

# restrict to single frame if wanted
f_mobile = mobile.loc[mobile['frame'] == 0]
f_mobile = mobile

# number of timesteps (aka frames)
if max(f_mobile['frame']) == 0:
    num_frames = 1
else:
    num_frames = int((max(f_mobile['frame']) - min(f_mobile['frame'])) + 1)

#f = f_mobile[['xum', 'yum', 'zum']]

for frame in range(num_frames-1):

    # declare np array for positions
    positions = np.transpose(np.array([f_mobile['xum'],f_mobile['yum'], f_mobile['zum']]))
    
    # define an array for connected pairs of particles
    net = []
    
    # define arrays for network number
    net_num = np.zeros(len(f_mobile)) # Declare an array 
    
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
    f_mobile['network'] = net_num
    
    mobile.loc[mobile['frame'] == frame , 'network'] = f_mobile['network']

## save file with displacements
#save_filepath = mobile_features_file[:-4] + '_w_network.csv'
#mobile.to_csv(save_filepath, index = False)
#
#save_short_filepath = mobile_features_file[:-4] + '_w_network_short.csv'
#f.to_csv(save_short_filepath, index = False)


##############################################################################
# analysis of network results

# declare arrays for sizes and counts
sizes = []
counts = []

for frame in range(num_frames-1):
    
    #select individual frame
    df = mobile.loc[mobile['frame'] == frame]
    
    
    # count number of particles in each cluster
    sizes = []
    for i in range(int(max(df.network.values))):
        count = 0
        for num in df.network.values:
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
    
    sizes = np.array(sizes)
    counts = np.array(sizes[1:,1])
    
    sortedcounts = np.flip(np.sort(counts), 0)
     # Optional section to calcualte contact numer distribution 
            
     
    plt.hist(counts, bins = np.max(counts))
    plt.xlabel('Cluster Size', fontsize = 18)
    plt.ylabel('Count', fontsize = 18)
    #plt.title('Cluster Size Histogram', fontsize = 18)
    #plt.axis([0, 550, 0.1, 0.35 ])
    #plt.legend(loc = 'upper right', fontsize = 18)
    plt.tick_params(labelsize=18)
    plt.show()   
    
    plt.bar(range(len(sortedcounts)),sortedcounts)
    
    plt.xlabel('One bar per cluster', fontsize = 18)
    plt.ylabel('Cluster size', fontsize = 18)
    #plt.title('Contact Number Histogram', fontsize = 18)
    #plt.axis([0, 550, 0.1, 0.35 ])
    #plt.legend(loc = 'upper right', fontsize = 18)
    plt.tick_params(labelsize=18)
    plt.show()   
    
    print(sizes[0])
    percent_singles = sizes[0,1] / float(len(f_mobile))
    print('percent singels: ' + str(percent_singles))
    
    
    
#==============================================================================
# # add the contact number to the dataframe features object
# mobile.loc[mobile['frame']== frame, 'contacts'] = contacts
#         
#         # save file with contacts
# save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
# mobile.to_csv(save_filepath, index = False)
#==============================================================================
#    return