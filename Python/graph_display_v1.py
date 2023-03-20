# -*- coding: utf-8 -*-
"""
graph_display

Display a graph created from adjacency_matrix_v1 and located particles.
NOT WORKING! Instead use particle_graph_v1.m MATLAB file


Created on Mon Feb 12 02:44:45 2018

@author: Eric
"""

import numpy as np
import pandas as pd
import networkx as nx
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(5, 3))

linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p50\linked_mod.csv'
#linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv'
t = pd.read_csv(linked_features_file)

# restrict to single frame
df = t.loc[t.frame == 1]

adj_mat_path = linked_features_file[:-4] + '_adj_matrix.csv'

adj_mat = np.loadtxt(adj_mat_path, delimiter = ',')

G = nx.from_numpy_matrix(adj_mat)

particles = df.particle.values
xpos = df.xum.values
ypos = df.yum.values
zpos = df.zum.values

pos = np.array([xpos, ypos, zpos])

pos_dict = {int(key):pos[:,int(key)]  for key in particles}

nx.draw(G, pos)
