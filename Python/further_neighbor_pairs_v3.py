# -*- coding: utf-8 -*-
"""
further_neighbor_pairs_v1

Add neighbors beyond 2 to data frame.

Mod Hist:
    v2: Add list_of_nns and keep nn3 from including nn1 results
    v3: Fixed bug that made layer 3 cound neighbors wrong. Should look for nn 
        of nn2 particles, not nn2 of nn2 particles. 4-13-18

Created on Thu Apr 12 17:24:31 2018

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
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod.csv'

LAYERS_TO_DO = [2, 3,4]

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

    
list_of_nns = ['particle', 'neighbors', 'nn2', 'nn3', 'nn4', 'nn5', 'nn6', 'nn7', 'nn8', 'nn9', 'nn10']


# Add columns to dataframe for nearest neighbors and next nearest neighbors
a = np.empty([len(df), 1], dtype = object)
a[:] = 'none'

for L in LAYERS_TO_DO:
    df.loc[:, list_of_nns[L]] = a

for frame in range(int(num_frames)):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
    
    
    # iterate through layers
    for L in LAYERS_TO_DO:
        
        # create a temporary index for this frame
        f.loc[:, 'temp_index'] = np.arange(len(f))
        f = f.set_index('temp_index')
        
        # set names for nn layers
        nn_prev = list_of_nns[L-1]
        nn_curr = list_of_nns[L]
        # iterate through all particles 
        for j in range(len(f)):
            # get list of nearest neighbors
            
            ## WEIRD##
            # not sure why sometimes a string
            nn = f.at[j, nn_prev]
            if type(nn) == str:
                nn = ast.literal_eval(nn)

                
            # declare an array for the next nearest
            nn2 = []
            for entry in nn:
                # get the next nearest neighbors (for each nn)
                nxt_df = f.loc[f['particle'] == entry][list_of_nns[1]]
                                
                ## WEIRD AGAIN##
                nxt = nxt_df.values[0]
                if type(nxt) == str:
                    nxt = ast.literal_eval(nxt)
                
                # check to see if already in previous list
                for element in nxt:
                    repeat = False
                    if element == f.at[j, 'particle']:
                        repeat = True
                    elif element in nn2:
                        repeat = True
                    else:
                        for layer in list_of_nns[1:L]:
                            ## WEIRD THIRD TIME"
                            nns_layer = f.at[j, layer]
                            if type(nns_layer) == str:
                                nns_layer = ast.literal_eval(nns_layer)
                                
                            if element in nns_layer:
                                repeat = True
                                break
                    if not repeat:
                        nn2.append(element)
                    
            f.at[j, nn_curr] = nn2
        
        
        # reindex combined array by original dataframe index (saved as i)
        f = f.set_index('i', drop = False)
    
        # update master dataframe if more than one frame
        if num_frames > 0:
            df.loc[df['frame']== frame, nn_curr] = f[nn_curr]
        
        print('Layer ' + str(L) + ' frame ' + str(frame) + ' done.')

# Delete extra index column
del df['i'] 

# save file with nn2
save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod_test.csv'
#    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
df.to_csv(save_filepath, index = False)
            
    