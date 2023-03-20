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
linked_features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\ampsweep\1.8\u_combined'
                        r'\linked_w_displacements_w_contacts_w_adj_disp.csv'
                        )
t = pd.read_csv(linked_features_file)

# restrict to single frame
f = t.loc[t.frame == 2]

##use all time frames
#f = t

# reduce to just contacts and displacements
cd = f[['contacts', 'dr', 'dr_adj_x']]
# limit to real numbers
cd_real = cd.loc[cd['dr'] > 0]


max_contacts = int(max(cd_real['contacts'])+1)
mean_displacement = np.zeros(max_contacts)

for num_contacts in range(max_contacts):
    dn = cd_real.loc[cd_real['contacts'] == num_contacts]
    mean_displacement[num_contacts] = np.mean(dn['dr'])


plt.plot(range(max_contacts), mean_displacement, 'ro')
plt.xlabel('Contacts')
plt.ylabel('Mean Displacement (um)')
plt.title('Contacts vs Displacement')
#plt.axis([0, 3.2, 0.1, 0.45 ])
plt.show()

plt.plot(cd.contacts.values, cd.dr.values, 'b.')
plt.xlabel('Contacts')
plt.ylabel('Mean Displacement (um)')
plt.title('Contacts vs Displacement')
plt.show()


# straight displacements part
drs_full = f.dr.values
    
# nan appears for every particle in one frame but not the other
# remove all nan entries so I can do math
drs = drs_full[np.isfinite(drs_full)]

# calculate mean displacement of particles between the two frames
dr_mean = np.mean(drs)
dr_var = np.var(drs)
dr_std= np.sqrt(dr_var)
dr_median = np.median(drs)


# make histogram of displacemets
h, bin_edges = np.histogram(drs, bins=np.arange(51)/50., density = False)

# plot the histogram. can comment out for running funciton.
plt.bar(bin_edges[1:], h, width = bin_edges[1]-bin_edges[0])
plt.xlim(min(bin_edges), max(bin_edges))
plt.xlabel('Displacement (um)')
plt.ylabel('Count')
plt.title('Static Displacement distribution')
plt.show()   