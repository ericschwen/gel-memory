# -*- coding: utf-8 -*-
"""
binary_radii_analysis

Script for testing radii in a binary glass. Uses PERI state.

Created on Thu Mar 28 13:12:50 2019

@author: Eric
"""

from peri import util, runner, models, states
from peri.comp import objs, comp, ilms, exactpsf
import peri.opt.optimize as opt
import peri.opt.addsubtract as addsub
from peri.viz.interaction import OrthoManipulator, OrthoViewer, OrthoPrefeature
import numpy as np

from peri.test import analyze
#from peri.viz import plots

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))
mpl.rc('xtick', labelsize = 20)
mpl.rc('ytick', labelsize = 20)

# import peri state
#st = states.load(r'C:\Users\Eric\Desktop\From cluster\glass peri 4-4-19\10 shifted\10.tif-peri-binary-polished.pkl')
st = states.load(r'C:/Users/Eric/Desktop/From cluster/peri 1-6-18 data/128x128x50 p100/u0.tif-peri-m-finished.pkl')

# get particle radii
rad = st.obj_get_radii()
# ignore radii outside of image 
# good_particles returns a mask of particles with radius >0 and position
# inside box
in_frame_mask = analyze.good_particles(st)
good_rad = rad[in_frame_mask]

# histogram with counts
rh, rb = np.histogram(good_rad, bins=30)
fig1, ax1 = plt.subplots()
ax1.plot(rb[:-1], rh, 'b:o')
#ax1.set_xlim([0.6, 1.2])
ax1.set_xlabel('radius ($\mu m$)', fontsize = 20)
ax1.set_ylabel('Count', fontsize = 20)
fig1.show()

## histogram with probabilities
#rh, rb = np.histogram(good_rad, bins=30)
#fig1, ax1 = plt.subplots()
#ax1.plot(rb[:-1], rh/float(len(good_rad)), 'b:o')
##ax1.set_xlim([0.6, 1.2])
#ax1.set_xlabel('radius ($\mu m$)', fontsize = 20)
#ax1.set_ylabel('Prob', fontsize = 20)
#fig1.show()

## restrict to only larger or smaller particles
#small_rad = good_rad[np.logical_and(good_rad<6.5, good_rad>3.5)]
#large_rad = good_rad[good_rad>6.5]