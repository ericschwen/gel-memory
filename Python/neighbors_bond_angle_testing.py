# -*- coding: utf-8 -*-
"""
Contact angles and nearest neighbors

Draft version uses contact range

Testing

4-12-18

Created on Thu Apr 12 14:04:05 2018

@author: Eric
"""

#def nearest_neighbors(path, c_range):
"""
nearest_neighbors

Calculates the nearest neighbors for every particle in a collection of
particles located by trackpy (also works for linked sets). Then calculates
the next-nearest neighbors (2nd shell) Saves the updated dataframe
to file.

Inputs:
    path: file path to features file
    c_range: contact range for determining which particles are in contact and
    should be included in the fabric tensor calculation


Created on 11/30/17
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
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p100\s_combined_o5\linked_mod.csv'
c_range = 2.1;

# Max range to be counted as in contact (in microns)
contact_range = c_range

# filepath to tp trajectories
features_file = path

df = pd.read_csv(features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in df.columns:
    del df['Unnamed: 0']

############################
# add an extra index column for testing
# save a varialbe equal to the original dataframe index for each particle at each time
# (used to combine dataframes later)
df['i'] = range(len(df))



# define distances in um instead of pixels (if not already done)
if not 'xum' in df.columns:
    df['xum'] = df['x'] * 0.127
    df['yum'] = df['y'] * 0.127
    df['zum'] = df['z'] * 0.12

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

# add particle column if not already there
if not 'particle' in df.columns:
    df['particle'] = np.arange(len(df))
    
# Add columns to dataframe for nearest neighbors and next nearest neighbors
a = np.empty([len(df), 1], dtype = object)
a[:] = 'none'
df.loc[:, 'neighbors'] = a
df.loc[:, 'next_nbs'] = a
df.loc[:, 'contacts'] = a


## Iterate through frames and find neighbors
#for frame in range(int(num_frames)):
    
# Alternate version to only use frame 0
for frame in range(0,1):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
        
    # create a temporary index for this frame
    f.loc[:, 'temp_index'] = np.arange(len(f))
    f = f.set_index('temp_index')
    
    # declare np array for positions
    positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))
       
    
    # find neighbors and nearest neighbors
    for i in range(len(positions)):
        
        # calculate the relative position vector. (Calculate for every other
        # particle in one step with repmat)
        # np.tile takes one row of the center matrix and repeats it for each other
        # row to make it the size of data. Then subtract to have distances.
    
        shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
    
        # Counter variable for the number of particles in contact.
        contact_count = 0
        # list for nearest neighbors
        neighbors = []

        # 
        for j in range(len(shift_vector)):
            distance = np.linalg.norm(shift_vector[j,:])
            if (distance < contact_range and distance != 0):
                contact_count = contact_count + 1
                # find name for particle and
                # append the neighboring particle to the neighbors list
                particle = int(f.at[j, 'particle'])
                neighbors.append(particle)
        
                #############
                # add to bond angle calculation for nearest neighbors
                vector = shift_vector[j,:]
                azi = np.arctan2(vector[1]/vector[0])*180/np.pi
                polar = np.arccos(vector[2]/distance)*180/np.pi
                
                
        f.at[i, 'neighbors'] = neighbors
        f.at[i, 'contacts'] = contact_count
        
        if (i % 1000) == 0:
            print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame))
    
#        #testing
#        f1 = f.copy()
    
    # add next nearest neighbors (after calculateing all neighbors)
    for k in range(len(f['neighbors'])):
        next_nearest = []
        # get list of nearest neighbors
        nn = f.at[k, 'neighbors']
        for entry in nn:
            # get the next nearest neighbors (for each nn)
            nxt_df = f.loc[f['particle'] == entry]['neighbors']
            nxt = nxt_df.values[0]
            for element in nxt:
                # add the next nearst neighbors
                if not element in next_nearest:
                    if not element == f.at[k, 'particle']:
                        next_nearest.append(element)
        f.at[k, 'next_nbs'] = next_nearest
                
    
    
    
    # reindex combined array by original dataframe index (saved as i)
    f = f.set_index('i', drop = False)
    
    # add the contact number to the dataframe features object
    #column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
    column_name = 'contacts'
    
    # update master dataframe if more than one frame
    if num_frames > 0:
        df.loc[df['frame']== frame, column_name] = f['contacts']
        df.loc[df['frame']== frame, 'neighbors'] = f['neighbors']
        df.loc[df['frame']== frame, 'next_nbs'] = f['next_nbs']
        

# Delete extra index column
del df['i'] 

## save file with contacts
#save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
##    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
#df.to_csv(save_filepath, index = False)
##return