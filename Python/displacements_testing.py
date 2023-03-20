# -*- coding: utf-8 -*-
"""
Script for analyzing displacements of particles between two frames.
Takes inputs from file for positions and linked trajectories created by 
trackpy.


Created on Wed Jul 12 00:49:09 2017

@author: Eric
"""

import numpy as np
import pandas as pd
#import trackpy as tp

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\3.6\u_combined_o5'
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p100\u_combined_o5'

#path = r'C:\Eric\Xerox\Python\peri\pauses translate'
#path = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses'
#path = r'C:\Eric\Xerox\Python\peri\128x128x50_static'

path = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p100'
#path = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge'

#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting_bpass\linked 15 diameter'


t = pd.read_csv(path + '\linked_mod.csv')

#path = r'C:\Eric\Xerox\Python\peri\128x128x50_static'
#t = pd.read_csv(path + '\linked15_tp_mod.csv')

#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p100\u_combined_o5'
#t = pd.read_csv(path + r'\linked15_mod.csv')

## restrict to tiled region in x, y and z
#t = t.loc[(t.z > 0) & (t.z < 50) &
#                    (t.y > 0) & (t.y < 128) &
#                    (t.x > 0) & (t.x < 128)]


# restrict to tiled region in x, y and z WITH BUFFER
buff_size = 6
t = t.loc[(t.z > 0 + buff_size) & (t.z < 50 - buff_size) &
                    (t.y > 0 + buff_size) & (t.y < 128 - buff_size) &
                    (t.x > 0 + buff_size) & (t.x < 128 - buff_size)]

# restrict to single frame if wanted
#f = t.loc[t.frame == 0]
#f = t.loc[t.frame <3]
f = t

# straight displacements part
drs_full = f.dr_adj_full.values
    
# remove all nan entries so I can do math
drs = drs_full[np.isfinite(drs_full)]

# calculate mean displacement of particles between the two frames
dr_mean = np.mean(drs)
dr_var = np.var(drs)
dr_std= np.sqrt(dr_var)
dr_median = np.median(drs)

print('mean displacement: ' + str(dr_mean))
print('particle displacement count: ' + str(len(drs)))

# make histogram of displacemets
h, bin_edges = np.histogram(drs, bins=np.arange(21)/40., density = False)

#
## plot the histogram of probabilities
#plt.bar(bin_edges[0:-1], h/float(sum(h)), width = bin_edges[1]-bin_edges[0])
##plt.xlim(min(bin_edges), 0.2)
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
#plt.ylabel('Probability', fontsize = 18)
#plt.title('Displacement distribution', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show() 


########################################################################
## graph mobile and immobile histograms
drs_mobile = drs[drs>0.06]
drs_immobile = drs[drs < 0.06]

h_m, bin_edges = np.histogram(drs_mobile, bins=np.arange(26)/50., density = False)
h_im, bin_edges = np.histogram(drs_immobile, bins=np.arange(26)/50., density = False)

# plot the histogram
plt.bar(bin_edges[0:-1], h_m/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'r')
plt.bar(bin_edges[0:-1], h_im/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'b')
plt.xlim(min(bin_edges), max(bin_edges))
#plt.ylim(0, 250)
plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
plt.ylabel('Probability', fontsize = 18)
plt.title('Displacement distribution', fontsize = 18)
#plt.axis([0, 550, 0.1, 0.35 ])
#plt.legend(loc = 'upper right', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show() 

################################################################################
## plot the histogram with counts
#plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('High shear', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()   


################################################################################


## plot subpixel bias (basically repeating subpx_bias function in a way i can plot it)
#        
#pos_columns = ['x','y','z']
#hists = f[pos_columns].applymap(lambda x: x % 1)
#
## make histogram of displacemets
#hx, bin_edges = np.histogram(hists['x'], bins=np.arange(11)/10., density = False)
#hy, bin_edges = np.histogram(hists['y'], bins=np.arange(11)/10., density = False)
#hz, bin_edges = np.histogram(hists['z'], bins=np.arange(11)/10., density = False)
## plot the histogram
#fig, ax = plt.subplots(2, 2)
#ax[0,0].grid()
#ax[0,0].bar(bin_edges[1:], hx, width = bin_edges[1]-bin_edges[0])
#ax[0,0].set_title('x')
#ax[0,1].grid()
#ax[0,1].bar(bin_edges[1:], hy, width = bin_edges[1]-bin_edges[0])
#ax[0,1].set_title('y')
#ax[1,0].grid()
#ax[1,0].bar(bin_edges[1:], hz, width = bin_edges[1]-bin_edges[0])
#ax[1,0].set_title('z')
#fig.delaxes(ax[1,1])
##mpl.rc('figure',  figsize=(10, 12))
#plt.show()

