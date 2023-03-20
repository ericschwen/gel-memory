# -*- coding: utf-8 -*-
"""
displacements_analysis

plot displacements and compare. Also look at subtracting off mean, etc.

Created on Wed Jul 12 16:24:04 2017

@author: Eric

Modification History:
    v2: also testing adj_displacement results
"""



import tp_custom_functions_v4 as tpc
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

fname = 'u_combined_o5\linked15_mod.csv'

bslash = '\\'
uscore = '_'

# number of zstacks in the set
num_frames = 6

dr_means = []
dx_means = []
dy_means = []
dz_means = []
dr_mean_avgs = []
dr_mean_avgs2 = []
drs_frame = [] # for looking at specific frame


drs_adj_xyz_means = []
drs_adj_x_means = []
drs_adj_xyz_means_avgs = []
drs_adj_x_means_avgs = []

dx_test = []
drs_adj_x_first = []

for i in range(len(subfolders)):
    path = folder + bslash + subfolders[i] + bslash + fname
#    print(path)
    t = pd.read_csv(path)
    
    for fm in range(num_frames-1):
        a = t.loc[t.frame == fm]
        
        # array of just distances between particle pairs
        drs_full = a.dr.values
        
        drs_adj_fullxyz = a.dr_adj_full.values
        drs_adj_fullx = a.dr_adj_x.values
        
        # nan appears for every particle in one frame but not the other
        # remove all nan entries so I can do math
        drs = drs_full[np.isfinite(drs_full)]
        
        drs_adj_xyz = drs_adj_fullxyz[np.isfinite(drs_adj_fullxyz)]
        drs_adj_x = drs_adj_fullx[np.isfinite(drs_adj_fullx)]
        
        drs_adj_xyz_means.append(np.mean(drs_adj_xyz))
        drs_adj_x_means.append(np.mean(drs_adj_x))
                
        a_mean = np.mean(drs)
        dr_means.append(a_mean)
        
        # for testing what drs are for individual frames
        if fm == 0:
            drs_frame.append(a_mean)
            
            
        dxs_full = a.dxum.values
        dxs = dxs_full[np.isfinite(dxs_full)]
        dx_means.append(np.mean(dxs))
        dys_full = a.dyum.values
        dys = dys_full[np.isfinite(dys_full)]
        dy_means.append(np.mean(dys))
        dzs_full = a.dzum.values
        dzs = dzs_full[np.isfinite(dzs_full)]
        dz_means.append(np.mean(dzs))
        
#        # probably useless since i already subtracted off the means for these
#        dxs_adj_full = a.dxum_adj.values
#        dxs_adj = dxs_adj_full[np.isfinite(dxs_adj_full)]
#        dys_adj_full = a.dyum_adj.values
#        dys_adj = dys_adj_full[np.isfinite(dys_adj_full)]
#        dzs_adj_full = a.dzum_adj.values
#        dzs_adj = dzs_adj_full[np.isfinite(dzs_adj_full)]
        
#        if subfolders[i] == '2.4':
#            dx_test.append(np.mean(dxs))
#            if fm == 0:
#                dxs_test = dxs

        # save just first shift
        if fm == 0:
            drs_adj_x_first.append(np.mean(drs_adj_x))
        
    # take average of dr's for each specific strain and append to a list
    dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
    drs_adj_x_means_avgs.append(np.mean(drs_adj_x_means[-(num_frames-1):]))
    
    
    # averages ignoring first point at each strain
    dr_mean_avgs2.append(np.mean(dr_means[-(num_frames-2):]))

plt.plot(range(len(dr_means)), dr_means, 'b:o')
plt.plot(range(len(drs_adj_x_means)), drs_adj_x_means, 'r:o')
plt.plot(range(len(drs_adj_xyz_means)), drs_adj_xyz_means, 'g:o')
#plt.plot(5*np.array(range(len(strains))), drs_adj_x_first, 'c:o')
plt.xlabel('Frame')
plt.ylabel('Mean dr (um)')
plt.title('Displacements over sweep')
plt.show()

# compare mean dr's for different methods
plt.plot(strains, dr_mean_avgs, 'b:o')
plt.plot(strains, drs_adj_x_means_avgs, 'r:o')
#plt.plot(strains, drs_adj_x_first, 'g:o')
#plt.plot(strains, dr_mean_avgs2, 'r:o')
plt.xlabel('Strain (V)')
plt.ylabel('Mean dr (um)')
plt.title('Displacement vs. Strain')
plt.show()

# plot mean displacements in each direction
plt.plot(range(len(dr_means)), dx_means, 'b:o', label = 'dx')
plt.plot(range(len(dr_means)), dy_means, 'r:o', label = 'dy')
plt.plot(range(len(dr_means)), dz_means, 'g:o', label = 'dz')
plt.legend()
plt.xlabel('Frame')
plt.ylabel('Mean displacement (um)')
plt.title('Displacements over sweep')
plt.show()

#==============================================================================
# #plot specific frame
# plt.plot(range(num_frames-1), dx_test, 'b:o')
# #plt.plot(5*np.array(range(len(strains))), drs_frame, 'r:o')
# plt.xlabel('Frame')
# plt.ylabel('Mean dx (um)')
# plt.title('Displacements over sweep')
# plt.show()
#==============================================================================

#==============================================================================
# # for saving untrained part to workspace
# us = strains
# udr1 = drs_adj_x_means_avgs
# udr2 = drs_adj_x_first
#==============================================================================

# for saving untrained part to workspace
#s06 = strains
#dr06 = drs_adj_x_means_avgs
#s10 = strains
#dr10 = drs_adj_x_means_avgs
#s14 = strains
#dr14 = drs_adj_x_means_avgs
#s20 = strains
#dr20 = drs_adj_x_means_avgs

## plot vertical line
#v2s = 0.14;
#trainingAmplitude = 1.0*v2s
#plt.plot(np.ones(100) * trainingAmplitude, np.arange(0.002, 0.2002, 0.002), 'g--')

#
## plot with untrained part
#plt.plot(us, udr2, 'b:o')
#v2s = 0.14;
#trainingAmplitude = 1.0*v2s
#plt.plot(np.ones(100) * trainingAmplitude, np.arange(0.006, 0.6006, 0.006), 'g--')
#plt.plot(s06, dr06, 'r:o')
##plt.plot(s10, dr10, 'g:o')
##plt.plot(s14, dr14, 'c:o')
##plt.plot(s20, dr20, 'y:o')
#plt.xlabel('Strain (V)')
#plt.ylabel('Mean dr (um)')
#plt.title('Displacement vs. Strain')
#plt.show()
#
#
## plot with untrained part
#plt.plot(us, udr2, 'b:o')
#plt.plot(strains, drs_adj_x_means_avgs, 'r:o')
#plt.xlabel('Strain (V)')
#plt.ylabel('Mean dr (um)')
#plt.title('Displacement vs. Strain')
#plt.show()

