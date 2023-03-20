# -*- coding: utf-8 -*-
"""
Script to compare contact number vs displacement

Created on Wed Jul 26 17:50:33 2017
@author: Eric

Modification History:
    
Notes:
    Maybe try limiting to specific frames as well. Especially if this is going
    to be skewed by the data where the first frame is shifted.
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# file path for linked particle positions from trackpy
linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.0\u_combined_o5\linked15_mod.csv')
t = pd.read_csv(linked_features_file)

# restrict to single frame
f1 = t.loc[t.frame == 1]

#use all time frames
#f1 = t

# z cutoffs: neglect 1 particle diameter in each direction
f = f1.loc[(f1.z > 22) & (f1.z < 26)]
#f2 = f1.loc[f1.z > 15]
#f = f2.loc[f2.z < 30]



# reduce to just contacts and displacements
cd = f[['contacts', 'particle', 'frame', 'dr', 'dr_adj_x', 'dr_adj_full']]
# limit to numbers greater than noise cutoff (or 0 for no cutoff)
cutoff = 0
cd_real = cd.loc[cd['dr_adj_x'] > cutoff]


max_contacts = int(max(cd_real['contacts'])+1)
mean_displacement = np.zeros(max_contacts)

# plot scatter plot of displacements vs contacts
plt.plot(cd_real.contacts.values, cd_real.dr.values, 'b.')
plt.xlabel('Contacts')
plt.ylabel('Displacement (um)')
plt.title('Displacement vs Contacts')
plt.show()


# plot histogram of displacements for individual distances


# calculate and plot mean displacement for each contact number

# Note: probably not meaningful for bimodal-ish distribution dominated by
# a few high points.
for num_contacts in range(max_contacts):
    dn = cd_real.loc[cd_real['contacts'] == num_contacts]
    mean_displacement[num_contacts] = np.mean(dn['dr_adj_x'])


plt.plot(range(max_contacts), mean_displacement, 'ro')
plt.xlabel('Contacts')
plt.ylabel('Mean Displacement (um)')
plt.title('Displacement vs Contacts')
#plt.axis([0, 10.5, 0.1, 0.2 ])
plt.show()

# straight displacements part
drs_full = cd.dr_adj_x.values
    
# nan appears for every particle in one frame but not the other
# remove all nan entries so I can do math
drs = drs_full[np.isfinite(drs_full)]

# calculate mean displacement of particles frames
dr_mean = np.mean(drs)
dr_var = np.var(drs)
dr_std= np.sqrt(dr_var)
dr_median = np.median(drs)

print('Mean dr: ' + str(dr_mean))


# make histogram of displacemets
h, bin_edges = np.histogram(drs, bins=np.arange(31)/20., density = False)

# plot the histogram. can comment out for running funciton.
plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
plt.xlim(0, max(bin_edges))
plt.xlabel('Displacement (um)')
plt.ylabel('Count')
plt.title('Static Displacement distribution')
plt.show()   

## plot the histogram. can comment out for running funciton.
#plt.bar(bin_edges[1:11], h[:10], width = bin_edges[1]-bin_edges[0])
#plt.xlim(0, bin_edges[21])
#plt.xlabel('Displacement (um)')
#plt.ylabel('Count')
#plt.title('Static Displacement distribution')
#plt.show()   


## make histogram of contacts
#h, bin_edges = np.histogram(cd.contacts.values, bins=np.arange(14), density = False)
#
## plot the histogram. can comment out for running funciton.
#plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
#plt.xlim(0, max(bin_edges))
#plt.xlabel('Displacement (um)')
#plt.ylabel('Count')
#plt.title('Static Displacement distribution')
#plt.show()   
