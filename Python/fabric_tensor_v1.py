# -*- coding: utf-8 -*-
"""
fabric_tensor_linked

calculates the fabric tensor for every particle in a collection of LINKED
particles located by trackpy. Saves the updated dataframe object to file.

Inputs:
    path: file path to linked features file
    c_range: contact range for determining which particles are in contact and
    should be included in the fabric tensor calculation


Created on Mon Oct 23 10:56:10 2017

@author: Eric
"""

import pims
import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# function inputs
c_range = 2.5
path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\testing 0.6 p0\linked15_mod.csv'


# Max range to be counted as in contact (in microns)
contact_range = c_range

# filepath to tp trajectories
linked_features_file = path

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']

############################
# add an extra index column for testing

# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.127
    linked['yum'] = linked['y'] * 0.127
    linked['zum'] = linked['z'] * 0.12

# number of timesteps (aka frames)
if max(linked['frame']) == 0:
    num_frames = 1
else:
    num_frames = (max(linked['frame']) - min(linked['frame'])) + 1

for frame in range(num_frames):
    
    # create dataframe with just current frame
    f = linked.loc[linked['frame'] == frame]
    
    # declare np array for positions
    positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))
       
    # define arrays for conacts
    contacts = np.zeros(len(f)) # Declare an array 
    
    # define a structure to store fabric tensors
    fabs = np.zeros((len(f),9))

#    # define a trace structure for the trace of the fabric tensor
#    trace = np.zeros(len(f))

    for i in range(len(positions)):
        
        # calculate the relative position vector. (Calculate for every other
        # particle in one step with repmat)
        # np.tile takes one row of the center matrix and repeats it for each other
        # row to make it the size of data. Then subtract to have distances.
    
        shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
    
        # Counter variable for the number of particles in contact.
        contact_count = 0
        # fabric tensor
        fabric = np.zeros((3,3))
        
        for j in range(len(shift_vector)):
            distance = np.linalg.norm(shift_vector[j,:])
            if (distance < contact_range and distance != 0):
                contact_count = contact_count + 1
                # normalize distance vector to make it a unit vector
                uv = np.array(shift_vector[j,:])/distance
                fabric = fabric + np.outer(uv,uv)
        
        # record contact number in array
        contacts[i] = contact_count
        
        # record fabric tensor in arrray (could probably make this more efficient)
        element = 0
        for r in fabric:
            for c in r:
                fabs[i, element] = c
                element = element + 1
                
#         #trace of fabric should equal contact count
#        trace[i] = fabs[i, 0] + fabs[i, 4] + fabs[i, 8]
#        print(trace[i] -contacts[i])
                
        if (i % 1000) == 0:
            print(str(i) + '/' + str(len(positions)) + ' in frame ' + str(frame) + '\n')
    
    # add the contact number to the dataframe features object
    column_name = 'contacts_' + str(contact_range)[0] + 'pt' + str(contact_range)[-1] + 'um'
    linked.loc[linked['frame']== frame, column_name] = contacts
        
    # add the fabric tensor to the dataframe
    entries = ['xx','xy','xz','yx','yy','yz','zx','zy','zz']
    for k in range(len(entries)):
        linked.loc[linked['frame'] == frame , 'Z_' + entries[k]] = fabs[:, k]

# save file with contacts
save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked15_mod.csv'
#    save_filepath = linked_features_file[:-4] + '_w_contacts.csv'
linked.to_csv(save_filepath, index = False)
