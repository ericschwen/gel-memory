import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

"""
Created on Fri Sep 15 11:12:15 2017

scatter 3d

@author: Eric
"""


# variables if not running as function
path = r'C:\Eric\Xerox Data\test displacements\linked_w_displacements.csv'
c_range = 2.3
t_frame = 0

# filepath to tp trajectories
linked_features_file = path

# sepcific frame to look at
frame = t_frame

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']


# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.125
    linked['yum'] = linked['y'] * 0.125
    linked['zum'] = linked['z'] * 0.12

    
# create dataframe with just current frame
f_full = linked.loc[linked['frame'] == frame]

f = f_full[['xum', 'yum', 'zum']]

# declare np array for positions
positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(xs, ys, zs, c=c, marker=m)

ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')

plt.show