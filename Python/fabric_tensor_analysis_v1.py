# -*- coding: utf-8 -*-
"""
Investigate average fabric tensor, etc.

Created on Wed Jul 26 17:50:33 2017
@author: Eric

Modification History:
    
Notes:
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# file path for linked particle positions from trackpy
#features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\zstack_pre_train_bpass3D_o5\200\positions15_mod.csv')
#features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\zstack_post_sweep_bpass3D_o5\200\positions15_mod.csv')
features_file = (r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6\p400\u_combined_o5\linked15_mod.csv')
f1 = pd.read_csv(features_file)

# z cutoffs: neglect between 1 and 1.5 particle diameter in each direction
# modify based on number of z frames
# fabric tensor: require that fabric tensor > 0 (only count particles with nonzero contact number)

# for 100 frames and 1.5 diameters
#f = f1.loc[(f1.z > 24) & (f1.zum < 76)]

# for 50 frames and 1.2 diameter(s)
#f = f1.loc[(f1.z > 21) & (f1.z < 28)]

## for 200 frames and 2 diameters(s)
f = f1.loc[(f1.z > 32) & (f1.z < 168) & (f1.Z_xx > 0)]


Z_xx = f.Z_xx.values
Z_yy = f.Z_yy.values
Z_zz = f.Z_zz.values

Z_xx_mean = np.mean(Z_xx)
print('xx', Z_xx_mean)
Z_yy_mean = np.mean(Z_yy)
print('yy', Z_yy_mean)
Z_zz_mean = np.mean(Z_zz)
print('zz', Z_zz_mean)



##contacts = f.contacts.values
#contacts = f.contacts_2pt5um.values

h, bin_edges = np.histogram(Z_xx, bins=np.arange(40)/10., density = False)

pdf_h = np.array(h)/float(sum(h))

# plot the histogram of probablilies
plt.plot(bin_edges[1:], pdf_h, 'b:o', label = 'Current')
#plt.plot(bin_edges[1:], pdf_pre06, 'b:o', label = 'Before training')
#plt.plot(bin_edges[1:], pdf_post, 'r:o', label = 'After training')
#plt.plot(bin_edges[1:], pdf_prewait, 'b:o', label = 'Before waiting')
#plt.plot(bin_edges[1:], pdf_postsweep, 'r:o', label = 'After sweep')

plt.xlim(0, 4)
plt.ylim(0, .1)
#plt.xlabel('Contact number $\mathit{z}$', fontsize = 18)
#plt.ylabel('Probability', fontsize = 18)
#plt.title('Contact number distribution', fontsize = 18)
plt.yticks(fontsize = 18)
plt.xticks(fontsize = 18)
plt.legend(loc = 'upper left', fontsize = 18)
plt.show()   

