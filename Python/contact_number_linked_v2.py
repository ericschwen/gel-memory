# -*- coding: utf-8 -*-
"""
contact_number_linked

Calculates number of particles in 'contact' with each particle in a collection
of LINKED particles located by trackpy. Modified from my original Matlab code
for finding contact numbers.

Inputs:
    features created by tp.locate
    contact range established by first min in g(r)
Outputs:
    contact numbers added to dataframe

Created on Tue Jul 25 00:59:10 2017

@author: Eric

Modification History:

    
Notes:
    Can also run this program for displacements data (linked features with
    displacements already calculated) to add contact numbers there.
    
"""
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# Max range to be counted as in contact (in microns)
contact_range = 2.8

# filepath to tp trajectories
linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\ampsweep_pre_train\1.4V\u_combined'
                        r'\linked.csv'
                        )

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']

############################
# add an extra index column for testing

# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.125
    linked['yum'] = linked['y'] * 0.125
    linked['zum'] = linked['z'] * 0.12

# number of timesteps (aka frames)
if max(linked['frame']) == 0:
    num_frames = 1
else:
    num_frames = (max(linked['frame']) - min(linked['frame'])) + 1

for frame in range(num_frames):
    
    # create dataframe with just current frame
    f = linked.loc[linked['frame'] == frame]
    
    # declare np array for positions
    positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))
       
    # define arrays for conacts
    contacts = np.zeros(len(f)) # Declare an array 


    for i in range(len(positions)):
        
        # calculate the relative position vector. (Calculate for every other
        # particle in one step with repmat)
        # np.tile takes one row of the center matrix and repeats it for each other
        # row to make it the size of data. Then subtract to have distances.
    
        shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
        
    #     # Limit to selected max range rc.
    #     shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:)
        distances = np.zeros(len(shift_vector))
    
        # Counter variable for the number of particles in contact.
        contact_count = 0
        
        for j in range(len(shift_vector)):
            distances[j] = np.linalg.norm(shift_vector[j,:])
            if (distances[j] < contact_range and distances[j] != 0):
                contact_count = contact_count + 1
        
        contacts[i] = contact_count
    
        if (i % 1000) == 0:
            print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
    
        # add the contact number to the dataframe features object
        linked.loc[linked['frame']== frame, 'contacts'] = contacts

    
#==============================================================================
#     ####################################
#     # Optional section to calcualte contact numer distribution 
#            
#     h, bin_edges = np.histogram(contacts, bins=np.arange(16), density = False)
#     # plot the histogram
#     plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
#     plt.xlim(min(bin_edges), max(bin_edges))
#     plt.ylim(0, max(h))
#     plt.xlabel('Contacts', fontsize = 18)
#     plt.ylabel('Count', fontsize = 18)
#     plt.title('Contact Number Histogram', fontsize = 18)
#     #plt.axis([0, 550, 0.1, 0.35 ])
#     #plt.legend(loc = 'upper right', fontsize = 18)
#     plt.tick_params(labelsize=18)
#     plt.show()   
#     
#     mean_contacts = np.mean(contacts)
#     
# #    # mins and maxes in case i want to limit sections
# #    xmin = min(f['xum'])
# #    ymin = min(f['yum'])
# #    zmin = min(f['zum'])
# #    
# #    xmax = max(f['xum'])
# #    ymax = max(f['yum'])
# #    zmax = max(f['zum'])
#     #####################################
#==============================================================================

# save file with contacts
save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
linked.to_csv(save_filepath, index = False)

