# -*- coding: utf-8 -*-
"""
limited_df

Creates a limited dataframe from a full one.

Created on Mon Feb 12 03:27:57 2018

@author: Eric
"""

# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 16:01:05 2017

@author: Eric
"""

#import pims
#import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# variables if not running as function
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\linked_w_displacements.csv'
#path = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv'
#path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\0.6\u_combined_o5\linked_mod.csv'
path = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p50\linked_mod.csv'
c_range = 2.1
t_frame = 1

# filepath to tp trajectories
linked_features_file = path

# sepcific frame to look at
frame = t_frame

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']

# create dataframe with just current frame
df = linked.loc[linked['frame'] == frame]

# restrict y range
ymin = 50
ymax = 82
df_ylim = df.loc[(df['y'] > ymin) & (df['y'] < ymax)]

save_path = linked_features_file[:-4] + '_ylim.csv';
df_ylim.to_csv(save_path, index = False)

# follow with tpc.nearest_neighbors (though will have to change save path) adjacency_matrix_v1 and particle_graph_v1.m