# -*- coding: utf-8 -*-
"""
Script to run trackpy particle locate and link on a bunch of zstacks.

Created on Wed Jun 28 02:09:42 2017

@author: Eric
"""
import tp_custom_functions_v5 as tpc
import os
import pims
import trackpy as tp

#==============================================================================
# # Single file processing version---only some frames
#==============================================================================

## tpc.tracking_3d_stacks modified to look only at specific frames
#path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting_bpass\*.tif'
## Sample path
## path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train\3.0V\u_combined\*.tif';
#
#frames = pims.ImageSequenceND(path, axes_identifiers = ['t', 'z'])
## frames.bundle_axes = ['z', 'y', 'x']    # Not actually necessary. Already bundles z,y,x
#frames.iter_axes = 't'
#
## run locate function
#f = tp.batch(frames[300:305], diameter=(15, 15, 15), invert = False, separation = (7,7,7), preprocess = False, minmass = 60000)
#
##Save the data to csv file
#f.to_csv(path[:-5] + 'positions.csv', index = False)
## define distances in um instead of pixels
#f['xum'] = f['x'] * 0.125
#f['yum'] = f['y'] * 0.125
#f['zum'] = f['z'] * 0.12
#
## link particles
#linked = tp.link_df(f, 1.0, pos_columns=['xum', 'yum', 'zum'])
#
##Save the data to csv file
#linked.to_csv(path[:-5] + 'linked.csv', index = False);

#tpc.tracking_3d_stacks(path0)

path1 = path0[:-5]
#path1 = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\ampsweep\1.2\s_combined'
path = path1 + r'\linked.csv'
tpc.displacements_pd(path)    
path = path1 + r'\linked_w_displacements.csv'
tpc.contact_number_linked(path, 2.8)
path = path1 + r'\linked_w_displacements_w_contacts.csv'
tpc.adj_displacements(path)
#==============================================================================
# 
# #==============================================================================
# # #original file set
# #==============================================================================
# folder = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\ampsweep_pre_train'
# l1 = ['0.2V', '0.4V', '0.6V','0.8V', '1.0V', '1.2V', '1.4V', '1.4V again', '1.8V', '2.0V','2.2V', '2.4V', '2.6V', '2.8V', '3.0V'];
# l2 = ['u_combined', 's_combined']
# 
# 
#==============================================================================
#==============================================================================
# #==============================================================================
# # # anosweep version
# #==============================================================================
# folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.4\ampsweep'
# #l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V']
# l1 = os.listdir(folder)
# l2 = ['u_combined', 's_combined']
# 
# bslash = '\\'
# uscore = '_'
# extension = r'\*.tif'
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j] + extension
#         tpc.tracking_3d_stacks(path)                                               
#         print(path)
#==============================================================================
        



#==============================================================================
# 
# #==============================================================================
# # # pause version
# #==============================================================================
# folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.4'
# #l1 = ['0.2V', '0.6V', '0.8V', '1.0V', '1.2V', '1.4V', '1.8V', '2.2V', '2.6V', '3.0V']
# l1 = ['p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
# l2 = ['u_combined', 's_combined']
# 
# bslash = '\\'
# uscore = '_'
# extension = r'\*.tif'
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + l1[i] + bslash + l2[j] + extension
#         tpc.tracking_3d_stacks(path)                                               
#         print(path)
#         
# 
# 
#==============================================================================
#==============================================================================
# #==============================================================================
# # # other data again. repeat for 1.4V runs too. (just change 1.0V in folder)
# #==============================================================================
# folder = r'C:\Eric\Xerox Data\30um gap runs\7-13-17 0.3333Hz\1.4V'
# l1 = ['p0', 'p20', 'p40', 'p60', 'p80', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']
# l2 = ['u_combined', 's_combined']
# bslash = '\\'
# 
# uscore = '_'
# extension = r'\*.tif'
# 
# for i in range(len(l1)):
#     for j in range(len(l2)):
#         path = folder + bslash + 'zstacks_' + l1[i] + bslash + l2[j] + extension
#         tpc.tracking_3d_stacks(path)                                               
#         print(path)
# 
#==============================================================================
