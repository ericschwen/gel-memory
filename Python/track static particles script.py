# -*- coding: utf-8 -*-
"""
track static set

Created on Thu Oct 05 23:12:46 2017

@author: Eric
"""
import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting_bpass\waiting*.tif'

frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
# frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
frames.iter_axes = 't'

# run locate function
f = tp.batch(frames[300:305], diameter=(15,15,15), invert = False, separation = (11,11,11),
             preprocess = False, minmass = 40000)

#Save the data to csv file
f.to_csv(path[:-5] + 'positions15.csv', index = False)
# define distances in um instead of pixels
f['xum'] = f['x'] * 0.127
f['yum'] = f['y'] * 0.127
f['zum'] = f['z'] * 0.12

# link particles
linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])

#Save the data to csv file
linked.to_csv(path[:-5] + 'linked15.csv', index = False)