# -*- coding: utf-8 -*-
"""
displacements_pd

Calculates the displacements in um in x, y, and z as well as net displacement
dr from a linked set of particles tracked through different frames by 
trackpy. Adds the calculated displacements to the data frame storing the
positions and saves as a csv. The displacemnt saved for each particle at each
time step is the the vector it WILL move for the next time step.

Inputs:
    linked_features_file from trackpy
    
Outputs:
    saves displacements in a csv

Created on Wed Jul 26 12:40:05 2017
@author: Eric   

Modification History:

To Do:
    Should probably make this a function which just takes the file path as
    an input
 
"""

# Import packages
import numpy as np
import pandas as pd
#import matplotlib as mpl
#import matplotlib.pyplot as plt
#mpl.rc('figure',  figsize=(10, 6))


# Define position columns for calculating displacements
pos_columns = ['xum', 'yum', 'zum']
  
# file path for linked particle positions from trackpy
linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\ampsweep_pre_train\1.4V\u_combined'
                        r'\linked_w_contacts.csv'
                        )
t = pd.read_csv(linked_features_file)

# delete unnamed column if necessary (left over from old indexing)
if 'Unnamed: 0' in t.columns:
    del t['Unnamed: 0']

# save a varialbe equal to the original dataframe index for each particle at each time
# (used to combine dataframes later)
t['i'] = range(len(t))

# read number of timesteps (aka frames)
if max(t['frame']) == 0:
    num_frames = 1
else:
    num_frames = (max(t['frame']) - min(t['frame'])) + 1

# Iterate through frames calculating displacements
for current_frame in range(num_frames):
    
    # Form sub-arrays with only data for current frame and next frame
    a = t.loc[t.frame == current_frame]
    b = t.loc[t.frame == current_frame + 1]
    
    # combine subarrays and index by particle number
    j = a.set_index('particle')[pos_columns + ['i']].join(
         b.set_index('particle')[pos_columns], rsuffix='_b')
    
    # calculate displacements
    for pos in pos_columns:
        j['d' + pos] = j[pos + '_b'] - j[pos]
        
    j['dr'] = np.sqrt(np.sum([j['d' + pos]**2 for pos in pos_columns], 0))
    
    # reindex combined array by original dataframe index (saved as i)
    j = j.set_index('i')
    
    # save calculated displacements to original dataframe of linked positions
    for pos in pos_columns:
        t.loc[t['frame'] == current_frame , 'd' + pos] = j[['d' + pos]]
        
    t.loc[t['frame'] == current_frame , 'dr'] = j['dr']
    
# Delete extra index column
del t['i']

# save file with displacements
save_filepath = linked_features_file[:-4] + '_w_displacements.csv'
t.to_csv(save_filepath, index = False)