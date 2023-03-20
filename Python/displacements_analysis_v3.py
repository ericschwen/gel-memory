# -*- coding: utf-8 -*-
"""
displacements_analysis

plot displacements and compare. Also look at subtracting off mean, etc.

Created on Wed Jul 12 16:24:04 2017

@author: Eric

Modification History:
    v2: also testing adj_displacement results
    v3: clean up and update for o5 filtering and 15 locating
"""



#import tp_custom_functions_v4 as tpc
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

import os


#folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep'
folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\Untrained 1.0\ampsweep'

subfolders = os.listdir(folder)

strains = np.array(subfolders)
strains = strains.astype(float)

fname = 'u_combined_o5\linked_mod.csv'

bslash = '\\'
uscore = '_'

# number of zstacks in the set
num_frames = 4

dr_means = []
dx_means = []
dy_means = []
dz_means = []
dr_mean_avgs = []
dr_mean_avgs2 = []
dr_mean_avgs3 = []
dr_mean_avgs4 = []
drs_frame = [] # for looking at specific frame


drs_adj_xyz_means = []
drs_adj_x_means = []
drs_adj_xyz_means_avgs = []
drs_adj_x_means_avgs = []

dx_test = []
drs_adj_x_first = []
drs_adj_xyz_first = []
drs_adj_xyz_median = []

for i in range(len(subfolders)):
    path = folder + bslash + subfolders[i] + bslash + fname
#    print(path)
    t = pd.read_csv(path)
    
    for fm in range(num_frames-1):
        # select invidividual frame and only positive displacements
        a = t.loc[(t.frame == fm) & (t.dr > 0)]
        
        # array of just distances between particle pairs
        drs = a.dr.values
        drs_adj_xyz = a.dr_adj_full.values
        drs_adj_x = a.dr_adj_x.values
        
        dr_means.append(np.mean(drs))
        drs_adj_xyz_means.append(np.mean(drs_adj_xyz))
        drs_adj_x_means.append(np.mean(drs_adj_x))
        
        # local variable to keep track of mean displacements for each loop
        if fm == 0:
            f_dr_adj_xyz_means = [np.mean(drs_adj_xyz)]
        else:
            f_dr_adj_xyz_means.append(np.mean(drs_adj_xyz))
        
        # for testing what drs are for individual frames
        if fm == 0:
            drs_frame.append(np.mean(drs))
            
            
        dxs = a.dxum.values
        dx_means.append(np.mean(dxs))
        dys = a.dyum.values
        dy_means.append(np.mean(dys))
        dzs = a.dzum.values
        dz_means.append(np.mean(dzs))
        
#        # probably useless since i already subtracted off the means for these
#        dxs_adj_full = a.dxum_adj.values
#        dxs_adj = dxs_adj_full[np.isfinite(dxs_adj_full)]
#        dys_adj_full = a.dyum_adj.values
#        dys_adj = dys_adj_full[np.isfinite(dys_adj_full)]
#        dzs_adj_full = a.dzum_adj.values
#        dzs_adj = dzs_adj_full[np.isfinite(dzs_adj_full)]
        

        # save just first shift
        if fm == 0:
            drs_adj_x_first.append(np.mean(drs_adj_x))
            drs_adj_xyz_first.append(np.mean(drs_adj_xyz))
            
        
    # take average of dr's for each specific strain and append to a list
    dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
    drs_adj_x_means_avgs.append(np.mean(drs_adj_x_means[-(num_frames-1):]))
    drs_adj_xyz_means_avgs.append(np.mean(drs_adj_xyz_means[-(num_frames-1):]))
    
    
    # averages ignoring first point at each strain
    dr_mean_avgs2.append(np.mean(drs_adj_xyz_means[-(num_frames-2):]))
    
    # average while limiting max to remove outliers
    f_dr_adj_xyz_means_cut = []
    for mean in f_dr_adj_xyz_means:
        if mean < 0.4:
            f_dr_adj_xyz_means_cut.append(mean)
    dr_mean_avgs3.append(np.mean(f_dr_adj_xyz_means_cut))
    
    # average while limiting max to remove outliers
    f_dr_adj_xyz_means_cut = []
    for mean in f_dr_adj_xyz_means:
        if mean < (np.mean(f_dr_adj_xyz_means) + np.std(f_dr_adj_xyz_means)):
            f_dr_adj_xyz_means_cut.append(mean)
    dr_mean_avgs4.append(np.mean(f_dr_adj_xyz_means_cut))
    
    # just take median displacement
    drs_adj_xyz_median.append(np.median(f_dr_adj_xyz_means))
            
    

plt.plot(range(len(dr_means)), dr_means, 'b:o')
plt.plot(range(len(drs_adj_x_means)), drs_adj_x_means, 'r:o')
plt.plot(range(len(drs_adj_xyz_means)), drs_adj_xyz_means, 'g:o')
plt.plot((num_frames-1)*np.array(range(len(strains))), drs_adj_x_first, 'c:o')
plt.xlabel('Frame')
plt.ylabel('Mean dr (um)')
plt.title('Displacements over sweep')
plt.show()

# compare mean dr's for different methods
#plt.plot(strains, dr_mean_avgs, 'b:o')
#plt.plot(strains, drs_adj_x_means_avgs, 'r:o')
#plt.plot(strains, drs_adj_x_first, 'g:o')
#plt.plot(strains, drs_adj_xyz_first, 'y:o')
#plt.plot(strains, dr_mean_avgs3, 'c:o')
plt.plot(strains, drs_adj_xyz_means_avgs, 'b:o')
#plt.plot(strains, drs_adj_xyz_median, 'r:o')
#plt.plot(strains, dr_mean_avgs4, 'b:o')
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

### COMPARISON:
## save data to variables for different runs:
#strains_1p0 = strains
#untrained_1p0 = drs_adj_xyz_means_avgs
#strains_0p6 = strains
#untrained_0p6 = drs_adj_xyz_means_avgs
#strains_delayed = strains
#untrained_delayed = drs_adj_xyz_means_avgs
#drs_0p6 = drs_adj_xyz_means_avgs
#drs_1p0 = drs_adj_xyz_means_avgs

##plt.plot(strains, drs_adj_xyz_means_avgs, 'r:o')
#plt.plot(strains_1p0, drs_1p0, 'y:o', label = '1.0')
#plt.plot(strains_0p6, drs_0p6, 'c:o', label = '0.6')
#plt.plot(strains_1p0, untrained_1p0, 'b:o', label = 'Un 1.0')
#plt.plot(strains_0p6, untrained_0p6, 'r:o', label = 'Un 0.6')
#plt.plot(strains_delayed, untrained_delayed, 'g:o', label = 'Un del')
#plt.xlabel('Strain (V)')
#plt.ylabel('Mean dr (um)')
#plt.title('Mean displacement vs. strain')
#plt.legend()
##plt.xlim(0,2)
##plt.ylim(0.05, 0.2)
#plt.show()


# make data frame with results
data =  {'strains' : strains, 'drs_adj_xyz_means_avgs': drs_adj_xyz_means_avgs}
df = pd.DataFrame(data)
df.to_csv(folder[:-8] + 'disp_vs_strain.csv', index = False)

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

