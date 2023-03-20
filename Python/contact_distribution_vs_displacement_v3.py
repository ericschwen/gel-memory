# -*- coding: utf-8 -*-
"""
Script to compare contact number vs displacement

Created on Wed Jul 26 17:50:33 2017
@author: Eric

Modification History:
    v2: use peri data
    v3: add (optional) buffer on sides as well
Notes:
    Maybe try limiting to specific frames as well. Especially if this is going
    to be skewed by the data where the first frame is shifted.
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(5, 3))

# file path for linked particle positions from trackpy
#linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\2.4\u_combined_o5\linked15_mod.csv')
#linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p50\u_combined_o5\linked15_mod.csv')
#linked_features_file = (r'F:\30 um runs backup\8-29-17 0.3333Hz\0.6\p50\u_combined_o5\linked15_mod.csv')
#linked_features_file = r'C:\Eric\Xerox\Python\peri\pauses translate\linked_mod.csv'
#linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p100\linked_mod.csv'
linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p150\linked_peri_mod.csv'

#linked_features_file = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x100 edge\linked_mod.csv'
t = pd.read_csv(linked_features_file)

# restrict to single frame
#f1 = t.loc[t.frame ==1]

#use all time frames
f1 = t

# z cutoffs: neglect 1 particle diameter in each direction. Or modify for more depending on goal
# also restrict to nonzero displacement
buff_size = 12
f = f1.loc[(f1.z > 0 + buff_size) & (f1.z < 50 - buff_size) & (f1.dr_adj_full > 0) & 
           (f1.x > 0 + buff_size) & (f1.x < 128 - buff_size) &
           (f1.y > 0 + buff_size) & (f1.y < 128 - buff_size)]
#f = f1.loc[(f1.z > 0 + buff_size) & (f1.z < 50 - buff_size) & (f1.dr_adj_full > 0)]




mobility_cutoff = 0.06
max_real_dr = 0.6

immobile = f.loc[f.dr_adj_full < mobility_cutoff]
mobile = f.loc[(f.dr_adj_full > mobility_cutoff) & (f.dr_adj_full < max_real_dr)]



# plot scatter plot of displacements vs contacts
plt.plot(mobile.contacts_0pt1um.values, mobile.dr_adj_full.values, 'b.')
plt.xlabel('Contacts')
plt.ylabel('Displacement (um)')
plt.title('Displacement vs Contacts')
plt.show()

# histogram of contacts for mobile and immobiel particles
h_im, bin_edges = np.histogram(immobile.contacts_0pt1um.values, bins=np.arange(14), density = False)

pdf_h_im = np.array(h_im)/float(sum(h_im))

mean_contacts_im = np.mean(immobile.contacts_0pt1um.values)

print('mean contacts immobile: ' + str(mean_contacts_im))
print('number displacements immoblie: ' + str(len(immobile)))

# histogram of contacts for mobile and immobiel particles
h_m, bin_edges = np.histogram(mobile.contacts_0pt1um.values, bins=np.arange(14), density = False)

pdf_h_m = np.array(h_m)/float(sum(h_m))

mean_contacts_m = np.mean(mobile.contacts_0pt1um.values)
print('mean contacts mobile: ' + str(mean_contacts_m))
print('number displacements mobile: ' + str(len(mobile)))

percent_mobile = len(mobile)/float(len(immobile) + len(mobile))

print('percent mobile: ' +  str(percent_mobile))

# plot the histogram of probablilies
plt.plot(bin_edges[1:], pdf_h_im, 'b:o', label = 'Immobile')
plt.plot(bin_edges[1:], pdf_h_m, 'r:o', label = 'Mobile')
plt.xlim(0, 10)
plt.ylim(0, .4)
plt.xlabel('Contact number $\mathit{z}$', fontsize = 12)
plt.ylabel('$P(z)$', fontsize = 12)
plt.title('Contact number distribution', fontsize = 12)
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()   

## plot the histogram of counts
##plt.plot(bin_edges[1:], h_im, 'b:o')
#plt.plot(bin_edges[1:], h_m, 'r:o')
#plt.xlim(0, 10)
##plt.ylim(0, max(h_im))
#plt.xlabel('Displacement (um)')
#plt.ylabel('Count')
#plt.title('Static Displacement distribution')
#plt.show()   


## calculate and plot mean displacement for each contact number
#
## Note: probably not meaningful for bimodal-ish distribution dominated by
## a few high points.
#for num_contacts in range(max_contacts):
#    dn = cd_real.loc[cd_real['contacts'] == num_contacts]
#    mean_displacement[num_contacts] = np.mean(dn['dr_adj_x'])
#
#
#plt.plot(range(max_contacts), mean_displacement, 'ro')
#plt.xlabel('Contacts')
#plt.ylabel('Mean Displacement (um)')
#plt.title('Displacement vs Contacts')
##plt.axis([0, 10.5, 0.1, 0.2 ])
#plt.show()
#
## straight displacements part
#drs_full = cd.dr_adj_x.values
#    
## nan appears for every particle in one frame but not the other
## remove all nan entries so I can do math
#drs = drs_full[np.isfinite(drs_full)]
#
## calculate mean displacement of particles frames
#dr_mean = np.mean(drs)
#dr_var = np.var(drs)
#dr_std= np.sqrt(dr_var)
#dr_median = np.median(drs)
#
#print('Mean dr: ' + str(dr_mean))
#
#
## make histogram of displacemets
#h, bin_edges = np.histogram(drs, bins=np.arange(31)/20., density = False)
#
## plot the histogram. can comment out for running funciton.
#plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
#plt.xlim(0, max(bin_edges))
#plt.xlabel('Displacement (um)')
#plt.ylabel('Count')
#plt.title('Static Displacement distribution')
#plt.show()   
#
### plot the histogram. can comment out for running funciton.
##plt.bar(bin_edges[1:11], h[:10], width = bin_edges[1]-bin_edges[0])
##plt.xlim(0, bin_edges[21])
##plt.xlabel('Displacement (um)')
##plt.ylabel('Count')
##plt.title('Static Displacement distribution')
##plt.show()   
#
#
### make histogram of contacts
##h, bin_edges = np.histogram(cd.contacts.values, bins=np.arange(14), density = False)
##
### plot the histogram. can comment out for running funciton.
##plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
##plt.xlim(0, max(bin_edges))
##plt.xlabel('Displacement (um)')
##plt.ylabel('Count')
##plt.title('Static Displacement distribution')
##plt.show()   
