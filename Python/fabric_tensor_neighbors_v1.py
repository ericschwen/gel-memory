# -*- coding: utf-8 -*-
"""
fabric_tensor_next_nearest

Calculates the "fabric tensor" for the second shell of particles. 

Takes inputs from features dataframe with nearest and next-nearest neighbors
labelled for each particle.

Works for features files with multiple linked frames but also for single frames.


Created on Fri Dec 01 10:06:24 2017

@author: Eric
"""

import pims
import trackpy as tp
import numpy as np
import pandas as pd
import ast

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# testing versions of path and c_range
#path = r'C:\Eric\Xerox\Python\peri\test\linked15_mod.csv'

def fabric_tensor_next_nearest(path):
    """ 
    Calculates the "fabric tensor" for the second shell of particles. 
    
    Inputs:
        path: file path for dataframe with nearest and next-nearest neighbors
    labelled for each particle.
    
    Works for features files with multiple linked frames but also for single frames.
    """
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
        
    # Add columns to dataframe for fabric tensor components
    a = np.empty([len(df), 1], dtype = object)
    a[:] = 'none'
    entries = ['xx','xy','xz','yx','yy','yz','zx','zy','zz']
    for entry in entries:
        df.loc[:, 'Z_2nd_' + entry] = a
    
        
    for frame in range(num_frames):
        
        if num_frames > 0:
            # create dataframe with just current frame
            f = df.loc[df['frame'] == frame]
        else:
            f = df
        
        # create a temporary index for this frame
        f.loc[:, 'temp_index'] = np.arange(len(f))
        f = f.set_index('temp_index')
        
        # loop through all particles and construct fabric tensor
        for i in range(len(f)):
            # record particle, position and neighbors
            #particle = f.at[i, 'particle']
#            neighbors = ast.literal_eval(f.at[i, 'neighbors'])
            next_nbs = ast.literal_eval(f.at[i, 'next_nbs'])
            pos = f.loc[i, ['xum', 'yum', 'zum']].values
            
            # create zeros fabric tensor
            fabric = np.zeros((3,3))
            
            for p in next_nbs:
                # calculate unit vector from particle to neighbor and add to fabric tensor
                # NOTE: can use neightbors or next_neighbors to get regular or 2nd level fabric tensor
                pos2 =  f.loc[f['particle'] == p, ['xum', 'yum', 'zum']].values[0]
                vector = pos2-pos
                unit_vector = vector/np.linalg.norm(vector)
                fabric = fabric + np.outer(unit_vector,unit_vector)
            
            # collapse fabric tensor to 1 dimension so I can add it to the dataframe
            fab_1d = fabric.flatten()
            
            # add the fabric tensor to the dataframe
            for j in range(len(entries)):
                f.at[i, 'Z_2nd_' + entries[j]] = fab_1d[j]
                
        
        # reindex combined array by original dataframe index (saved as i)
        f = f.set_index('i', drop = False)
        
        # update master dataframe if more than one frame
        if num_frames > 0:
            for entry in entries:
                df.loc[df['frame']==frame, 'Z_2nd_' + entry] = f['Z_2nd_' + entry]
    
    # Delete extra index column
    del df['i'] 
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
    #    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
    df.to_csv(save_filepath, index = False)
    return


def fabric_tensor_nearest(path):
    """ 
    Calculates the fabric tensor for a set of particles using labelled neighbors. 
    
    Inputs:
        path: file path for dataframe with nearest and next-nearest neighbors
    labelled for each particle.
    
    Works for features files with multiple linked frames but also for single frames.
    """
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
        
    # Add columns to dataframe for fabric tensor components
    a = np.empty([len(df), 1], dtype = object)
    a[:] = 'none'
    entries = ['xx','xy','xz','yx','yy','yz','zx','zy','zz']
    for entry in entries:
        df.loc[:, 'Z_' + entry] = a
    
        
    for frame in range(num_frames):
        
        if num_frames > 0:
            # create dataframe with just current frame
            f = df.loc[df['frame'] == frame]
        else:
            f = df
        
        # create a temporary index for this frame
        f.loc[:, 'temp_index'] = np.arange(len(f))
        f = f.set_index('temp_index')
        
        # loop through all particles and construct fabric tensor
        for i in range(len(f)):
            # record particle, position and neighbors
            #particle = f.at[i, 'particle']
            neighbors = ast.literal_eval(f.at[i, 'neighbors'])
            # next neighbors--only needed for 2nd shell fabric tensor
#            next_nbs = ast.literal_eval(f.at[i, 'next_nbs'])
            pos = f.loc[i, ['xum', 'yum', 'zum']].values
            
            # create zeros fabric tensor
            fabric = np.zeros((3,3))
            
            for p in neighbors:
                # calculate unit vector from particle to neighbor and add to fabric tensor
                # NOTE: can use neightbors or next_neighbors to get regular or 2nd level fabric tensor
                pos2 =  f.loc[f['particle'] == p, ['xum', 'yum', 'zum']].values[0]
                vector = pos2-pos
                unit_vector = vector/np.linalg.norm(vector)
                fabric = fabric + np.outer(unit_vector,unit_vector)
            
            # collapse fabric tensor to 1 dimension so I can add it to the dataframe
            fab_1d = fabric.flatten()
            
            # add the fabric tensor to the dataframe
            for j in range(len(entries)):
                f.at[i, 'Z_' + entries[j]] = fab_1d[j]
                
        
        # reindex combined array by original dataframe index (saved as i)
        f = f.set_index('i', drop = False)
        
        # update master dataframe if more than one frame
        if num_frames > 0:
            for entry in entries:
                df.loc[df['frame']==frame, 'Z_' + entry] = f['Z_' + entry]
    
    # Delete extra index column
    del df['i'] 
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
    #    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
    df.to_csv(save_filepath, index = False)
    return