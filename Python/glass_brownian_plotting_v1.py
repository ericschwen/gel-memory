# -*- coding: utf-8 -*-
"""
glass_brownian_plotting_v1

Script for plotting motion over time of particles in a glassy state. Uses
 particle positions located using PERI and tracked using trackpy. Input
file is linked_peri_mod.csv created by peri_buld_df_v3.py.

Created on Wed Feb 19 10:50:24 2020

@author: Eric
"""

import pandas as pd
import numpy as np
import os
import matplotlib as mpl
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
mpl.rc('figure',  figsize=(10, 6))


folder = r'C:\Users\Eric\Desktop\From cluster\gardner_glass 2-14-20\11-5-19 bidisperse 1p5-2\peri-ts2-500ms'
linked_filename = r'\linked_peri_mod.csv'
linked_filepath = folder + linked_filename

# import data as dataframe
t = pd.read_csv(linked_filepath)

## Look at non-nan displacements
#tdx = t.dxum.values[~np.isnan(t.dxum.values)]
#tdy = t.dyum.values[~np.isnan(t.dyum.values)]
#tdz = t.dzum.values[~np.isnan(t.dzum.values)]


# May eventually want to restrict to particles that are effectively tracked
# for the whole time.

## Select a single particle to plot for testing. Probably limit to range
## in x,y,z later to plot nearby particles.
#particle = 3
#a = t.loc[(t.particle == particle)]

# Rough first pass at limiting to specific section in x,y,z
xmin = 3
xmax = 5
ymin = 3
ymax = 5
zmin = 3
zmax = 5


# Plot particle position over frames (time). Probably do this in 3D eventually,
# but try it in 2D first.

## Syntax for selecting x and y values
#xs = a.xum.values
#ys = a.yum.values

## Select specific particle range and plot
#for p in range(0,100):
#    plt.plot(t.loc[t.particle==p].xum.values, t.loc[t.particle==p].yum.values, 'b-')
#plt.show()

# 2D Plot
# Select only particles where the entire path is within the bounds
# NOTE: Should double check to make sure the lists of positions here are correct
# with time passing and not just random.
fig = plt.figure()
ax = plt.axes()
# loop through all particles
for p in t.particle.values:
    # check to make sure all positions for each particle are within bounds
    if (np.min(t.loc[t.particle==p].xum.values < xmax) &
        np.min(t.loc[t.particle==p].xum.values > xmin) &
        np.min(t.loc[t.particle==p].yum.values < ymax) &
        np.min(t.loc[t.particle==p].yum.values > ymin)):
        
        ax.plot(t.loc[t.particle==p].xum.values, t.loc[t.particle==p].yum.values, 'b-')
ax.axis('equal')        
plt.show()        

# 3D plot
# Select only particles where the entire path is within the bounds
# NOTE: Should double check to make sure the lists of positions here are correct
# with time passing and not just random.
# loop through all particles
fig = plt.figure()
ax = fig.gca(projection='3d')

for p in t.particle.values:
    # check to make sure all positions for each particle are within bounds
    if (np.min(t.loc[t.particle==p].xum.values < xmax) &
        np.min(t.loc[t.particle==p].xum.values > xmin) &
        np.min(t.loc[t.particle==p].yum.values < ymax) &
        np.min(t.loc[t.particle==p].yum.values > ymin) &
        np.min(t.loc[t.particle==p].zum.values < zmax) &
        np.min(t.loc[t.particle==p].zum.values > zmin)):
        
        ax.plot(t.loc[t.particle==p].xum.values, t.loc[t.particle==p].yum.values,
                t.loc[t.particle==p].zum.values, 'b-')
ax.axis('equal')
plt.show()

## Want a plot in xy but lines linking for time
#plt.plot(xs, ys, 'b-o')
#plt.xlabel('x ($\mu$m)')
#plt.ylabel('y ($\mu$m)')
##plt.title('Displacements over sweep')
##plt.xlim(0,2)
##plt.ylim(0.05, 0.2)
#plt.show()


