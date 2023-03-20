# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 16:24:04 2017

@author: Eric

Modification History:
    v2: update strings for 6-28-17 data
    v5: change to get displacements from dataframe with positions, etc. 
    created by displacements_pd (rather than calculating them here)
"""



import tp_custom_functions_v1 as tpc
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

#l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'] # 1.0V sweep
#strains = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])

#l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']   # 1.4V sweep
#strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])

#l1 = ['2.0V']

l2 = ['u_combined']

bslash = '\\'
uscore = '_'

# number of zstacks in the set
num_frames = 6

dr_means = []
dr_mean_avgs = []

for i in range(len(subfolders)):
    for j in range(len(l2)):
        path = folder + bslash + l1[i] + bslash + l2[j]
        print(path)
        for k in range(1,num_frames):
            a_mean = tpc.displacements_3d(path,k,k+1)
            dr_means.append(a_mean)
        dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
        
plt.plot(range(len(dr_means)), dr_means, 'b:o')
plt.xlabel('Frame')
plt.ylabel('Mean dr (um)')
plt.title('Displacements over sweep')
plt.show()

#plt.plot(strains, dr_mean_avgs, 'r:o')
#plt.xlabel('Strain')
#plt.ylabel('Mean dr (um)')
#plt.title('Displacement vs. Strain')
#plt.axis([0, 3.2, 0.1, 0.45 ])
#plt.show()

## save data
#df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
#df_means.to_csv(folder + '\u_displacements.csv')
#
#df_mean_avgs = pd.DataFrame({'pauses':strains,'drs':dr_mean_avgs})
#df_mean_avgs.to_csv(folder + '\u_displacement_means.csv')





#==============================================================================
# #==============================================================================
# # #import and plot mean displacements 8-29-17 ampsweep
# #==============================================================================
# dr_pre = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained long\ampsweep'+
#                      '\u_displacement.csv')
#                      
# dr_post = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0V\ampsweep'+
#                      '\u_displacement_means.csv') 
# v2s = 0.14;
# 
# strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# strains = v2s*strains
# 
# strains1 = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])
# strains1 = v2s*strains1
# 
# 
# 
# line1 = plt.plot(strains, dr_pre.drs.values, 'b:o', Label = 'pre-train')
# line2 = plt.plot(strains1, dr_post.drs.values, 'r:o', Label = 'post-train')
# plt.xlabel('Strain', fontsize = 18)
# plt.ylabel('Mean Displacement (um)', fontsize = 18)
# plt.title('Displacement vs. Strain', fontsize = 18)
# plt.axis([0, 0.45, 0.1, 0.45 ])
# plt.legend(loc = 'upper left', fontsize = 18)
# plt.tick_params(labelsize=18)
# plt.show()
# 
#==============================================================================




#==============================================================================
# 
# # TESTING calculate displacements 7-13-17 ampsweep
# 
# folder = r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\ampsweep_post_train'
# 
# #l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'] # 1.0V sweep
# #strains = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])
# 
# #l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']   # 1.4V sweep
# #strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# 
# l1 = ['2.0V']
# 
# l2 = ['u_combined']
# 
# bslash = '\\'
# uscore = '_'
# 
# num_frames = 6
# 
# dr_means = []
# dr_mean_avgs = []
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j]
#         print(path)
#         for k in range(1,num_frames):
#             a_mean = tpc.displacements_3d(path,k,k+1)
#             dr_means.append(a_mean)
#         dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
#         
# plt.plot(range(len(dr_means)), dr_means, 'b:o')
# plt.xlabel('Frame')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacements over sweep')
# plt.show()
# 
# #plt.plot(strains, dr_mean_avgs, 'r:o')
# #plt.xlabel('Strain')
# #plt.ylabel('Mean dr (um)')
# #plt.title('Displacement vs. Strain')
# #plt.axis([0, 3.2, 0.1, 0.45 ])
# #plt.show()
# 
# ## save data
# #df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
# #df_means.to_csv(folder + '\u_displacements.csv')
# #
# #df_mean_avgs = pd.DataFrame({'pauses':strains,'drs':dr_mean_avgs})
# #df_mean_avgs.to_csv(folder + '\u_displacement_means.csv')
# 
#==============================================================================


#==============================================================================
# # calculate displacements 7-13-17 pauses
# 
# #folder = r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.0V'
# #l1 = ['p0', 'p100', 'p200', 'p300', 'p400', 'p500']
# #l2 = ['u_combined']
# 
# folder = r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V'
# l1 = ['p0', 'p20', 'p40', 'p60', 'p80', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
# l2 = ['u_combined']
# 
# bslash = '\\'
# uscore = '_'
# 
# num_frames = 4
# 
# dr_means = []
# dr_mean_avgs = []
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + 'zstacks_' + l1[i] + bslash + l2[j]
#         print(path)
#         for k in range(1,num_frames):
#             a_mean = tpc.displacements_3d(path,k,k+1)
#             # calculate mean displacement for single pair of frames
#             dr_means.append(a_mean)
#         # calculate mean displacement for the set of frames at a specific pause
#         dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
#         
# plt.plot(range(len(dr_means)), dr_means, 'b:o')
# plt.show()
# 
# pauses = [0, 20, 40, 60, 80, 100, 150, 200, 300, 400, 500]
# 
# plt.plot(pauses[:], dr_mean_avgs[:], 'r:o')
# plt.xlabel('Cycle')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacement vs. Cycle')
# plt.axis([0, 550, 0.1, 0.20 ])
# plt.show()
# 
# # save data
# df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
# df_means.to_csv(folder + '\pause_displacements.csv')
# 
# df_mean_avgs = pd.DataFrame({'pause':pauses,'dr':dr_mean_avgs})
# df_mean_avgs.to_csv(folder + '\pause_displacement_means.csv')
#==============================================================================


#==============================================================================
# 
# # calculate displacements 7-13-17 ampsweep
# 
# folder = r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.0V\ampsweep_post_train'
# 
# l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'] # 1.0V sweep
# strains = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])
# 
# #l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']   # 1.4V sweep
# #strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# 
# l2 = ['u_combined']
# 
# bslash = '\\'
# uscore = '_'
# 
# num_frames = 6
# 
# dr_means = []
# dr_mean_avgs = []
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j]
#         print(path)
#         for k in range(1,num_frames):
#             a_mean = tpc.displacements_3d(path,k,k+1)
#             dr_means.append(a_mean)
#         dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
#         
# plt.plot(range(len(dr_means)), dr_means, 'b:o')
# plt.xlabel('Frame')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacements over sweep')
# plt.show()
# 
# plt.plot(strains, dr_mean_avgs, 'r:o')
# plt.xlabel('Strain')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacement vs. Strain')
# plt.axis([0, 3.2, 0.1, 0.45 ])
# plt.show()
# 
# # save data
# df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
# df_means.to_csv(folder + '\u_displacements.csv')
# 
# df_mean_avgs = pd.DataFrame({'pauses':strains,'drs':dr_mean_avgs})
# df_mean_avgs.to_csv(folder + '\u_displacement_means.csv')
# 
#==============================================================================




#==============================================================================
# # calculate displacements 7-13-17 ampsweep TESTING REMOVING FIRST POINT
# 
# folder = r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\ampsweep_pre_train'
# 
# #l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V'] # 1.0V sweep
# #strains = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])
# 
# l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']   # 1.4V sweep
# strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# 
# l2 = ['u_combined']
# 
# bslash = '\\'
# uscore = '_'
# 
# num_frames = 6
# 
# dr_means = []
# dr_mean_avgs = []
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j]
#         print(path)
#         for k in range(2,num_frames):
#             a_mean = tpc.displacements_3d(path,k,k+1)
#             dr_means.append(a_mean)
#         dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
#         
# plt.plot(range(len(dr_means)), dr_means, 'b:o')
# plt.xlabel('Frame')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacements over sweep')
# plt.show()
# 
# plt.plot(strains, dr_mean_avgs, 'r:o')
# plt.xlabel('Strain')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacement vs. Strain')
# plt.axis([0, 3.2, 0.1, 0.45 ])
# plt.show()
# 
# ## save data
# #df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
# #df_means.to_csv(folder + '\u_displacements.csv')
# #
# df_mean_avgs = pd.DataFrame({'pauses':strains,'drs':dr_mean_avgs})
# df_mean_avgs.to_csv(folder + '\u_displacement_means_no-first-point.csv')
# 
# 
#==============================================================================





#==============================================================================
# # calculate displacements ampsweep 6-22-17 version
# folder = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'
# 
# #l1 = ['0.2V', '0.4V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.0V','2.2V', '2.4V', '2.6V', '2.8V', '3.0V'];
# #strains = [0.2, 0.4, 0.8, 1.0, 1.2, 1.4, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8,3.0]
# 
# l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']
# strains = [0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8]
# 
# l2 = ['u_combined']
# 
# bslash = '\\'
# uscore = '_'
# 
# num_frames = 6
# 
# dr_means = []
# dr_mean_avgs = []
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j]                                             
#         print(path)
#         for k in range(1,num_frames):
#             a_mean = tpc.displacements_3d(path,k,k+1)
#             dr_means.append(a_mean)
#         dr_mean_avgs.append(np.mean(dr_means[-(num_frames-1):]))
#             
# 
# plt.plot(range(len(dr_means)), dr_means, 'b:o')
# plt.xlabel('Frame')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacements over sweep')
# plt.show()
# 
# 
# pauses = [0, 100, 200, 300, 400, 500]
# 
# plt.plot(strains, dr_mean_avgs, 'r:o')
# plt.xlabel('Strain')
# plt.ylabel('Mean dr (um)')
# plt.title('Displacement vs. Strain')
# plt.axis([0, 3.2, 0.1, 0.45 ])
# plt.show()
# 
# # save data
# df_means = pd.DataFrame({'frame':range(len(dr_means)), 'dr': dr_means})
# df_means.to_csv(folder + '\u_displacements.csv')
# df_mean_avgs = pd.DataFrame({'strains':strains,'drs':dr_mean_avgs})
# df_mean_avgs.to_csv(folder + '\u_displacement_means.csv')
#==============================================================================








#==============================================================================
# #==============================================================================
# # #import and plot mean displacements 7-17-17 ampsweep
# #==============================================================================
# dr_pre = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V\ampsweep_pre_train'+
#                      '\u_displacement.csv')
#                      
# dr_post = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.0V\ampsweep_post_train'+
#                      '\u_displacement_means.csv') 
# v2s = 0.14;
# 
# strains = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# strains = v2s*strains
# 
# strains1 = np.array([0.2, 0.6, 0.8, 1.0, 1.2, 1.4, 1.8, 2.2, 2.6, 3.0])
# strains1 = v2s*strains1
# 
# 
# 
# line1 = plt.plot(strains, dr_pre.drs.values, 'b:o', Label = 'pre-train')
# line2 = plt.plot(strains1, dr_post.drs.values, 'r:o', Label = 'post-train')
# plt.xlabel('Strain', fontsize = 18)
# plt.ylabel('Mean Displacement (um)', fontsize = 18)
# plt.title('Displacement vs. Strain', fontsize = 18)
# plt.axis([0, 0.45, 0.1, 0.45 ])
# plt.legend(loc = 'upper left', fontsize = 18)
# plt.tick_params(labelsize=18)
# plt.show()
# 
#==============================================================================




#==============================================================================
# #==============================================================================
# # # import and plot just mean displacements. pauses 6-28-17 version
# #==============================================================================
# 
# dr_run1 = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run1'+
#                      '\pause_displacement_means.csv')
# 
# dr_run2 = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run2'+
#                      '\pause_displacement_means.csv')
# 
# dr_run3 = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.4V run3'+
#                      '\pause_displacement_means.csv')
# 
# dr_1V = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.0V'+
#                      '\pause_displacement_means.csv')
#                      
# 
# line1 = plt.plot(pauses, dr_run1.drs.values, 'b:o', Label = '1.4V run1')
# line2 = plt.plot(pauses, dr_run2.drs.values, 'r:o', Label = '1.4V run2')
# line3 = plt.plot(pauses, dr_run3.drs.values, 'g:o', Label = '1.4V run3')
# line4 = plt.plot(pauses, dr_1V.drs.values, 'k:o', Label = '1.0V')
# plt.xlabel('Cycle', fontsize = 18)
# plt.ylabel('Mean Displacement (um)', fontsize = 18)
# plt.title('Displacement vs. Cycle', fontsize = 18)
# plt.axis([0, 550, 0.1, 0.35 ])
# plt.legend(loc = 'upper right', fontsize = 18)
# plt.tick_params(labelsize=18)
# plt.show()
# 
# 
#==============================================================================







#==============================================================================
# 
# 
# 
# #==============================================================================
# # # import and plot just mean displacements. Ampsweep 6-22-17 version
# #==============================================================================
# 
# dr_pre = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train'+
#                      '\u_displacement_means.csv')
#                      
# dr_post = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'+
#                      '\u_displacement_means.csv') 
# 
# strains_post_train = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# strains_pre_train = np.array([0.2, 0.4, 0.8, 1.0, 1.2, 1.4, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8,3.0])
# 
# v2s = 0.14;
# strains_pre_train = v2s * strains_pre_train
# strains_post_train =v2s * strains_post_train
# 
# line1 = plt.plot(strains_pre_train, dr_pre.drs.values, 'b:o', Label = 'pre-train')
# line2 = plt.plot(strains_post_train, dr_post.drs.values, 'r:o', Label = 'post-train')
# plt.xlabel('Strain', fontsize = 18)
# plt.ylabel('Mean Displacement (um)', fontsize = 18)
# plt.title('Displacement vs. Strain', fontsize = 18)
# plt.axis([0, 0.45, 0.1, 0.45 ])
# plt.legend(loc = 'upper left', fontsize = 18)
# plt.tick_params(labelsize=18)
# plt.show()
#==============================================================================












#==============================================================================
# 
# #==============================================================================
# # # import and plot just mean displacements. pauses 6-28-17 version
# #==============================================================================
#  
# dr_pre_u = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train'+
#                      '\u_displacement_means.csv')
# 
# dr_pre_s = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train'+
#                      '\s_displacement_means.csv')
#                      
# dr_post_u = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'+
#                      '\u_displacement_means.csv') 
# 
# dr_post_s = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'+
#                      '\s_displacement_means.csv') 
# 
# strains_post_train = np.array([0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8])
# strains_pre_train = np.array([0.2, 0.4, 0.8, 1.0, 1.2, 1.4, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8,3.0])
# 
# v2s = 0.14;
# strains_pre_train = v2s * strains_pre_train
# strains_post_train =v2s * strains_post_train
#                      
# 
# line1 = plt.plot(strains_pre_train, dr_pre_u.drs.values, 'b:o', Label = 'unstrained_pre')
# line2 = plt.plot(strains_pre_train, dr_pre_s.drs.values, 'g:o', Label = 'strained_pre')
# line3 = plt.plot(strains_post_train, dr_post_u.drs.values, 'r:o', Label = 'unstrained_post')
# line4 = plt.plot(strains_post_train, dr_post_s.drs.values, 'k:o', Label = 'strained_post')
# plt.xlabel('Strain', fontsize = 18)
# plt.ylabel('Mean Displacement (um)', fontsize = 18)
# plt.title('Displacement vs. Strain', fontsize = 18)
# plt.axis([0, 0.45, 0.1, 0.45 ])
# plt.legend(loc = 'upper left', fontsize = 18)
# plt.tick_params(labelsize=18)
# plt.show()
# 
# 
#==============================================================================
