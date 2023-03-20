# -*- coding: utf-8 -*-
"""
peri-trackpy_pos_comparison.py

Compare the positions calculated by peri to those from
trackpy.

Reads positions from linked trackpy file and writes them to a csv. Those 
positions can then be imported by peri to compare them with positions found by
peri.

Created on Tue Nov 28 09:00:14 2017

@author: Eric
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# import peri data
folder = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses'
ppos_np = np.loadtxt(folder + r'\u1_peri_positions.csv', delimiter = ',')

# make peri positions dataframe
peri_pos = pd.DataFrame(ppos_np, columns = ['z','y','x'])

# import trackpy dataframe
tp_filename = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p100\u_combined_o5\linked15_mod.csv'
tp_full = pd.read_csv(tp_filename)
# select single timestep (single image)
frame1 = tp_full.loc[tp_full.frame == 1]
# select only position columns
tp_pos = frame1[['z','y','x']]

# restrict dataframes to visible region
ppos = peri_pos.loc[(peri_pos.z > 0) & (peri_pos.z < 50) &
                    (peri_pos.y > 0) & (peri_pos.y < 128) &
                    (peri_pos.x > 0) & (peri_pos.x < 128)]

tppos = tp_pos.loc[(tp_pos.z > 0) & (tp_pos.z < 50) &
                    (tp_pos.y > 0) & (tp_pos.y < 128) &
                    (tp_pos.x > 0) & (tp_pos.x < 128)]



# save positions to file for testing with peri
test_folder = r'C:\Eric\Xerox\Python\peri\test comparison with tp'
tppos_np = np.array([tppos.z.values, tppos.y.values, tppos.x.values]).transpose()
np.savetxt(test_folder + r'\u1_tp_pos.csv', tppos_np, delimiter = ',')