# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 01:25:39 2017

@author: Eric

Define custom trackpy functions for locating and tracking particles

Modification Hisotry:
    v2: comment out displacements_3d histogram and statistics saving. probably 
    not going to be using that now that I can just save the actual displacemnts
    to the csv.
    
    v3: add displacements_pd function and contact_number_linked_v2 function.
    v4: add adj_displacement function to subtract net drift from displacements
    v5: change saving to just have linked_mod.csv for all modified files.
    v6: change to 15 pixel diameter and 13 separation
    v7: change search range to 1.5 um. also add linking function.
    v8: add dr_adj_xy to the adj_displacements function. Change tracking range back to 1.0.
    v9: change contact_number function to save with contact range used in column name.
    v10: added fabric_tensor_linked function
    v11: fixed fabric_tensor functions to remove abs() from vector
    v12: added nearest_neighbors and fabric_tensor_neighbors functions. Also
        get rid of 15 references in save files. 12/5/17
    v13 Commented out next neighbors from the nearest_neighbors code. Now have the
        further_neighbors_v2 which can calculate whatever neighbor layer you want. 4-12-18
    v14: Change file naming scheme for adj displacements and displacements pd to work
        better with PERI data. 4-15-19
    v15: modify displacements_pd function to allow for selections of frames that
        don't start from 0. 2-27-20
    v16: add function for adjusting positions to remove drift. Based on adjusted
        displacements. 3-2-20
