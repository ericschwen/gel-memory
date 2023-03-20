# -*- coding: utf-8 -*-
"""
adjacency_matrix

Creates an adjacency matrix for one frame of a linked set of particles. Expects
a data frame with neighbors already located using tp_custom_v12 nearest_neighbors
function.


Created on Mon Feb 12 01:36:41 2018

@author: Eric
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(5, 3))

#linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p50\linked_mod_ylim.csv'
linked_features_file = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod.csv'
t = pd.read_csv(linked_features_file)

# restrict to single frame
df = t.loc[t.frame == 1]

n_particles = int(np.max(df.particle.values)+1)
adj_mat = np.zeros((n_particles, n_particles), dtype = int)

# loop through all particles
for particle in df.particle.values:
    # creat array of neighbors
    particle = int(particle)
    nn = df.loc[df.particle == particle].neighbors.values[0]
    nn = np.fromstring(nn[1:-1], dtype = int, sep = ',')
    for neighbor in nn:
        # add pair to adjacency matrix if not already there
        if adj_mat[particle, neighbor] == 0:
            adj_mat[particle, neighbor] = 1
            adj_mat[neighbor, particle] = 1
            
save_path = linked_features_file[:-4] + '_adj_matrix.csv';
np.savetxt(save_path, adj_mat, delimiter=',')