# -*- coding: utf-8 -*-
"""
contact_number

Calculates number of particles in 'contact' with each particle in a collection
of particles located by trackpy. Modified from my original Matlab code.

Inputs:
    features created by tp.locate
    contact range established by first min in g(r)
Outputs:
    contact numbers added to array

Created on Tue Jul 25 00:59:10 2017

@author: Eric

Modification History:
    
"""
import numpy as np
import pandas as pd
#import matplotlib as mpl
#import matplotlib.pyplot as plt
#mpl.rc('figure',  figsize=(10, 6))

# Max range to be counted as in contact (in microns)
contact_range = 2.8

# filepath to tp features
features_file = (r'C:\Eric\Xerox Data\30um gap runs\0.5Hz combined gel runs 1-17-17'
          r'\1.0V (2nd)\zstack_post_train_static_bpass_3D_static_160\post_train_features.csv'
          )

f = pd.read_csv(features_file)

# define distances in um instead of pixels
f['xum'] = f['x'] * 0.125
f['yum'] = f['y'] * 0.125
f['zum'] = f['z'] * 0.12

positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))

xmin = min(f['xum'])
ymin = min(f['yum'])
zmin = min(f['zum'])

xmax = max(f['xum'])
ymax = max(f['yum'])
zmax = max(f['zum'])

# define arrays for conacts
contacts = np.zeros(len(f)) # Declare an array 
max_contacts = 14


for i in range(len(positions)):
    
    # calculate the relative position vector. (Calculate for every other
    # particle in one step with repmat)
    # np.tile takes one row of the center matrix and repeats it for each other
    # row to make it the size of data. Then subtract to have distances.

    shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
    
#     # Limit to selected max range rc.
#     shifted_vector=shifted_vector( shifted_vector(:,1)<rc & shifted_vector(:,2)<rc & shifted_vector(:,3)<rc,:)
    distances = np.zeros(len(shift_vector))

    # Counter variable for the number of particles in contact.
    contact_count = 0
    
    for j in range(len(shift_vector)):
        distances[j] = np.linalg.norm(shift_vector[j,:])
        if (distances[j] < contact_range and distances[j] != 0):
            contact_count = contact_count + 1
    
    contacts[i] = contact_count

    if (i % 1000) == 0:
        print(str(i) + '/' + str(len(positions)) + '\n')

# add the contact number to the dataframe features object
f['contacts'] = contacts

save_filepath = features_file[:-4] + '_w_contacts.csv'
f.to_csv(save_filepath, index = False)

## declare the contact number  distribution array
#contact_dist_total = np.zeros((max_contacts+1,2)) 
#contact_dist_total[:,0] = range(max_contacts+1)