# -*- coding: utf-8 -*-
"""
Calculate contact number distribution

Created on Wed Jul 26 17:50:33 2017
@author: Eric

Modification History:
    v2: add restrictions for x and y (in addition to z) to eliminate boundary
    effects. 3-19-19
    
Notes:
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# file path for linked particle positions from trackpy
#features_file = r'C:\Eric\Xerox\Python\peri\pauses translate\linked_mod.csv'
#features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_post_train_bpass3D_o5\200\positions15_mod.csv')
#features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained short\zstack_pre_sweep_bpass3D_o5\200\positions15_mod.csv')
#features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p400\u_combined_o5\linked15_mod.csv')
#features_file = r'G:\30 um runs backup\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200\positions15_mod.csv';
#features_file = r'G:\30 um runs backup\8-29-17 0.3333Hz\0.6\zstack_post_train_bpass3D_o5\200\positions15_mod.csv';

features_file = r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p0\linked_peri_mod.csv'

f1 = pd.read_csv(features_file)

# create buffer to ignore particles on each edge. Eliminate edge effect.
buff_size = 12
f = f1.loc[(f1.z > 0 + buff_size) & (f1.z < 50 - buff_size) & 
           (f1.x > 0 + buff_size) & (f1.x < 128 - buff_size) &
           (f1.y > 0 + buff_size) & (f1.y < 128 - buff_size)]
## other testing
#f= f1

#contacts = f.contacts.values
contacts = f.contacts_0pt05um.values

h, bin_edges = np.histogram(contacts, bins=np.arange(12), density = False)

pdf_h = np.array(h)/float(sum(h))

# plot the histogram of probablilies
#plt.plot(bin_edges[:-1], pdf_h, 'b:o', label = 'Current')

plt.bar(bin_edges[:-1], pdf_h, width = 1, alpha = 1, edgecolor = 'k')

#plt.plot(bin_edges[:-1], untrained, 'r:o', label = 'Untrained')
#plt.plot(bin_edges[1:], pdf_pre06, 'b:o', label = 'Before training')
#plt.plot(bin_edges[1:], pdf_post06, 'r:o', label = 'After training')

#plt.plot(bin_edges[1:], pdf_prewait, 'b:o', label = 'Before waiting')
#plt.plot(bin_edges[1:], pdf_postsweep, 'r:o', label = 'After sweep')

plt.xlim(0, 8)
plt.ylim(0, .5)
plt.xlabel('Contact number $\mathit{z}$', fontsize = 20)
plt.ylabel('Probability', fontsize = 20)
#plt.title('Contact number distribution', fontsize = 20)
plt.yticks(fontsize = 18)
plt.xticks(fontsize = 18)
plt.legend(loc = 'upper right', fontsize = 18)
plt.show()   

## plot the histogram of counts
#plt.plot(bin_edges[1:], h, 'b:o')
#plt.xlim(0, 10)
#plt.ylim(0, max(h))
#plt.xlabel('Displacement (um)')
#plt.ylabel('Count')
#plt.title('Static Displacement distribution')
#plt.show()   

mean_contacts = np.mean(contacts)
std_contacts = np.std(contacts)
print('mean contacts ' + str(mean_contacts))
print('std ' + str(std_contacts))

#means_06 = np.array([3.8,4.0,4.08,4.08,4.04,4.08,3.92,4.26])
#cycles = np.array([0,50,100,150,200,300,400,500])
#plt.plot(cycles, means_06, 'b:o')

#means_10 = np.array([3.78,3.95,3.9,3.95,4.00,4.13,4.15,4.11])
#means_10_8 = np.array([3.84,4.02,3.95,3.96,4.07,4.17,4.31,4.21])
#cycles = np.array([0,50,100,150,200,300,400,500])
#plt.plot(cycles, means_10, 'r:o')
#plt.plot(cycles, means_10_8, 'b:o')

######## old z cutoffs: neglect between 1 and 1.5 particle diameter in each direction
# modify based on number of z frames

# for 200 frames and 1.5 diameters
#f = f1.loc[(f1.z > 24) & (f1.zum < 176)]

# for 100 frames and 1.5 diameters
#f = f1.loc[(f1.z > 24) & (f1.zum < 76)]

# for 50 frames and 1.2 diameter(s)
#f = f1.loc[(f1.z > 21) & (f1.z < 28)]

# for 50 frames and .75 diameter(s)
#f = f1.loc[(f1.z > 12) & (f1.z < 38)]
############