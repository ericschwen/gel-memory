# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 16:24:04 2017

@author: Eric

Modification History:
    v2: update strings for 6-28-17 data
    v5: change to get displacements from dataframe with positions, etc. 
    created by displacements_pd (rather than calculating them here)
"""



import tp_custom_functions_v3 as tpc
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

import os



folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\ampsweep'

subfolders = os.listdir(folder)

strains = np.array(subfolders)
strains = strains.astype(float)

fname = 'u_combined\linked_w_displacements.csv'

bslash = '\\'
uscore = '_'

# number of zstacks in the set
num_frames = 6

dr_means = []
dr_mean_avgs = []
dr_mean_avgs2 = []
drs_frame = [] # for looking at specific frame

for i in range(len(subfolders)):
    path = folder + bslash + subfolders[i] + bslash + fname
#    print(path)
    t = pd.read_csv(path)
    
    for fm in range(num_frames-1):
        a = t.loc[t.frame == fm]
        
        # array of just distances between particle pairs
        drs_full = a.dr.values
        
        # nan appears for every particle in one frame but not the other
        # remove all nan entries so I can do math
        drs = drs_full[np.isfinite(drs_full)]
                
        a_mean = np.mean(drs)
        dr_means.append(a_mean)
        
        # for testing what drs are for individual frames
        if fm == 0:
            drs_frame.append(a_mean)
        
    # take average of dr's for each specific strain and append to a list
    dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
    
    # averages ignoring first point at each strain
    dr_mean_avgs2.append(np.mean(dr_means[-(num_frames-2):]))

plt.plot(range(len(dr_means)), dr_means, 'b:o')
plt.plot(5*np.array(range(len(strains))), drs_frame, 'r:o')
plt.xlabel('Frame')
plt.ylabel('Mean dr (um)')
plt.title('Displacements over sweep')
plt.show()

#plt.plot(strains, dr_mean_avgs, 'b:o')
plt.plot(strains, dr_mean_avgs2, 'r:o')
plt.xlabel('Strain (V)')
plt.ylabel('Mean dr (um)')
plt.title('Displacement vs. Strain')
plt.show()

#==============================================================================
# # for saving untrained part to workspace
# us = strains
# udr1 = dr_mean_avgs
# udr2 = dr_mean_avgs2
#==============================================================================
#
#plt.plot(us, udr2, 'b:o')
#plt.plot(strains, dr_mean_avgs2, 'r:o')
#plt.xlabel('Strain (V)')
#plt.ylabel('Mean dr (um)')
#plt.title('Displacement vs. Strain')
#plt.show()

