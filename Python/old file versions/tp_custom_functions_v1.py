# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 01:25:39 2017

@author: Eric

Define custom trackpy functions for locating and tracking particles
"""
import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


def locate_custom(path):
    """
    Locates particles using trackpy's locate function with custom parameters.
    Takes the path to a folder of prefiltered tiffs (zslices in a zstack) and runs
    tp.locate with custom particle sizes.
    """
         
    # Sample path    
    #path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\zstack_p100_1_bpass3D\*.tif';"
    
    # Define image sequence
    frames = pims.ImageSequenceND(path, axes_identifiers = ['z'])
    
    # run locate function
    features = tp.locate(frames[0], diameter=(15, 15, 15), invert = False, separation = (7,7,7), preprocess = False, minmass = 60000) 
    
    #Save the data to csv file
    features.to_csv(path[:-5] + 'features.csv', index = False)
    return

def tracking_3d_stacks(path):
    """ Track particles through a set of zstacks. Runs trackpy's particle locating
    and linking functions with custom variables. This function just makes it easier to 
    run easily with my own parameters.
    Input: path to a file with prefiltered tiff images named with time and z indices.
    
    Saves csv files for positions, linked positions, and msd.
    """
    
    # Sample path
    # path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\3.0V\u_combined\*.tif';
    
    frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
    # frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
    frames.iter_axes = 't'
    
    # run locate function
    f = tp.batch(frames, diameter=(15, 15, 15), invert = False, separation = (7,7,7), preprocess = False, minmass = 60000)
    
    #Save the data to csv file
    f.to_csv(path[:-5] + 'positions.csv', index = False)
    # define distances in um instead of pixels
    f['xum'] = f['x'] * 0.125
    f['yum'] = f['y'] * 0.125
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

def displacements_3d(path, frame1, frame2):
    """ Takes the path to a folder with linked positions created by trackpy.
    Calculates the displacements of all particles between the two frames. Saves
    a histogram of displacement distances and basic statistics to file. Returns
    the mean displacement dr_mean
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
    
#==============================================================================
#     # plot the histogram. can comment out for running funciton.
#     plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
#     plt.xlim(min(bin_edges), max(bin_edges))
#     plt.show()   
#==============================================================================
    
    # could also get and plot histogram using matplotlib hist function
    #plt.hist(drs)
    
    # calculate mode
    #max_counts = np.max(h)
    dr_mode_index = np.argmax(h)
    dr_mode= bin_edges[dr_mode_index]
    
    # Save statistics to csv
    disp_stats = pd.DataFrame({'dr_mean':[dr_mean], 'dr_var':[dr_var],
                                'dr_std':[dr_std], 'dr_median':[dr_median],
                                'dr_mode':[dr_mode]})
    
    disp_stats.to_csv(path + '\dr_t' + str(frame1) + 't' + str(frame2) +  '_stats.csv', index = False)
    
    # Save histogram to csv
    dr_hist = pd.DataFrame({'disp_hist':h, 'bin_edges':bin_edges[1:]})
    dr_hist.to_csv(path + '\dr_t' + str(frame1) + 't' + str(frame2) +  '_hist.csv', index = False)

    
    return dr_mean

