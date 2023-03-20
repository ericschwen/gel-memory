# -*- coding: utf-8 -*-
"""
Script for analyzing "change of radius" of particles featured by peri
between two frames. Takes inputs from file for positions and linked 
trajectories created by trackpy.

Created on Wed Jul 12 00:49:09 2017

@author: Eric
"""

import numpy as np
import pandas as pd
#import trackpy as tp

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


folder = r'C:\Eric\Xerox\Python\peri\pauses translate'
#folder = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses'
#folder = r'C:\Eric\Xerox\Python\peri\128x128x50_static'


path = folder + r'\linked_peri.csv'

#def radius_evolution(path):
"""

Inputs:
    path to linked_features_file from trackpy
    
Outputs: none
    (saves displacements in a csv)
"""

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

# read number of timesteps (aka frames)
if max(t['frame']) == 0:
    num_frames = 1
else:
    num_frames = int((max(t['frame']) - min(t['frame'])) + 1)

# Iterate through frames calculating displacements
for current_frame in range(num_frames):
    
    # Form sub-arrays with only data for current frame and next frame
    a = t.loc[t.frame == current_frame]
    b = t.loc[t.frame == current_frame + 1]
    
    # combine subarrays and index by particle number
    j = a.set_index('particle')[['rad'] + ['i']].join(
         b.set_index('particle')[['rad']], rsuffix='_b')
    
    # calculate radius change
    j['drad'] = j['rad_b'] - j['rad']
    
    ## convert radius change to um. NOT SURE HOW Z vs XY SPACING WORKS!
    #j['drad_um'] = j['drad'] * 0.127
    
    # reindex combined array by original dataframe index (saved as i)
    j = j.set_index('i')
    
    t.loc[t['frame'] == current_frame , 'drad'] = j['drad']
    
# Delete extra index column
del t['i']

# save file with displacements
save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_displacements.csv'
t.to_csv(save_filepath, index = False)

#return

#################################################################
#
##### JUST THE ANALYSIS PART #########
## most ported over to peri_radius_analysis_v1
#
#path = folder + r'\linked_mod.csv'
#linked_mod_file = path
#m = pd.read_csv(linked_mod_file)
#
#
## Restrict to only particles within frame (not near or over edges)
#inside = m.loc[(m.z>4) & (m.z<45) & (m.y>4) & (m.y<124) & (m.x>4) & (m.x<124)]
#
#
## Checking statistics for radius "changes"
#
#temp = m.loc[abs(m.drad) > 0]
#drads = np.sort(abs(temp.drad.values))
#
## mean and meadian absolute changes in radius (in pixels)
#mean_drad = np.mean(drads)
#median_drad = np.median(drads)
#
#mean_drad_um = mean_drad * .125
#median_drad_um = median_drad * .125
#
#per_90 = drads[int(len(drads)*.90)]
#
#
#
###################################################################
## look at standard deviation in particle radii changes
#last_particle = 200
##last_particle = int(np.max(t.particle.values))
#
#stds = np.ones(last_particle)
#for i in range(last_particle):
#    # restrict df to single particle
#    temp = t.loc[(m.particle == i) & (abs(m.drad) > 0)]
#    
##    # test for only looking at reasonable particle sizes
##    temp = m.loc[(m.particle == i) & (abs(m.drad) > 0) & (m.rad>7) & (m.rad<9)]
#    
#    
#    # take sample standard deviation
#    stds[i] = np.std(temp.drad.values, ddof=1)
#
## remove nan entries
#stds = stds[~np.isnan(stds)]
##
#mean_std = np.mean(stds)

##############################################################################
### restrict to tiled region in x, y and z
##t = t.loc[(t.z > 0) & (t.z < 50) &
##                    (t.y > 0) & (t.y < 128) &
##                    (t.x > 0) & (t.x < 128)]
#
## restrict to single frame if wanted
##f = t.loc[t.frame == 0]
#f = t.loc[t.frame <4]
##f = t
#
## straight displacements part
#drs_full = f.dr_adj_full.values
#    
## remove all nan entries so I can do math
#drs = drs_full[np.isfinite(drs_full)]
#
## calculate mean displacement of particles between the two frames
#dr_mean = np.mean(drs)
#dr_var = np.var(drs)
#dr_std= np.sqrt(dr_var)
#dr_median = np.median(drs)
#
#print('mean displacement: ' + str(dr_mean))
#print('particle displacement count: ' + str(len(drs)))
#
## make histogram of displacemets
#h, bin_edges = np.histogram(drs, bins=np.arange(21)/20., density = False)
#
#
## plot the histogram of probabilities
#plt.bar(bin_edges[0:-1], h/float(sum(h)), width = bin_edges[1]-bin_edges[0])
##plt.xlim(min(bin_edges), 0.2)
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
#plt.ylabel('Probability', fontsize = 18)
#plt.title('Displacement distribution', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show() 
#
#
#########################################################################
### graph mobile and immobile histograms
#drs_mobile = drs[drs>0.03]
#drs_immobile = drs[drs < 0.03]
#
#h_m, bin_edges = np.histogram(drs_mobile, bins=np.arange(51)/100., density = False)
#h_im, bin_edges = np.histogram(drs_immobile, bins=np.arange(51)/100., density = False)
#
## plot the histogram
#plt.bar(bin_edges[0:-1], h_m/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'r')
#plt.bar(bin_edges[0:-1], h_im/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'b')
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
#plt.ylabel('Probability', fontsize = 18)
#plt.title('Displacement distribution', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show() 
