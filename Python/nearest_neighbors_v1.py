# -*- coding: utf-8 -*-

"""
nearest_neighbors


calculates the nearest neighbors for every particle in a collection of
particles located by trackpy (also works for linked sets). Saves the
updated dataframe object to file.

Inputs:
    path: file path to features file
    c_range: contact range for determining which particles are in contact and
    should be included in the fabric tensor calculation


Created on Mon Oct 23 10:56:10 2017

@author: Eric
"""
import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# testing versions of path and c_range
path = r'C:\Eric\Xerox\Python\peri\test\linked15.csv'
c_range = 2.5

#def fabric_tensor_positions(path, c_range):
  
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
    
for frame in range(num_frames):
    
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
       
#    # define a trace structure for the trace of the fabric tensor
#    trace = np.zeros(len(f))

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
        
        f.at[i, 'neighbors'] = neighbors
        f.at[i, 'contacts'] = contact_count
        
        if (i % 1000) == 0:
            print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
    
    # reindex combined array by original dataframe index (saved as i)
    f = f.set_index('i', drop = False)
    
    # add the contact number to the dataframe features object
    #column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
    column_name = 'contacts'
    
    # update master dataframe if more than one frame
    if num_frames > 0:
        df.loc[df['frame']== frame, column_name] = f['contacts']
        df.loc[df['frame']== frame, 'neighbors'] = f['neighbors']
        

# Delete extra index column
del df['i'] 

# save file with contacts
save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\neighbors.csv'
#    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
df.to_csv(save_filepath, index = False)
#    return