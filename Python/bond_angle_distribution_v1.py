# -*- coding: utf-8 -*-
"""
bond_angle_distribution_v1

Takes path to linked (or just located) file from trackpy (or peri) where
neighbors have aready been found through tp_custom_functions_v12 nearest_neighbors
function.

Calculates the azimuthal and polar angles for each nearest neighbor pair and adds
them to an array.

Mod History: 
    v1 4-12-18

Created on Thu Apr 12 14:28:09 2018

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
path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod_test.csv'
#c_range = 2.1;


# filepath to tp trajectories
features_file = path

df = pd.read_csv(features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in df.columns:
    del df['Unnamed: 0']
    
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


## Optional section to preallocate azis and polars arrays
## Count total number of bonds (doubled because of repeats)
#count = 0
#for k in range(len(df)):
#    # get list of nearest neighbors
#    nn = ast.literal_eval(df.at[k, 'neighbors'])
#    count = count + len(nn)


# Declare array for azi and polar angles
azis = np.array([])
polars = np.array([])

for frame in range(int(num_frames)):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
        
    # create a temporary index for this frame
    f.loc[:, 'temp_index'] = np.arange(len(f))
    f = f.set_index('temp_index')
    
    # find total number of 
    
    # iterate through all particles (and calculate bond angles)
    for j in range(len(f)):
        # get list of nearest neighbors
        
        
#        # nearest neighbors verstion
#        nn = ast.literal_eval(f.at[j, 'neighbors'])
        
        # L'th layer of neighbors
        nn = ast.literal_eval(f.at[j, 'nn2'])
#        nn = f.at[j, 'nn2']
        
        
        # get position
        # there is a prettier way to do this, but this works for now
        pos1 = np.array([f.at[j, 'xum'], f.at[j,'yum'], f.at[j,'zum']])
        
        for entry in nn:
            # get the position vector for the neighboring particle
            # there is a prettier way to do this, but this works for now
            pos2 = np.array([f.loc[f['particle'] == entry]['xum'].values[0],
                             f.loc[f['particle'] == entry]['yum'].values[0],
                             f.loc[f['particle'] == entry]['zum'].values[0]])
            # calculate vector between the 2 neighboring particles
            shift_vector = pos2-pos1
            shift_distance = np.linalg.norm(shift_vector)
            # calculate the azimuthal and polar angles (in degrees)
            azi = np.arctan(shift_vector[1]/shift_vector[0])*180/np.pi
            polar = np.arccos(shift_vector[2]/shift_distance)*180/np.pi
            
            # append values to array of all angles
            azis = np.append(azis, azi)
            polars = np.append(polars, polar)


# histogram of bond angles
h_a, bin_edges_a = np.histogram(azis, bins=30, density = False)
pdf_h_a = np.array(h_a)/float(sum(h_a))

h_p, bin_edges_p = np.histogram(polars, bins=30, density = False)
pdf_h_p = np.array(h_p)/float(sum(h_p))

# plot the histogram of probablilies
plt.plot(bin_edges_a[1:], h_a, 'b:o', label = 'Azimuthal')
plt.plot(bin_edges_p[1:], h_p, 'r:o', label = 'Polar')
#plt.xlim(0, 10)
#plt.ylim(0, .3)
plt.xlabel('Bond Angle', fontsize = 12)
plt.ylabel('Count', fontsize = 12)
#plt.ylabel('$P(\phi)$', fontsize = 12)
#plt.title('Bond Angle', fontsize = 12)
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()   
