# -*- coding: utf-8 -*-
"""

Visualize located particles from trackpy using peri's orthoprefeature

Created on Thu Jan 11 14:43:01 2018

@author: Eric
"""
from peri import util, states
from peri.viz.interaction import OrthoManipulator, OrthoViewer, OrthoPrefeature
import numpy as np
import pandas as pd

# import image
im = util.RawImage(r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.0\u0.tif')

## View raw image if wanted
#OrthoViewer(im.get_image())

# import trackpy locations
df_path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep\1.0\u_combined_o5\linked_mod.csv'
df = pd.read_csv(df_path)

# restrict to first frame
t = df.loc[df.frame == 0]

# particle positions (z,y,x)
particle_pos = np.transpose(np.array((t.z.values, t.y.values, t.x.values)))

## view image with located particles
#OrthoPrefeature(im.get_image(), particle_pos, viewrad=5)