# -*- coding: utf-8 -*-
"""
peri_radius_analysis_v1

Created on Thu Jan 18 15:36:32 2018

@author: Eric
"""

import pandas as pd
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))



folder = r'C:\Eric\Xerox\Python\peri\pauses translate'

#### JUST THE ANALYSIS PART #########

path = folder + r'\linked_mod.csv'
linked_mod_file = path
t = pd.read_csv(linked_mod_file)

# set size of image
zmin = 0
zmax = 50
ymin = 0
ymax = 128
xmin = 0
xmax = 128


# Restrict to only particles within frame (not near or over edges)
inp = t.loc[(t.z>(zmin+4)) & (t.z<(zmax-4)) & (t.y>(ymin+4)) & (t.y<(ymax-4)) & (t.x>(xmin+4)) & (t.x<(xmax-4))]

# Checking statistics for radius "changes"

temp = inp.loc[abs(inp.drad) > 0]
drads = np.sort(abs(temp.drad.values))

# mean and meadian absolute changes in radius (in pixels)
mean_drad = np.mean(drads)
median_drad = np.median(drads)

mean_drad_um = mean_drad * .125
median_drad_um = median_drad * .125

per_90 = drads[int(len(drads)*.90)]



##################################################################
# look at standard deviation in particle radii changes
last_particle = 200
#last_particle = int(np.max(t.particle.values))

stds = np.ones(last_particle)
for i in range(last_particle):
    # restrict df to single particle
    temp = inp.loc[(inp.particle == i) & (abs(inp.drad) > 0)]
    
#    # test for only looking at reasonable particle sizes
#    temp = inp.loc[(inp.particle == i) & (abs(inp.drad) > 0) & (inp.rad>7) & (inp.rad<9)]
    
    
    # take sample standard deviation
    stds[i] = np.std(temp.drad.values, ddof=1)

# remove nan entries
stds = stds[~np.isnan(stds)]
#
mean_std = np.mean(stds)