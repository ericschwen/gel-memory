# -*- coding: utf-8 -*-
"""
Created on Fri Sep 29 17:42:17 2017

@author: Eric
"""

import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# check length of search range necessary for good tracking.

#
#############################
## Option a: calculate positions for all frames using batch script
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.8\u_combined_o5\*.tif'
#
#frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
## frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
#frames.iter_axes = 't'
#
## run locate function
#f = tp.batch(frames, diameter=(15,15,15), invert = False, separation = (11,11,11),
#             preprocess = False, minmass = 40000)
#
##Save the data to csv file
#f.to_csv(path[:-5] + 'positions15.csv', index = False)


#####################################
# option b: import positions for all frames
folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\4.8\u_combined_o5'
fname = r'\positions15.csv'
f = pd.read_csv(folder + fname)



###########################################
# linking with different link lengths 

# define distances in um instead of pixels
f['xum'] = f['x'] * 0.127
f['yum'] = f['y'] * 0.127
f['zum'] = f['z'] * 0.12

# link particles
linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])

#for search_range in [1.5]:
for search_range in [0.5, 1.0, 1.5, 1.7]:
    linked = tp.link_df(f, search_range, pos_columns=['xum', 'yum', 'zum'])
    hist, bins = np.histogram(np.bincount(linked.particle.astype(int)),
                              bins=np.arange(10), normed=True)
    plt.step(bins[1:], hist, label='range = {} microns'.format(search_range))
plt.ylabel('relative frequency')
plt.xlabel('track length (frames)')
plt.legend()