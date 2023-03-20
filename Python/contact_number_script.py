# -*- coding: utf-8 -*-
"""
Script to calculate run contact number function on a set of files.

Created on Wed Jun 28 02:09:42 2017

@author: Eric
"""
import tp_custom_functions_v3 as tpc
import os
# ampsweep version
folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.4\ampsweep'
#l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V']
l1 = os.listdir(folder)
#l2 = ['s_combined']
l2 = ['u_combined', 's_combined']
filename = 'linked_w_displacements.csv'

bslash = '\\'
uscore = '_'
#extension = r'\*.tif'

for i in range(len(l1)):
    for j in range(len(l2)):
        path = folder + bslash + l1[i] + bslash + l2[j] + bslash + filename
        tpc.contact_number_linked(path, 2.8)                                               
        print(path)

#==============================================================================
# # pause version
#         
# folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\2.0'
# #l1 = os.listdir(folder)
# l1 = ['p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
# #l2 = ['s_combined']
# l2 = ['u_combined', 's_combined']
# filename = 'linked_w_displacements.csv'
# 
# bslash = '\\'
# uscore = '_'
# #extension = r'\*.tif'
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j] + bslash + filename
#         tpc.contact_number_linked(path, 2.8)                                               
#         print(path)
#==============================================================================
