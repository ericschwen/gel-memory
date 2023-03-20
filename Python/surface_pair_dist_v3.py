# -*- coding: utf-8 -*-
"""
surface_pair_dist_v1

Calculate a "pair distribution function" g(xi) using the surface-to-surface
separation between particles rather than center-to-center separation. Needs
particle positions and radii located by PERI (also works for sets linked by
 trackpy).

Mod History:
    v2: add minimum and maximum radius cutoffs to ignore junk particles
    v3: change normalization to do during loop instead of at end. Uses radii of
    the two particles rather than the mean. 10-15-18
    v4:

Created on Thu Oct 11 18:41:27 2018

@author: Eric
"""

import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


# define calculation range (in um)
calc_range = 3

# define spacing of bins for histogram (in um)
dr = 0.05

# Create variables to store g(xi) and x-space used for bins
x_space = np.arange(-1.0, calc_range+dr, dr)
gxi = np.zeros([len(x_space)-1, 2])
gxi[:,0] = x_space[:-1]
temp_gxi = np.zeros(len(x_space)-1)

# set cutoffs for min and max radii to be accepted
rad_min = 0.7
rad_max = 1.2

# filepath to tp trajectories
#path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\test\linked_mod.csv'
path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p100\linked_mod.csv'
features_file = path
# sample path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\test\linked_mod.csv'

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
# CHECK CONVERSION !!!!!!!!!!!!!!!!!!
if not 'rad_um' in df.columns:
    df['rad_um'] = df['rad'] * 0.125
    

# Loop through frames to calculate separation distributions
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
    radii = np.array(f['rad_um'])
    
    pos_rad = np.transpose(np.array([f['xum'],f['yum'], f['zum'], f['rad_um']]))
       
    # Loop through all particles in frame to find surface separation distribution
    for i in range(len(pos_rad)):
        
        # calculate the relative position vector. (Calculate for every other
        # particle in one step with repmat)
        # np.tile takes one row of the center matrix and repeats it for each other
        # row to make it the size of data. Then subtract to have distances.
    
        # vector from center of particle i to every other particle
        shift_vector = abs(positions[:] - np.tile(positions[i,:], (len(positions),1)))
        
        c2c_distance = np.zeros(len(shift_vector))
        surface_separation = np.zeros(len(shift_vector))
        normalized_gxi_contribution = np.zeros(len(shift_vector))
        
        for j in range(len(shift_vector)):
            c2c_distance[j] = np.linalg.norm(shift_vector[j,:])
            # neglect same particle
            if not c2c_distance[j]==0:
                surface_separation[j] =c2c_distance[j] - radii[j] - radii[i]
            # normalized weights for each contribution
            normalized_gxi_contribution[j] = 1/(surface_separation[j]+radii[j]+radii[i])
            # Note: this method also allows for calculation of number of neighbors
            # number_of_contacts = sum(surface_separation < contact_range) - 1
            
            # Neglect particles with radii outside range (set to ridiculous number)
            if radii[i] < rad_min or radii[i] > rad_max or radii[j] < rad_min or radii[j] > rad_max:
                surface_separation[j] = 1000
            
        # get rid of particle getting "separation" to itself (set to ridiculous number)
        surface_separation[i] = 1000

        # Calculate histogram for surface separations for particle i
        temp_gxi, bins_x_space = np.histogram(surface_separation, bins=x_space, weights=normalized_gxi_contribution)
        
        # Add single particle total to gxi
        gxi[:,1] = gxi[:,1] + temp_gxi
        
#    # reindex combined array by original dataframe index (saved as i)
#    f = f.set_index('i', drop = False)

# Delete extra index column
del df['i'] 


# normalization of gxi (for number of particles)
# NOTE: could just count particles rather than using len(positions)*num_frames
norm_gxi = np.array(gxi)
norm_gxi[:,1] = norm_gxi[:,1] / (num_frames*len(positions))

# plot gxi
fig1, ax1 = plt.subplots()
ax1.plot(gxi[:,0], gxi[:,1], 'b:o')

# plot normalized gxi
fig2, ax2 = plt.subplots()
ax2.plot(norm_gxi[:,0], norm_gxi[:,1], 'b:o')
#ax2.set_ylim([0,0.0002])
ax2.set_xlim([-0.5, 1.0])


# radii analysis
rh, rb = np.histogram(np.array(df['rad_um']), bins=30)
fig3, ax3 = plt.subplots()
ax3.plot(rb[:-1], rh, 'b:o')