# -*- coding: utf-8 -*-
"""
adj_displacement_analysis

Checks statistics and such on mean displacements calculated by peri. Use 
to calculate uncertainty in position.

Created on Thu Jan 18 16:54:37 2018

@author: Eric
"""

import pandas as pd
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# import linked file
folder = r'C:\Eric\Xerox\Python\peri\pauses translate'
path = folder + r'\linked_mod.csv'
linked_mod_file = path
t = pd.read_csv(linked_mod_file)

# specific time frames
t0 = t.loc[t.frame==0]
t1 = t.loc[t.frame==1]
t2 = t.loc[t.frame==2]

# Look at non-nan displacements
t0dx = t0.dxum.values[~np.isnan(t0.dxum.values)]
t1dx = t1.dxum.values[~np.isnan(t1.dxum.values)]
t2dx = t2.dxum.values[~np.isnan(t2.dxum.values)]

t0dy = t0.dyum.values[~np.isnan(t0.dyum.values)]
t1dy = t1.dyum.values[~np.isnan(t1.dyum.values)]
t2dy = t2.dyum.values[~np.isnan(t2.dyum.values)]

t0dz = t0.dzum.values[~np.isnan(t0.dzum.values)]
t1dz = t1.dzum.values[~np.isnan(t1.dzum.values)]
t2dz = t2.dzum.values[~np.isnan(t2.dzum.values)]