# -*- coding: utf-8 -*-
"""
displacement_correlation

Take positions input from a linked positions dataframe (either trackpy or PERI
results). Calculate displacement correlation function. Current version uses
scalar displacements rather than vectors and dot products.

Mod History
v2: edit to save actual values of displacements rather than just making histograms

Still to do: add normalization of some kind.

Created on Tue Jan 30 08:24:55 2018

@author: Eric
"""

import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


# Calculation range (um)
rc = 4

# Boundary for calculation (boundary = xmin, xmax, ymin, ymax, zmin, zmax)
boundary = None

# path to linked features file
path = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses\linked_mod.csv'

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
    
# restrict to single frame if wanted
#df = t.loc[t.frame == 0]
#df = t.loc[t.frame <4]
df = linked

# number of timesteps (aka frames)
if max(df['frame']) == 0:
    num_frames = 1
else:
    num_frames = int((max(df['frame']) - min(df['frame'])) + 1)
    
# restrict to nonzero displacements
df = df.loc[(df.dr_adj_full > 0)]

# restrict to tiled region in x, y and z
#### NOTE: May want to rewrite this to select target particle range but keep 
# others for calculation of neighbors
if boundary is None:
    xmin, xmax, ymin, ymax, zmin, zmax = (df.x.min(), df.x.max(),
                                          df.y.min(), df.y.max(),
                                          df.z.min(), df.z.max())
else:
    xmin, xmax, ymin, ymax, zmin, zmax = boundary

    # Disregard all particles outside the bounding box
    df = df[(df.x >= xmin) & (df.x <= xmax) &
                (df.y >= ymin) & (df.y <= ymax) &
                (df.z >= zmin) & (df.z <= zmax)]
    
    
# Declare edges for 2d histogram
max_distance = np.sqrt(3*rc**2)
distance_step = 0.5
distance_edges = np.arange(0, max_distance + distance_step, distance_step)
displacement_edges = np.arange(0,0.5,0.02)

## Declare histogram
#corr_hist = np.zeros((len(distance_edges)-1, len(displacement_edges)-1))

corr = np.zeros((len(distance_edges), 2))
corr[:, 0] = distance_edges

g_r = np.zeros((len(distance_edges), 2))
g_r[:, 0] = distance_edges

for frame in range(num_frames):
    
    # create dataframe with just current frame
    f = df.loc[df['frame'] == frame]
    
    # declare np array for positions and displacements
    pnd = np.transpose(np.array([f['xum'],f['yum'], f['zum'],f['dr_adj_full']]))
    
    for i in range(len(pnd)):
            
            # calculate the relative position vector. (Calculate for every other
            # particle in one step with repmat)
            # np.tile takes one row of the center matrix and repeats it for each other
            # row to make it the size of data. Then subtract to have distances.
        
            shift_vector = pnd - np.tile(pnd[i,:], (len(pnd),1))
            # fix displacements part of shift_vector
            shift_vector[:,3] = pnd[:,3]
            
            
            # select particles in calculation range (box range)
            svr = shift_vector[(shift_vector[:,0] < rc) & (shift_vector[:,0] > -rc) &
                               (shift_vector[:,1] < rc) & (shift_vector[:,1] > -rc) &
                               (shift_vector[:,2] < rc) & (shift_vector[:,2] > -rc)]
            
            # remove zero vector for same particle
            svr = svr[svr[:, 1] != 0.0]
            
            # create array of distances and displacements for 1d histogram
            dnd = np.ones((len(svr),2))
            dnd[:,1] = svr[:,3]
            for j in range(len(svr)):
                dnd[j,0] = np.linalg.norm(svr[j, 0:3])
            
            
            #test = pd.cut(dnd[])
            
            # sort displacements into bins defined by distance_edges
            dr_bins = np.digitize(dnd[:,0], distance_edges)
            
            for j in range(len(dnd)):
                temp_corr = pnd[i,3] * dnd[j, 1]
                corr[dr_bins[j], 1] = corr[dr_bins[j], 1] + temp_corr
                
                g_r[dr_bins[j], 1] = g_r[dr_bins[j], 1] + 1
                
            
# normalize Correlation
norm_corr = corr
norm_corr[:,1] = corr[:,1] / g_r[:,1]


# plotting
plt.plot(distance_edges, corr[:,1], 'b:o')
plt.ylabel('C(r)')
plt.xlabel('Distance r ($\mu$m)')
plt.title('Displacement Correlation')
plt.show()


# plotting
plt.plot(distance_edges, g_r[:,1], 'b:o')
plt.ylabel('g(r)')
plt.xlabel('Distance r ($\mu$m)')
plt.title('Pair distribution function')
plt.show()

plt.plot(distance_edges, norm_corr[:,1], 'b:o')
plt.ylabel('C(r)')
plt.xlabel('Distance r ($\mu$m)')
plt.title('Displacement Correlation Normalized')
plt.show()


###############################################################################            
#            # histogram of displacement and distances from center particle
#            temp_corr_hist, xedges, yedges = np.histogram2d(dnd[:,0], dnd[:,1], bins = (distance_edges, displacement_edges))
#            corr_hist = corr_hist + temp_corr_hist
#            
            ## could also get g(r) from this: equivalent methods
            #temp_gr = np.sum(temp_corr_hist, axis = 1)
            #temp_gr, gr_edges = np.histogram(dnd[:,0], bins = distance_edges)
            
            
            
#            # select particles in calculation range (could also do box instead
#            # of sphere for calculation range
#            for j in range(len(shift_vector)):
#                distance = np.linalg.norm(shift_vector[j,0:3])
#                if (distance < rc and distance != 0):
#                    temp_corr = pnd[i,3] * pnd[j,3]
#                    corr = corr + temp_corr
            
            

