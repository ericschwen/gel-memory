# -*- coding: utf-8 -*-
"""
further_neighbor_pairs_v1

Add neighbors beyond 2 to data frame.

Created on Thu Apr 12 17:24:31 2018

@author: Eric
"""

# -*- coding: utf-8 -*-
"""
next_nearest_neighbors_v1

Takes data frame (linked or no) with nearest neighbors already found and adds next nearest neighbors.

Created on Thu Apr 12 16:53:40 2018

@author: Eric
"""

import pims, ast
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


# Examples for input variables
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\u_combined_o5\linked_mod.csv'

# filepath to tp trajectories
features_file = path

df = pd.read_csv(features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in df.columns:
    del df['Unnamed: 0']
    
# save a varialbe equal to the original dataframe index for each particle at each time
# (used to combine dataframes later)
df['i'] = range(len(df))
    
# find number of frames or 
if 'frame' in df.columns:
    # number of timesteps (aka frames)
    if max(df['frame']) == 0:
        num_frames = 1
    else:
        num_frames = (max(df['frame']) - min(df['frame'])) + 1    
else:
    # add a frame column identical to zero to make rest of code work
    df['frame'] = np.zeros(len(df))
    num_frames = 1

# Add columns to dataframe for nearest neighbors and next nearest neighbors
a = np.empty([len(df), 1], dtype = object)
a[:] = 'none'
df.loc[:, 'nn3'] = a
df.loc[:, 'nn4'] = a

    
for frame in range(int(num_frames)):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
    
    
    # iterate through layers
    for L in [3]:
        
        # create a temporary index for this frame
        f.loc[:, 'temp_index'] = np.arange(len(f))
        f = f.set_index('temp_index')
        
        # set names for nn layers
        nn_prev = 'nn' + str(L-1)
        nn_curr = 'nn' + str(L)
        # iterate through all particles 
        for j in range(len(f)):
            # get list of nearest neighbors
            nn = ast.literal_eval(f.at[j, nn_prev])
            # declare an array for the next nearest
            nn2 = []
            for entry in nn:
                # get the next nearest neighbors (for each nn)
                nxt_df = f.loc[f['particle'] == entry][nn_prev]
                nxt = ast.literal_eval(nxt_df.values[0])
                for element in nxt:
                    # add the next nearst neighbors after checking
                    # Not already in nn2
                    if not element in nn:
                        # not already in nn (maybe leave this part if we want loops?)
                        if not element in nn2: #### WRONG! NEED TO PULL NN2
                            # not original particle
                            if not element == f.at[j, 'particle']:
                                nn2.append(element)
            f.at[j, nn_curr] = nn2
        
        
        # reindex combined array by original dataframe index (saved as i)
        f = f.set_index('i', drop = False)
    
        # update master dataframe if more than one frame
        if num_frames > 0:
            df.loc[df['frame']== frame, nn_curr] = f[nn_curr]

# Delete extra index column
del df['i'] 

# save file with nn2
save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod_test.csv'
#    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
df.to_csv(save_filepath, index = False)
            
    