# -*- coding: utf-8 -*-
"""
Single_displacemen_check

Check displacement with orthoviewer to see if it makes sense.

Created on Wed Oct 04 00:03:42 2017

@author: Eric
"""

from peri import util
from peri.viz.interaction import OrthoPrefeature

import numpy as np
import pandas as pd

im1_path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.0\u0_o5.tif'
im2_path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.0\u1_o5.tif'


im1 = util.RawImage(im1_path)
im2 = util.RawImage(im2_path)

features_path =  r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.0\u_combined_o5\linked15_mod.csv'

features = pd.read_csv(features_path)

# get displacements in pixels
features['dx'] = features['dxum'] /0.127
features['dy'] = features['dyum'] /0.127
features['dz'] = features['dzum'] /0.12

cd_full = features.loc[features.frame == 0]

#cutoff distance to be ignored
cutoff = 1.3
cd = cd_full.loc[cd_full['dr_adj_x'] > cutoff]
#cd1 = cd_full.loc[(cd_full['dr_adj_x'] >0.5) & (cd_full['dr_adj_x'] < 1.0)]

pd = cd[['x','y','z', 'dx', 'dy', 'dz', 'dxum', 'dyum', 'dzum', 'dr_adj_x']]

#positions = cd[['x','y','z']]
positions = np.array(cd[['z','y','x']])

#displacements = cd[['dx', 'dy', 'dz']]
displacements = np.array(cd[['dz','dy','dx']])

# get position of a particle in first and second frames
# OrthoPrefeature requires more than one particle to function.
r1 = positions[0:2,:]
r2 = positions[0:2,:] + displacements[0:2,:]

## view particle in two frames
#OrthoPrefeature(im1.get_image(), r1, viewrad = 5)
#OrthoPrefeature(im2.get_image(), r2, viewrad = 5)