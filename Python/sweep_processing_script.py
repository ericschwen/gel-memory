"""
Script to calculate run tp locate and link, and custom tp
displacements_pd, adj_displacements functions on a set of files.

Created on Wed Jun 28 02:09:42 2017

@author: Eric
"""
import tp_custom_functions_v12 as tpc
import os

##############################################
### ampsweep version
#folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\ampsweep'
##l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V']
#l1 = os.listdir(folder)
## restrict to specific part
##l1 = [l1[0]]
##l2 = ['u_combined_o5', 's_combined_o5']
#l2 = ['u_combined_o5']

#########################################################
## pause version
##        
#folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V'
#l1 = ['p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
#l2 = ['u_combined_o5']
#l2 = ['u_combined_o5']
####################################################################



tifs_file = r'\*.tif'
linked_file = r'\linked.csv'
mod_file = r'\linked_mod.csv'

bslash = '\\'
#uscore = '_'
#extension = r'\*.tif'

#for i in range(len(l1)):
#    for j in range(len(l2)):
#        base = folder +  bslash + l1[i] + bslash + l2[j]
#        tpc.tracking_3d_stacks(base + tifs_file)
#        
#        #tpc.link_custom(base + tifs_file)
#        tpc.displacements_pd(base + linked_file)
#        tpc.adj_displacements(base + mod_file)                                              
#        print(base + ' located')



## contact number addition        
#for i in range(len(l1)):
#    for j in range(len(l2)):
#        base = folder +  bslash + l1[i] + bslash + l2[j]
#        tpc.contact_number_linked(base + mod_file, 2.1)
##        tpc.fabric_tensor_linked(base + mod_file, 2.5)
        
        
# PERI contacts        
folder = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 '
l1 = ['p0', 'p50', 'p100', 'p150', 'p200', 'p500']
# contact number addition        
for i in range(len(l1)):
    base = folder + l1[i]
    tpc.contact_number_linked(base + mod_file, 2.1)
    print(base+mod_file)
