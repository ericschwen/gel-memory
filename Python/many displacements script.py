# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 16:24:04 2017

@author: Eric
"""
import tp_custom_functions_v1 as tpc
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

folder = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'
#l1 = ['0.2V', '0.4V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.0V','2.2V', '2.4V', '2.6V', '2.8V', '3.0V'];
l1 = ['0.2V', '0.6V', '1.0V', '1.2V', '1.4V', '1.6V', '2.0V', '2.4V', '2.8V']
l2 = ['u_combined']

bslash = '\\'
uscore = '_'

num_frames = 3

dr_means = []
dr_mean_avgs = []

for i in range(len(l1)):
    for j in range(len(l2)):
        path = folder + bslash + l1[i] + bslash + l2[j]                                             
        print(path)
        for k in range(1,num_frames):
            a_mean = tpc.displacements_3d(path,k,k+1)
            dr_means.append(a_mean)
        dr_mean_avgs.append(np.mean(dr_means[-5:]))
            

plt.plot(range(len(dr_means)), dr_means, 'b:o')
plt.show()

strains_post_train = [0.2, 0.6, 1.0, 1.2, 1.4, 1.6, 2.0, 2.4, 2.8]
strains_pre_train = [0.2, 0.4, 0.8, 1.0, 1.2, 1.4, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8,3.0]

plt.plot(strains_post_train, dr_mean_avgs, 'r:o')
plt.xlabel('Strain')
plt.ylabel('Mean dr (um)')
plt.title('Displacement vs. Strain')
plt.axis([0, 3.2, 0.1, 0.45 ])
plt.show()

# save data
df_mean_avgs = pd.DataFrame({'strains':strains_post_train,'drs':dr_mean_avgs})
df_mean_avgs.to_csv(folder + '\u_displacement_means.csv')



#==============================================================================
# # import and plot just mean displacements
#==============================================================================

dr_pre = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train'+
                     '\u_displacement_means.csv')
                     
dr_post = pd.read_csv(r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_post_train'+
                     '\u_displacement_means.csv') 

line1 = plt.plot(strains_pre_train, dr_pre.drs.values, 'b:o', Label = 'pre-train')
line2 = plt.plot(strains_post_train, dr_post.drs.values, 'r:o', Label = 'post-train')
plt.xlabel('Strain', fontsize = 18)
plt.ylabel('Mean Displacement (um)', fontsize = 18)
plt.title('Displacement vs. Strain', fontsize = 18)
plt.axis([0, 3.2, 0.1, 0.45 ])
plt.legend(loc = 'upper left', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show()



