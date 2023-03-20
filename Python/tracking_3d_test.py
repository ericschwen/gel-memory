# -*- coding: utf-8 -*-
"""
Created on Wed Sep 20 11:01:26 2017

@author: Eric
"""
# tracking_3d_stacks(path):
""" Track particles through a set of zstacks. Runs trackpy's particle locating
and linking functions with custom variables. This function just makes it easier to 
run easily with my own parameters.
Input: path to a file with prefiltered tiff images named with time and z indices.

Saves csv files for positions, linked positions, and msd (msd currently
commented out).
"""

import tp_custom_functions_v4 as tpc
import os
import pims
import trackpy as tp

# Sample path
# path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\3.0V\u_combined\*.tif'
path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting_bpass\*.tif'

frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
# frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
frames.iter_axes = 't'

# run locate function
f = tp.batch(frames[300:305], diameter=(17, 17, 17), invert = False, separation = (7,7,7), preprocess = False, minmass = 60000)

#Save the data to csv file
f.to_csv(path[:-5] + 'positions.csv', index = False)
# define distances in um instead of pixels
f['xum'] = f['x'] * 0.125
f['yum'] = f['y'] * 0.125
f['zum'] = f['z'] * 0.12

# link particles
linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])

#Save the data to csv file
linked.to_csv(path[:-5] + '17_linked.csv', index = False);