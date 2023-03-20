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
"""
import pims
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
    f.to_csv(path[:-5] + 'positions15.csv', index = False)
    # define distances in um instead of pixels
    f['xum'] = f['x'] * 0.127
    f['yum'] = f['y'] * 0.127
    f['zum'] = f['z'] * 0.12
    
    # link particles
    linked = tp.link_df(f, 1.5, pos_columns=['xum', 'yum', 'zum'])
    
    #Save the data to csv file
    linked.to_csv(path[:-5] + 'linked15.csv', index = False);

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
    features_file = path[:-5] + 'positions15.csv'
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
    linked = tp.link_df(f, 1.5, pos_columns=['xum', 'yum', 'zum'])
    
    #Save the data to csv file
    linked.to_csv(path[:-5] + 'linked15.csv', index = False);
    
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
        
    Outputs:
        saves displacements in a csv
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
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked15_mod.csv'
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
    
    
    # read number of timesteps (aka frames)
    if max(t['frame']) == 0:
        num_frames = 1
    else:
        num_frames = (max(t['frame']) - min(t['frame'])) + 1
    
    
    # Iterate through frames calculating average displacements
    for current_frame in range(num_frames-1):
        
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

        
        t.loc[t['frame'] == current_frame , 'dr_adj_full'] = j['dr_adj_full']
        t.loc[t['frame'] == current_frame , 'dr_adj_x'] = j['dr_adj_x']
        
    # Delete extra index column
    del t['i']
    
    # save file with displacements
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked15_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_adj_disp.csv'
    t.to_csv(save_filepath, index = False)
    
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
    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked15_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
    linked.to_csv(save_filepath, index = False)
    
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
    dr_var = np.var(drs)
    dr_std= np.sqrt(dr_var)
    dr_median = np.median(drs)
    
    
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