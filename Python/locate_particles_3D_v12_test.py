# -*- coding: utf-8 -*-
"""
Created on Thu Sep 21 17:03:58 2017

@author: Eric
"""

import matplotlib as mpl
import matplotlib.pyplot as plt
#mpl.rc('figure',  figsize=(10, 6))
import numpy as np
import pandas as pd

import pims
import trackpy as tp
import os

path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 sweep 0.2 u2\u2\*.tif';
frames = pims.ImageSequenceND(path, axes_identifiers = ['z'])
#frames.iter_axes = 't'
# frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
frames

features = tp.locate(frames[0], diameter=(17, 17, 17), invert = True, separation = (7,7,7), preprocess = True) 
# diameter = (z, y x)
# preprocess = False disables bandpass filtering by trackpy (do my own first instead)
#features.head()  # displays first 5 rows


# plot g(r)
[edges, g_r] = tp.pair_correlation_3d(features, 50)
fig, ax = plt.subplots()
ax.plot(edges[1:]*0.125, g_r, 'b:o');
ax.set(ylabel='G(r)',
       xlabel='um');

# plot subpixel bias (basically repeating subpx_bias function in a way i can plot it)

pos_columns = ['x','y','z']
hists = features[pos_columns].applymap(lambda x: x % 1)

# make histogram of displacemets
hx, bin_edges = np.histogram(hists['x'], bins=np.arange(11)/10., density = False)
hy, bin_edges = np.histogram(hists['y'], bins=np.arange(11)/10., density = False)
hz, bin_edges = np.histogram(hists['z'], bins=np.arange(11)/10., density = False)
# plot the histogram
fig, ax = plt.subplots(2, 2)
ax[0,0].grid()
ax[0,0].bar(bin_edges[1:], hx, width = bin_edges[1]-bin_edges[0])
ax[0,0].set_title('x')
ax[0,1].grid()
ax[0,1].bar(bin_edges[1:], hy, width = bin_edges[1]-bin_edges[0])
ax[0,1].set_title('y')
ax[1,0].grid()
ax[1,0].bar(bin_edges[1:], hz, width = bin_edges[1]-bin_edges[0])
ax[1,0].set_title('z')
fig.delaxes(ax[1,1])
#mpl.rc('figure',  figsize=(10, 12))
plt.show()

savepath = path[:-5] + 'subpix_bias.png'
fig.savefig(savepath, bbox_inches='tight',frameon = False, dpi = 800);


#tp.subpx_bias(features)
print('Features found: {0}'.format(len(features)))

textpath = path[:-5] + 'features.txt'
text_file = open(textpath, "w")
text_file.write('Features found: {0}'.format(len(features)))
text_file.close()
