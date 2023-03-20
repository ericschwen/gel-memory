# -*- coding: utf-8 -*-
"""
surface_separation_neighbors

Code for calculating surface separation between particles and using it to find
nearest neighbors.Takes positional data and radii found by PERI. Assumes that
data is already put into a dataframe using a file such as peri_build_df_v3.

Mod History:
    v2: Change surface separation to nm instead of um. More readable. 4-17-19
Created on Wed Oct 03 13:17:10 2018

@author: Eric
"""

import numpy as np
import pandas as pd


def surf_sep_neighbors(path, c_range):
    """
    surf_sep_neighbors
    
    Calculates the nearest neighbors for every particle in a collection of
    particles located by PERI (also works for sets linked by trackpy). Must
    have radii from PERI. Saves the updated dataframe.
    to file.
    
    Inputs:
        path: file path to features file
        c_range: surface-to-surface contact range for determining which
        particles are in contact and should be included calculation in nm.
    
    
    """
    
    # Max range to be counted as in contact (in nm). Range is measured
    # as the surface separation between the particles.
    contact_range = c_range
    contact_range_um = contact_range/1000.
    
    # filepath to tp trajectories
    features_file = path
    # sample path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\test\linked_peri_mod.csv'
    
    df = pd.read_csv(features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in df.columns:
        del df['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    # save a varialbe equal to the original dataframe index for each particle at each time
    # (used to combine dataframes later)
    df['i'] = range(len(df))
    
    # Code to check for missing columns and add them if necessary  
    
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
        
    # add a column for rad_um if not already there
    # radius conversion uses xy pixel size (confirmed correct with Meera/Brian)
    if not 'rad_um' in df.columns:
        df['rad_um'] = df['rad'] * 0.127
        
    # Add columns to dataframe for nearest neighbors
    a = np.empty([len(df), 1], dtype = object)
    a[:] = 'none'
    df.loc[:, 'neighbors'] = a
#    df.loc[:, 'next_nbs'] = a
    df.loc[:, 'contacts'] = a
        
        
    for frame in range(int(num_frames)):
        
        if num_frames > 0:
            # create dataframe with just current frame
            f = df.loc[df['frame'] == frame]
        else:
            f = df
            
        # create a temporary index for this frame
        f.loc[:, 'temp_index'] = np.arange(len(f))
        f = f.set_index('temp_index')
        
        # declare np array for positions
#        positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))
        pos_rad = np.transpose(np.array([f['xum'],f['yum'], f['zum'], f['rad_um']]))
           
        
        # find neighbors and nearest neighbors
        for i in range(len(pos_rad)):
            
            # calculate the relative position vector. (Calculate for every other
            # particle in one step with repmat)
            # np.tile takes one row of the center matrix and repeats it for each other
            # row to make it the size of data. Then subtract to have distances.
        
#            shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
            
            shift_vector = abs(pos_rad[:,0:3] - np.tile(pos_rad[i,0:3], (len(pos_rad),1)))
        
            # Counter variable for the number of particles in contact.
            contact_count = 0
            # list for nearest neighbors
            neighbors = []
    
            # select neighbors
            for j in range(len(shift_vector)):
                # center to center distance
                c2c_distance = np.linalg.norm(shift_vector[j,:])
                if c2c_distance != 0:
                    # surface separation = c2c-r1-r2
                    surf_sep = c2c_distance-pos_rad[i,3] - pos_rad[j,3]
                    if (surf_sep < contact_range_um):
                        contact_count = contact_count + 1
                        # find name for particle and
                        # append the neighboring particle to the neighbors list
                        particle = int(f.at[j, 'particle'])
                        neighbors.append(particle)
            
            f.at[i, 'neighbors'] = neighbors
            f.at[i, 'contacts'] = contact_count
            
            if (i % 1000) == 0:
                print(str(i) + '/' + str(len(pos_rad)) + ' in frame ' + str(frame))
        
#        #testing
#        f1 = f.copy()
       
        ############################
#        # add next nearest neighbors (after calculateing all neighbors)
#        for k in range(len(f['neighbors'])):
#            next_nearest = []
#            # get list of nearest neighbors
#            nn = f.at[k, 'neighbors']
#            for entry in nn:
#                # get the next nearest neighbors (for each nn)
#                nxt_df = f.loc[f['particle'] == entry]['neighbors']
#                nxt = nxt_df.values[0]
#                for element in nxt:
#                    # add the next nearst neighbors
#                    if not element in next_nearest:
#                        if not element == f.at[k, 'particle']:
#                            next_nearest.append(element)
#            f.at[k, 'next_nbs'] = next_nearest
#                    
#        
        
                
        # reindex combined array by original dataframe index (saved as i)
        f = f.set_index('i', drop = False)
        
        # add the contact number to the dataframe features object
#        contacts_column_name = 'contacts_' + str(contact_range).split('.')[0] + 'pt' + str(contact_range).split('.')[1] + 'um'
        contacts_column_name = 'contacts_' + str(contact_range) +'nm'
       
        # update master dataframe if more than one frame
        if num_frames > 0:
            df.loc[df['frame']== frame, contacts_column_name] = f['contacts']
            df.loc[df['frame']== frame, 'neighbors'] = f['neighbors']
            #####################################
#            df.loc[df['frame']== frame, 'next_nbs'] = f['next_nbs']
            
    
    # Delete extra index column
    del df['i'] 
    
    # Delete the contacts column (not actually used to save anything. just temporary)
    # I could get rid of that part of the code entirely, but it's extra work not worth
    del df['contacts']
    
    # save file with contacts
#    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_peri_mod.csv'
    save_filepath = features_file
    df.to_csv(save_filepath, index = False)
    return