"""
import pims, ast
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


def tracking_3d_stacks(path):
    """ Track particles through a set of zstacks. Runs trackpy's particle locating
    and linking functions with custom variables. This function just makes it easier to 
    run easily with my own parameters.
    Input: path to a file with prefiltered tiff images named with time and z indices.
    
    Saves csv files for positions, linked positions, and msd (msd currently
    commented out).
    """
    
    # Sample path
    # path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\3.0V\u_combined\*.tif';
    
    frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
    # frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
    frames.iter_axes = 't'
    
    # run locate function
    f = tp.batch(frames, diameter=(15,15,15), invert = False, separation = (11,11,11),
                 preprocess = False, minmass = 40000)
    
    #Save the data to csv file
    f.to_csv(path[:-5] + 'positions.csv', index = False)
    # define distances in um instead of pixels
    f['xum'] = f['x'] * 0.127
    f['yum'] = f['y'] * 0.127
    f['zum'] = f['z'] * 0.12
    
    # link particles
    linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])
    
    #Save the data to csv file
    linked.to_csv(path[:-5] + 'linked.csv', index = False);

#==============================================================================
#     # calculate 3D msd
#     msd3D = tp.emsd(linked, mpp=1, fps=1, max_lagtime=20,
#                 pos_columns=['xum', 'yum', 'zum'])
# 
#     #Save the msd to csv file
#     msd3D.to_csv(path[:-5] + 'msd3D.csv');
#==============================================================================
                
    return

def link_custom(path):
    """ Link featues (if not done with tracking stacks for some reason). 
    Takes combined tifs inputs like tracking_3d
    """
      
    # file path for linked particle positions from trackpy
    features_file = path[:-5] + 'positions.csv'
    # Example path: r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\
    # ampsweep_pre_train\1.4V\u_combined\linked_w_contacts.csv'
    
    f = pd.read_csv(features_file)
    
    # delete unnamed column if necessary (left over from old indexing)
    if 'Unnamed: 0' in f.columns:
        del f['Unnamed: 0']

    # define distances in um instead of pixels
    f['xum'] = f['x'] * 0.127
    f['yum'] = f['y'] * 0.127
    f['zum'] = f['z'] * 0.12
    
    # link particles
    linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])
    
    #Save the data to csv file
    linked.to_csv(path[:-5] + 'linked.csv', index = False);
    
    return

#=========================================================================

def displacements_pd(path):
    """
    Calculates the displacements in um in x, y, and z as well as net displacement
    dr from a linked set of particles tracked through different frames by 
    trackpy. Adds the calculated displacements to the data frame storing the
    positions and saves as a csv. The displacemnt saved for each particle at each
    time step is the the vector it WILL move for the next time step.
    
    Inputs:
        path to linked_features_file from trackpy
        
    Outputs: none
        (saves displacements in a csv)
    """
    # Define position columns for calculating displacements
    pos_columns = ['xum', 'yum', 'zum']
      
    # file path for linked particle positions from trackpy
    linked_features_file = path
    # Example path: r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\
    # ampsweep_pre_train\1.4V\u_combined\linked_w_contacts.csv'
    
    t = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary (left over from old indexing)
    if 'Unnamed: 0' in t.columns:
        del t['Unnamed: 0']
    
    # save a variabe equal to the original dataframe index for each particle at each time
    # (used to combine dataframes later)
    t['i'] = range(len(t))
    
#    # read number of timesteps (aka frames) OLD IMPLEMENTATION
#    if max(t['frame']) == 0:
#        num_frames = 1
#    else:
#        num_frames = int((max(t['frame']) - min(t['frame'])) + 1)
        
    # read which frames are present
    first_frame = int(np.min(t.frame.values))
    last_frame = int(np.max(t.frame.values))
    
    # Iterate through frames calculating displacements
    for current_frame in range(first_frame, last_frame):
        
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
    save_filepath = '\\'.join(path.split('.')[:-1]) + r'_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_displacements.csv'
    t.to_csv(save_filepath, index = False)
    
    return

def adj_displacements(path):
    """
    Calculates the mean displacements in um in x, y, and z. Subtracts this mean
    displacement from the measured displacements_pd results to get a adjusted
    displacement. Adds the calculated displacements to the data frame storing the
    positions and saves as a csv. The displacemnt saved for each particle at each
    time step is the the vector it WILL move for the next time step.
    
    Probably will just use shift in x direction, but calculate all anyway.
    
    Inputs:
        path to linked_features_file with displacements from trackpy and
        displacements_pd
        
    Outputs:
        saves displacements in a csv
    """
    # Define position columns for calculating displacements
    pos_columns = ['dxum', 'dyum', 'dzum']
      
    # file path for linked particle positions from trackpy
    linked_features_file = path
    # Example path: r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\
    # ampsweep_pre_train\1.4V\u_combined\linked_w_contacts_w_displacements.csv'
    
    t = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary (left over from old indexing)
    if 'Unnamed: 0' in t.columns:
        del t['Unnamed: 0']
        
    # save a varialbe equal to the original dataframe index for each particle at each time
    # (used to combine dataframes later)
    t['i'] = range(len(t))
    
    
#    # Old implementation
#    # read number of timesteps (aka frames)
#    if max(t['frame']) == 0:
#        num_frames = 1
#    else:
#        num_frames = int((max(t['frame']) - min(t['frame'])) + 1)
#    
#    # Iterate through frames calculating average displacements
#    for current_frame in range(num_frames-1):  
    
    # read which frames are present
    first_frame = int(np.min(t.frame.values))
    last_frame = int(np.max(t.frame.values))
    
    # Iterate through frames calculating displacements
    for current_frame in range(first_frame, last_frame):
        

        
        # Form sub-arrays with only data for current frame
        a = t.loc[t.frame == current_frame]
        
        # look only at position particles and particle
        j = a.set_index('particle')[pos_columns + ['i']]
        
        # calculate mean displacements        
        dxs_full = j.dxum.values
        dxs = dxs_full[np.isfinite(dxs_full)]
        dx_mean = np.mean(dxs)
        dys_full = j.dyum.values
        dys = dys_full[np.isfinite(dys_full)]
        dy_mean = np.mean(dys)
        dzs_full = j.dzum.values
        dzs = dzs_full[np.isfinite(dzs_full)]
        dz_mean = np.mean(dzs)
    
        # calculate adjusted/effective displacements
        for pos in pos_columns:
            # testing locals()
            #print(locals()['dx_mean'])
            j[pos + '_adj'] = j[pos] - locals()['d' + pos[1] + '_mean']
            # other implementation
    #            a[pos + '_adj'] = a[pos] - eval('d' + pos[1] + '_mean')
        
        # reindex combined array by original dataframe index (saved as i)
        j = j.set_index('i')
        
        # save calculated displacements to original dataframe of linked positions
        for pos in pos_columns:
            t.loc[t['frame'] == current_frame , pos + '_adj'] = j[[pos + '_adj']]
            
        
        # calculate all net displacements
        j['dr_adj_full'] = np.sqrt(np.sum([j[pos + '_adj']**2 for pos in pos_columns], 0))
#        # equivalent formulation
#        j['dr_adj_full'] = np.sqrt(np.sum([j['dxum_adj']**2+j['dyum_adj']**2+j['dzum_adj']**2],0))
        
        # calculate net displacements for only shifting x
        j['dr_adj_x'] = np.sqrt(np.sum([j['dxum_adj']**2+j['dyum']**2+j['dzum']**2],0))
        
        # calculate net displacements for only shifting x and y
        j['dr_adj_xy'] = np.sqrt(np.sum([j['dxum_adj']**2+j['dyum_adj']**2+j['dzum']**2],0))

        
        t.loc[t['frame'] == current_frame , 'dr_adj_full'] = j['dr_adj_full']
        t.loc[t['frame'] == current_frame , 'dr_adj_x'] = j['dr_adj_x']
        t.loc[t['frame'] == current_frame , 'dr_adj_xy'] = j['dr_adj_xy']
        
    # Delete extra index column
    del t['i']
    
    # save file with displacements
    save_filepath = '\\'.join(path.split('.')[:-1]) + r'.csv'
#    save_filepath = linked_features_file[:-4] + '_w_adj_disp.csv'
    t.to_csv(save_filepath, index = False)
    
    return

def adj_positions(path):
    """
    Takes positions and adjusted displacements where mean displacement has been
    subtracted (xy or xyz). Creates new adjusted positions column to remove
    jitter. Useful for calculating msd and such without jitter.
    
    Inputs:
        path to linked_features_file or linked_peri_mod with displacements from 
        trackpy and displacements_pd and adj_displacements.
        
    Outputs:
        saves displacements in a csv
    """
    # Define position columns for calculating displacements
    pos_columns = ['xum', 'yum', 'zum']
    disp_columns = ['dxum', 'dyum', 'dzum']
    adj_disp_columns = ['dxum_adj', 'dyum_adj', 'dzum_adj']
      
    # file path for linked particle positions from trackpy
    linked_features_file = path
    # Example path: r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\
    # ampsweep_pre_train\1.4V\u_combined\linked_w_contacts_w_displacements.csv'
    
    t = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary (left over from old indexing)
    if 'Unnamed: 0' in t.columns:
        del t['Unnamed: 0']
        

#    # Calculate adjusted positions
#    # NOTE: I THINK I NEED TO USE ADJ POSITIONS FROM PREVIOUS FRAME
#    for pos in pos_columns:
#        t[pos + '_adj'] = t[pos] - t['d' + pos] + t['d' + pos + '_adj']
        
    # save a varialbe equal to the original dataframe index for each particle at each time
    # (used to combine dataframes later)
    t['i'] = range(len(t))
            
    # read which frames are present
    first_frame = int(np.min(t.frame.values))
    last_frame = int(np.max(t.frame.values))
    
    # Iterate through frames calculating adjusted positions
    for current_frame in range(first_frame + 1, last_frame + 1):
     
        # Form sub-arrays with only data for current frame and prev frame
        p = t.loc[t.frame == current_frame - 1]
        c = t.loc[t.frame == current_frame]
        
        # combine subarrays and index by particle number
        j = c.set_index('particle')[pos_columns + disp_columns + adj_disp_columns + ['i']].join(
             p.set_index('particle')[pos_columns + disp_columns + adj_disp_columns], rsuffix='_p')        
        
        # Calculate adjusted/effective positions.
        # Need to look at previous timestep since displacements are saved as what
        # will happen to each particle.
        # Get mean displacement (jitter) by subtracting dx from dx_adj. 
        # x - dx_mean = x - (dx - dx_adj) = x - dx + dx_adj
        for pos in pos_columns:
            j[pos + '_adj'] = j[pos] - j['d' + pos + '_p'] + j['d' + pos + '_adj_p']
        
        # reindex combined array by original dataframe index (saved as i)
        j = j.set_index('i')
        
        # save calculated displacements to original dataframe of linked positions
        for pos in pos_columns:
            t.loc[t['frame'] == current_frame , pos + '_adj'] = j[[pos + '_adj']]
        
    # Delete extra index column
    del t['i']
    
    # save file with displacements
    save_filepath = '\\'.join(path.split('.')[:-1]) + r'.csv'
#    save_filepath = linked_features_file[:-4] + '_w_displacements.csv'
    t.to_csv(save_filepath, index = False)
    
    return

def nearest_neighbors(path, c_range):
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
            
            f.at[i, 'neighbors'] = neighbors
            f.at[i, 'contacts'] = contact_count
            
            if (i % 1000) == 0:
                print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame))
        
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
        #column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
        column_name = 'contacts'
        
        # update master dataframe if more than one frame
        if num_frames > 0:
            df.loc[df['frame']== frame, column_name] = f['contacts']
            df.loc[df['frame']== frame, 'neighbors'] = f['neighbors']
            #####################################
#            df.loc[df['frame']== frame, 'next_nbs'] = f['next_nbs']
            
    
    # Delete extra index column
    del df['i'] 
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
    #    save_filepath = df_features_file[:-4] + '_w_contacts.csv'
    df.to_csv(save_filepath, index = False)
    return

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

def contact_number_linked(path, c_range):
    """
    contact_number_linked
    
    Calculates number of particles in 'contact' with each particle in a collection
    of LINKED particles located by trackpy. Modified from my original Matlab code
    for finding contact numbers.
    
    Inputs:
        features created by tp.locate
        contact range in um established by first min in g(r)
    Outputs:
        contact numbers added to dataframe  
        
    Notes:
        Can also run this program for displacements data (linked features with
        displacements already calculated) to add contact numbers there.
    """
    # Max range to be counted as in contact (in microns)
    contact_range = c_range
    
    # filepath to tp trajectories
    linked_features_file = path
    
    linked = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in linked.columns:
        del linked['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    
    # define distances in um instead of pixels (if not already done)
    if not 'xum' in linked.columns:
        linked['xum'] = linked['x'] * 0.127
        linked['yum'] = linked['y'] * 0.127
        linked['zum'] = linked['z'] * 0.12
    
    # number of timesteps (aka frames)
    if max(linked['frame']) == 0:
        num_frames = 1
    else:
        num_frames = int(max(linked['frame']) - min(linked['frame'])) + 1
    
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
        
#            if (i % 1000) == 0:
#                print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
        
            # add the contact number to the dataframe features object
            column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
            linked.loc[linked['frame']== frame, column_name] = contacts
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
    linked.to_csv(save_filepath, index = False)
    
    return

def contact_number_positions(path, c_range):
    """
    contact_number_positions
    
    Calculates number of particles in 'contact' with each particle in a collection
    of LOCATED particles located by trackpy in MULTIPLE FRAMES. 
    Modified from my original Matlab code for finding contact numbers.
    
    Inputs:
        features created by tp.locate
        contact range in um established by first min in g(r)
    Outputs:
        contact numbers added to dataframe  
        
    Notes:
        Can also run this program for displacements data (features features with
        displacements already calculated) to add contact numbers there.
    """
    # Max range to be counted as in contact (in microns)
    contact_range = c_range
    
    # filepath to tp trajectories
    features_features_file = path
    
    features = pd.read_csv(features_features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in features.columns:
        del features['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    
    # define distances in um instead of pixels (if not already done)
    if not 'xum' in features.columns:
        features['xum'] = features['x'] * 0.127
        features['yum'] = features['y'] * 0.127
        features['zum'] = features['z'] * 0.12
    
    # number of timesteps (aka frames)
    if max(features['frame']) == 0:
        num_frames = 1
    else:
        num_frames = (max(features['frame']) - min(features['frame'])) + 1
    
    for frame in range(num_frames):
        
        # create dataframe with just current frame
        f = features.loc[features['frame'] == frame]
        
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
                print(str(i) + '/' + str(len(f)) + ' in frame ' + str(frame) + '\n')
        
            # add the contact number to the dataframe features object
            column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
            features.loc[features['frame']== frame, column_name] = contacts
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\positions_mod.csv'
#    save_filepath = positions_features_file[:-4] + '_w_contacts.csv'
    features.to_csv(save_filepath, index = False)
    
    return

def contact_number_single_frame(path, c_range):
    """
    contact_number_static
    
    Calculates number of particles in 'contact' with each particle in a collection
    of LOCATED particles located by trackpy in a SINGLE FRAME. 
    Modified from my original Matlab code for finding contact numbers.
    
    Inputs:
        features created by tp.locate
        contact range in um
    Outputs:
        contact numbers added to dataframe  
        
    Notes: I think this just does the same thing as contact_number_positions.
    No real difference.
    """
    # Max range to be counted as in contact (in microns)
    contact_range = c_range
    
    # filepath to tp trajectories
    features_file = path
    
    features = pd.read_csv(features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in features.columns:
        del features['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    
    # define distances in um instead of pixels (if not already done)
    if not 'xum' in features.columns:
        features['xum'] = features['x'] * 0.127
        features['yum'] = features['y'] * 0.127
        features['zum'] = features['z'] * 0.12
    
    
    f = features
    
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
            print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(0) + '\n')
    
        # add the contact number to the dataframe features object
        column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
        features[column_name] = contacts
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\positions_mod.csv'
    features.to_csv(save_filepath, index = False)
    
    return

def displacements_basic(path, frame1, frame2):
    """ 
    Note: made mostly irrelevant by displacements_pd which also saves the
    displacemnts for each particle.
    
    Takes the path to a folder with linked positions created by trackpy.
    Calculates the displacements of all particles between the two frames. Saves
    a histogram of displacement distances and basic statistics to file. Returns
    the mean displacement dr_mean.
    """
#==============================================================================
#     # example imputs
#     path = r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run2\zstacks_p0\u_combined'
#     frame1 = 0
#     frame2 = 1
#==============================================================================

    # change frames index to start at 1
    frame1_python = frame1-1
    frame2_python = frame2-1
    
    linked = pd.read_csv(path + '\linked.csv')


    # relate frames gets all displacements between two frames
    j = tp.relate_frames(linked, frame1_python, frame2_python, pos_columns = ['xum', 'yum', 'zum'])
    
    # array of just distances between particle pairs
    drs_full = j.dr.values
    
    # nan appears for every particle in one frame but not the other
    # remove all nan entries so I can do math
    drs = drs_full[np.isfinite(drs_full)]
    
    # calculate mean displacement of particles between the two frames
    dr_mean = np.mean(drs)
#    dr_var = np.var(drs)
#    dr_std= np.sqrt(dr_var)
#    dr_median = np.median(drs)
    
    
    # make histogram of displacemets
    h, bin_edges = np.histogram(drs, bins=np.arange(51)/50., density = False)
    
    # plot the histogram. can comment out for running funciton.
    plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
    plt.xlim(min(bin_edges), max(bin_edges))
    plt.show()   
    
#==============================================================================
#     # could also get and plot histogram using matplotlib hist function
#     #plt.hist(drs)
#     
#     # calculate mode
#     #max_counts = np.max(h)
#     dr_mode_index = np.argmax(h)
#     dr_mode= bin_edges[dr_mode_index]
#     
#     # Save statistics to csv
#     disp_stats = pd.DataFrame({'dr_mean':[dr_mean], 'dr_var':[dr_var],
#                                 'dr_std':[dr_std], 'dr_median':[dr_median],
#                                 'dr_mode':[dr_mode]})
#     
# #    disp_stats.to_csv(path + '\dr_t' + str(frame1) + 't' + str(frame2) +  '_stats.csv', index = False)
#     
#     # Save histogram to csv
#     dr_hist = pd.DataFrame({'disp_hist':h, 'bin_edges':bin_edges[1:]})
#     dr_hist.to_csv(path + '\dr_t' + str(frame1) + 't' + str(frame2) +  '_hist.csv', index = False)
#==============================================================================

    
    return dr_mean

def fabric_tensor_linked(path, c_range):
    """
    fabric_tensor_linked
    
    calculates the fabric tensor for every particle in a collection of LINKED
    particles located by trackpy. Saves the updated dataframe object to file.
    
    Inputs:
        path: file path to linked features file
        c_range: contact range for determining which particles are in contact and
        should be included in the fabric tensor calculation
    
    
    ########### BUG ###################
    currently has abs() around shift vector making all elements of vector
    positive and off-diagonal elements of fabric tensor wrong
    
    Created on Mon Oct 23 10:56:10 2017
    
    @author: Eric
    """
  
    # Max range to be counted as in contact (in microns)
    contact_range = c_range
    
    # filepath to tp trajectories
    linked_features_file = path
    
    linked = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in linked.columns:
        del linked['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    
    # define distances in um instead of pixels (if not already done)
    if not 'xum' in linked.columns:
        linked['xum'] = linked['x'] * 0.127
        linked['yum'] = linked['y'] * 0.127
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
        
        # define a structure to store fabric tensors
        fabs = np.zeros((len(f),9))
    
    #    # define a trace structure for the trace of the fabric tensor
    #    trace = np.zeros(len(f))
    
        for i in range(len(positions)):
            
            # calculate the relative position vector. (Calculate for every other
            # particle in one step with repmat)
            # np.tile takes one row of the center matrix and repeats it for each other
            # row to make it the size of data. Then subtract to have distances.
        
            shift_vector = positions - np.tile(positions[i,:], (len(positions),1))
        
            # Counter variable for the number of particles in contact.
            contact_count = 0
            # fabric tensor
            fabric = np.zeros((3,3))
            
            for j in range(len(shift_vector)):
                distance = np.linalg.norm(shift_vector[j,:])
                if (distance < contact_range and distance != 0):
                    contact_count = contact_count + 1
                    # normalize distance vector to make it a unit vector
                    uv = np.array(shift_vector[j,:])/distance
                    fabric = fabric + np.outer(uv,uv)
            
            # record contact number in array
            contacts[i] = contact_count
            
            # record fabric tensor in arrray (could probably make this more efficient) 
            # USE np.flatten FUNCTION!!!
            element = 0
            for r in fabric:
                for c in r:
                    fabs[i, element] = c
                    element = element + 1
                    
    #         #trace of fabric should equal contact count
    #        trace[i] = fabs[i, 0] + fabs[i, 4] + fabs[i, 8]
    #        print(trace[i] -contacts[i])
                    
            if (i % 1000) == 0:
                print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
        
        # add the contact number to the dataframe features object
        column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
        linked.loc[linked['frame']== frame, column_name] = contacts
            
        # add the fabric tensor to the dataframe
        entries = ['xx','xy','xz','yx','yy','yz','zx','zy','zz']
        for k in range(len(entries)):
            linked.loc[linked['frame'] == frame , 'Z_' + entries[k]] = fabs[:, k]
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
    #    save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
    linked.to_csv(save_filepath, index = False)

    return

def fabric_tensor_positions(path, c_range):
    """
    fabric_tensor_positions
    NO CHANGE from fabric_tensor_linked except for editing save_filepath
    
    calculates the fabric tensor for every particle in a collection of LINKED
    particles located by trackpy. Saves the updated dataframe object to file.
    
    Inputs:
        path: file path to linked features file
        c_range: contact range for determining which particles are in contact and
        should be included in the fabric tensor calculation
    
    
    Created on Mon Oct 23 10:56:10 2017
    
    @author: Eric
    """
  
    # Max range to be counted as in contact (in microns)
    contact_range = c_range
    
    # filepath to tp trajectories
    linked_features_file = path
    
    linked = pd.read_csv(linked_features_file)
    
    # delete unnamed column if necessary
    if 'Unnamed: 0' in linked.columns:
        del linked['Unnamed: 0']
    
    ############################
    # add an extra index column for testing
    
    # define distances in um instead of pixels (if not already done)
    if not 'xum' in linked.columns:
        linked['xum'] = linked['x'] * 0.127
        linked['yum'] = linked['y'] * 0.127
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
        
        # define a structure to store fabric tensors
        fabs = np.zeros((len(f),9))
    
    #    # define a trace structure for the trace of the fabric tensor
    #    trace = np.zeros(len(f))
    
        for i in range(len(positions)):
            
            # calculate the relative position vector. (Calculate for every other
            # particle in one step with repmat)
            # np.tile takes one row of the center matrix and repeats it for each other
            # row to make it the size of data. Then subtract to have distances.
        
            shift_vector = positions - np.tile(positions[i,:], (len(positions),1))
        
            # Counter variable for the number of particles in contact.
            contact_count = 0
            # fabric tensor
            fabric = np.zeros((3,3))
            
            for j in range(len(shift_vector)):
                distance = np.linalg.norm(shift_vector[j,:])
                if (distance < contact_range and distance != 0):
                    contact_count = contact_count + 1
                    # normalize distance vector to make it a unit vector
                    uv = np.array(shift_vector[j,:])/distance
                    fabric = fabric + np.outer(uv,uv)
            
            # record contact number in array
            contacts[i] = contact_count
            
            # record fabric tensor in arrray (could probably make this more efficient)
            element = 0
            for r in fabric:
                for c in r:
                    fabs[i, element] = c
                    element = element + 1
                    
    #         #trace of fabric should equal contact count
    #        trace[i] = fabs[i, 0] + fabs[i, 4] + fabs[i, 8]
    #        print(trace[i] -contacts[i])
                    
            if (i % 1000) == 0:
                print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
        
        # add the contact number to the dataframe features object
        column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
        linked.loc[linked['frame']== frame, column_name] = contacts
            
        # add the fabric tensor to the dataframe
        entries = ['xx','xy','xz','yx','yy','yz','zx','zy','zz']
        for k in range(len(entries)):
            linked.loc[linked['frame'] == frame , 'Z_' + entries[k]] = fabs[:, k]
    
    # save file with contacts
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\positions_mod.csv'
    #    save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
    linked.to_csv(save_filepath, index = False)

    return