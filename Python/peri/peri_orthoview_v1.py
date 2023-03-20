# -*- coding: utf-8 -*-
"""
Trackpy orthoviewer

Use PERI's OrthoPrefeature function to analyze features found by trackpy.

NEEDS IPython console graphics preference set to automatic (and spyder restarted)
to acutally make interactive OrthoPrefeature. Otherwise just put commands in 
an IPython window.

Created on Wed Sep 27 14:18:35 2017

@author: Eric
"""

from peri import util, runner
from peri.viz.interaction import OrthoPrefeature

import pandas as pd
import numpy as np

folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 sweep 2.4 u0'

# path to image (tif stack)
tifstack_path = folder + r'\u0.tif'
# path to features file
features_path = folder + r'\to test\u0_bpass3D_o9_n1\positions_17-17-13.csv'

im = util.RawImage(tifstack_path)

## optionally use runner to locate particles
#run_pos = runner.locate_spheres(im, 5, dofilter = True)

features = pd.read_csv(features_path)
positions = np.array(features[['z','y','x']])

#positions = np.array(positions_pd)

# #Need to execute this command on its own to have interactive.
#OrthoPrefeature(im.get_image(), positions, viewrad = 5)

