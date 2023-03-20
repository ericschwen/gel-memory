# -*- coding: utf-8 -*-
"""
Import and save trackpy g(r) calculation
Created on Thu Oct 05 19:54:57 2017

@author: Eric
"""

import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


#folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200'
#
#features_path = folder + r'\positions_15-15-11.csv'

#folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.2\u_combined_o5'
#features_path = folder + r'\positions.csv'

features_path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p0\u_combined_o5\linked_mod.csv'
#features_path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\u_combined_o5\linked_mod.csv'
#features_path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p500\u_combined_o5\linked_mod.csv'

features_full = pd.read_csv(features_path)

# select individual frame
# features = features_full
features = features_full.loc[features_full['frame'] == 0]

# plot g(r)
[edges, g_r] = tp.pair_correlation_3d(features, 50)
fig, ax = plt.subplots()
ax.plot(edges[1:]*0.127, g_r, 'b:o');
ax.set(ylabel='G(r)', xlabel='um');
       


## Save resulting image       
#spath = folder + '\\' + 'gr.png'
#fig.savefig(spath, bbox_inches='tight',frameon = False, dpi = 800)
#
#data = {'edges (um)': edges[1:] * 0.127, 'gr': g_r, 'edges (px)': edges[1:]}
#df = pd.DataFrame(data)
#df.to_csv(folder + '\gr.csv', index = False)