# -*- coding: utf-8 -*-
"""
Calculate deviatoric fabric tensor over time

Created on Fri Jan 19 14:29:00 2018

@author: Eric
"""

import deviatoric_fabric_tensor_v2 as dev
import os
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


##############################################
## ampsweep version
#folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0\ampsweep'
##l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V']
#l1 = os.listdir(folder)
## restrict to specific part
##l1 = [l1[0]]
##l2 = ['u_combined_o5', 's_combined_o5']
#l2 = ['u_combined_o5']

#########################################################
# pause version
#        
folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V'
#folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\0.6'
l1 = ['p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
#l2 = ['s_combined_o5']
l2 = ['u_combined_o5']
####################################################################



tifs_file = r'\*.tif'
linked_file = r'\linked.csv'
mod_file = r'\linked_mod.csv'

bslash = '\\'
#uscore = '_'
#extension = r'\*.tif'

# define fabric tensor
xi = np.zeros((len(l1), 3))

for i in range(len(l1)):
    filename = folder +  bslash + l1[i] + bslash + l2[0] + mod_file
    xi[i] = dev.deviatoric_fabric_tensor(filename)
    

plt.plot(range(len(xi[:,0])), xi[:,0], 'b:o', label = 'xx')
plt.plot(range(len(xi[:,1])), xi[:,1], 'r:o', label = 'yy')
plt.plot(range(len(xi[:,2])), xi[:,2], 'g:o', label = 'zz')