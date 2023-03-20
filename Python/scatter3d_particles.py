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

f_pos = f_full[['xum', 'yum', 'zum']]

xmin = 20
xmax = 40
ymin = 20
ymax = 40

f = f_pos.loc[(f_pos['xum'] > xmin) & (f_pos['xum'] < xmax) & (f_pos['yum'] > ymin) & (f_pos['yum'] < ymax)]



fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(f.xum.values, f.yum.values, f.zum.values, color = 'r', marker='o', s = 300)

ax.set_xlabel('x (um)')
ax.set_ylabel('y (um)')
ax.set_zlabel('z (um)')
ax.set_xlim3d(xmin, xmax)
ax.set_ylim3d(ymin, ymax)
#ax.set_zlim3d(0,5)
plt.show()