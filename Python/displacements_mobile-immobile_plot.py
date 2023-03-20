# -*- coding: utf-8 -*-
"""
Script for analyzing displacements of particles between two frames.
Takes inputs from file for positions and linked trajectories created by 
trackpy.

Plots pdf of displacements divided into mobile and immobile parts.

Created on Wed Jul 12 00:49:09 2017

@author: Eric
"""

import numpy as np
import pandas as pd
import trackpy as tp

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting_bpass'
path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\3.6\u_combined_o5'
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p0\u_combined_o5'
t = pd.read_csv(path + '\linked15_mod.csv')

#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\2.4\u_combined_n9'
#t = pd.read_csv(path + '\linked17_mod.csv')

#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\0.2\u_combined'
#t = pd.read_csv(path + '\linked_w_displacements_w_contacts_w_adj_disp.csv')

# restrict to single frame
#f = t.loc[t.frame == 1]
f = t

# straight displacements part
drs_full = f.dr_adj_full.values
    
# nan appears for every particle in one frame but not the other
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
h, bin_edges = np.histogram(drs, bins=np.arange(21)/20., density = False)

## plot the histogram
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

# plot the histogram
plt.bar(bin_edges[1:], h/float(sum(h)), width = bin_edges[1]-bin_edges[0])
plt.xlim(min(bin_edges), max(bin_edges))
#plt.ylim(0, 250)
plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
plt.ylabel('Probability', fontsize = 18)
plt.title('Displacement distribution', fontsize = 18)
#plt.axis([0, 550, 0.1, 0.35 ])
#plt.legend(loc = 'upper right', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show() 

# graph mobile and immobile
drs_mobile = drs[drs>0.3]
drs_immobile = drs[drs < 0.3]

h_m, bin_edges = np.histogram(drs_mobile, bins=np.arange(21)/20., density = False)
h_im, bin_edges = np.histogram(drs_immobile, bins=np.arange(21)/20., density = False)

# plot the histogram
plt.bar(bin_edges[1:], h_m/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'r')
plt.bar(bin_edges[1:], h_im/float(sum(h)), width = bin_edges[1]-bin_edges[0], color = 'b')
plt.xlim(min(bin_edges), max(bin_edges))
#plt.ylim(0, 250)
plt.xlabel('Displacement ($\mu m$)', fontsize = 18)
plt.ylabel('Probability', fontsize = 18)
plt.title('Displacement distribution', fontsize = 18)
#plt.axis([0, 550, 0.1, 0.35 ])
#plt.legend(loc = 'upper right', fontsize = 18)
plt.tick_params(labelsize=18)
plt.show() 

# sort displacements by percentile
drs_sorted = np.sort(drs)

p75= drs_sorted[int(.75*len(drs))]
p90= drs_sorted[int(.90*len(drs))]
p95= drs_sorted[int(.95*len(drs))]
p99= drs_sorted[int(.99*len(drs))]


# rearrangement histograms

## dz
#dzs_full = f.dzum.values
#dzs = dzs_full[np.isfinite(dzs_full)]
#
## convert to pixels
#dzs = dzs/.12
#
# # make histogram of displacemets
#hz, bin_edges = np.histogram(dzs, bins=np.arange(201)/100., density = False)
#
## plot the histogram
#plt.bar(bin_edges[1:], hz, width = bin_edges[1]-bin_edges[0])
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement (px)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('Z Displacement Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()
#
## dy
#
#dys_full = f.dyum.values
#dys = dys_full[np.isfinite(dys_full)]
#
#dys = dys /.127
#
# # make histogram of displacemets
#hy, bin_edges = np.histogram(dys, bins=np.arange(201)/100., density = False)
#
## plot the histogram
#plt.bar(bin_edges[1:], hy, width = bin_edges[1]-bin_edges[0])
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement (px)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('Y Displacement Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()
#
## dx
#
#dxs_full = f.dxum_adj.values
#dxs = dxs_full[np.isfinite(dxs_full)]
#
#dxs = dxs /.127
#
# # make histogram of displacemets
#hy, bin_edges = np.histogram(dxs, bins=np.arange(201)/100., density = False)
#
## plot the histogram
#plt.bar(bin_edges[1:], hy, width = bin_edges[1]-bin_edges[0])
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement (px)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('X Displacement Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()


## plot the histogram comparison
#plt.bar(bin_edges[1:], hy_o5)
#plt.bar(bin_edges[1:], hy_o9)
#plt.bar(bin_edges[1:], hy)
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement (um)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('Displacement Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()
#
## plot the histogram comparison
#plt.plot(bin_edges[1:], hz_o5, 'b')
#plt.plot(bin_edges[1:], hz_o9, 'c')
#plt.plot(bin_edges[1:], hz, 'r')
#plt.xlim(min(bin_edges), max(bin_edges))
##plt.ylim(0, 250)
#plt.xlabel('Displacement (um)', fontsize = 18)
#plt.ylabel('Count', fontsize = 18)
#plt.title('Displacement Histogram', fontsize = 18)
##plt.axis([0, 550, 0.1, 0.35 ])
##plt.legend(loc = 'upper right', fontsize = 18)
#plt.tick_params(labelsize=18)
#plt.show()

#==============================================================================
# # could also get and plot histogram using matplotlib hist function
# #plt.hist(drs)
# 
# # calculate mode
# #max_counts = np.max(h)
# dr_mode_index = np.argmax(h)
# dr_mode= bin_edges[dr_mode_index]
# 
# # Save statistics to csv
# disp_stats = pd.DataFrame({'dr_mean':[dr_mean], 'dr_var':[dr_var],
#                             'dr_std':[dr_std], 'dr_median':[dr_median],
#                             'dr_mode':[dr_mode]})
# 
# disp_stats.to_csv(path[:-5] + 'displacement_stats.csv')
# 
# # Save histogram to csv
# dr_hist = pd.DataFrame({'disp_hist':h, 'bin_edges':bin_edges[1:]})
# dr_hist.to_csv(path + '\displacement_histogram.csv')
#==============================================================================

#==============================================================================
# 
# # plot subpixel bias (basically repeating subpx_bias function in a way i can plot it)
#         
# pos_columns = ['x','y','z']
# hists = f[pos_columns].applymap(lambda x: x % 1)
# 
# # make histogram of displacemets
# hx, bin_edges = np.histogram(hists['x'], bins=np.arange(11)/10., density = False)
# hy, bin_edges = np.histogram(hists['y'], bins=np.arange(11)/10., density = False)
# hz, bin_edges = np.histogram(hists['z'], bins=np.arange(11)/10., density = False)
# # plot the histogram
# fig, ax = plt.subplots(2, 2)
# ax[0,0].grid()
# ax[0,0].bar(bin_edges[1:], hx, width = bin_edges[1]-bin_edges[0])
# ax[0,0].set_title('x')
# ax[0,1].grid()
# ax[0,1].bar(bin_edges[1:], hy, width = bin_edges[1]-bin_edges[0])
# ax[0,1].set_title('y')
# ax[1,0].grid()
# ax[1,0].bar(bin_edges[1:], hz, width = bin_edges[1]-bin_edges[0])
# ax[1,0].set_title('z')
# fig.delaxes(ax[1,1])
# #mpl.rc('figure',  figsize=(10, 12))
# plt.show()
# 
#==============================================================================
