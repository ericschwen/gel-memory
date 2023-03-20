# -*- coding: utf-8 -*-
"""
bond_angle_distribution_v1

Takes path to linked (or just located) file from trackpy (or peri) where
neighbors have aready been found through tp_custom_functions_v12 nearest_neighbors
function.

Calculates the azimuthal and polar angles for each nearest neighbor pair and adds
them to an array.

Mod History: 
    v1 4-12-18
    v2: Change so I can look at bonds along different axes (addition of xz an yz angles)
        Also add optional restriction to restrict z-range of particles surveyed
        (to make sure edge particles are neglected). SOMETHING OFF WITH POLAR VS XZ PLANES!
        4-19-18
    v3: Add shift_vectors array for testing
    v4: save zpx to shift_vector and move all angle calculations to the end
    v5: move restriction by zpx to earlier in code (to creation of shift_vectors array)
    v6: add xz plane "azimuthal" angle and "polar" angle from y (vorticity) axis
    v7: preallocate shif_vectors to reduce computing time
Created on Thu Apr 12 14:28:09 2018

@author: Eric
"""

import pims, ast
#import trackpy as tp
import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


# Examples for input variables
#path = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V\p300\s_combined_o5\linked_mod_test.csv'
path = r'C:\\Eric\\Xerox Data\\30um gap runs\\1-6-18 0.3333Hz\\1.0V\\p500\\u_combined_o5\\linked_mod.csv'
#c_range = 2.1;


# filepath to tp trajectories
features_file = path

df = pd.read_csv(features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in df.columns:
    del df['Unnamed: 0']
    
# find number of frames or 
if 'frame' in df.columns:
    # number of timesteps (aka frames)
    if max(df['frame']) == 0:
        num_frames = 1
    else:
        num_frames = (max(df['frame']) - min(df['frame'])) + 1    
else:
    # add a frame column identical to zero to make rest of code work
    df['frame'] = np.zeros(len(df))
    num_frames = 1
    
    
# restrictions on z pixel for counting angles
zmin = 50
zmax = 100
# make dumb variable to check if restricted variable has been created yet
restricted_vector_created = False

# preallocate arrays for shift_vetors (count number of neighbors)
shift_vectors = np.zeros((sum(df.contacts.values),4))
shfit_vectors_restricted = np.zeros((sum(df.contacts.values),4))

## Optional section to preallocate azis and polars arrays
## Count total number of bonds (doubled because of repeats)
#count = 0
#for k in range(len(df)):
#    # get list of nearest neighbors
#    nn = ast.literal_eval(df.at[k, 'neighbors'])
#    count = count + len(nn)

for frame in range(int(num_frames)):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
        
    # create a temporary index for this frame
    f.loc[:, 'temp_index'] = np.arange(len(f))
    f = f.set_index('temp_index')
    
    # find total number of 
    
    # iterate through all particles (and calculate bond angles)
    for j in range(len(f)):
        # get list of nearest neighbors
        
        
#        # nearest neighbors verstion
        nn = ast.literal_eval(f.at[j, 'neighbors'])
        
        # L'th layer of neighbors
#        nn = ast.literal_eval(f.at[j, 'nn2'])
#        nn = f.at[j, 'nn2']
        
        
        # get position
        # there is a prettier way to do this, but this works for now
        pos1 = np.array([f.at[j, 'xum'], f.at[j,'yum'], f.at[j,'zum']])
        
        for entry in nn:
            # get the position vector for the neighboring particle
            # there is a prettier way to do this, but this works for now
            pos2 = np.array([f.loc[f['particle'] == entry]['xum'].values[0],
                             f.loc[f['particle'] == entry]['yum'].values[0],
                             f.loc[f['particle'] == entry]['zum'].values[0]])
            # calculate vector between the 2 neighboring particles
            shift_vector = pos2-pos1
            
            # record z pixel for excluding ranges later
            zpx = f.at[j, 'z']
            shift_vector_wz = np.append(shift_vector, zpx)
            
            # create an array of all all shift vectors
            if (j == 0) & (frame ==0):
                shift_vectors = np.array(shift_vector_wz, ndmin = 2)
            else:
                shift_vectors = np.append(shift_vectors, [shift_vector_wz], axis = 0)
                    
            # create an array of shift vectors with restrictions on zpx
            if (zpx > zmin) & (zpx < zmax):
                if not restricted_vector_created:
                    shift_vectors_restricted = np.array(shift_vector_wz, ndmin = 2)
                    restricted_vector_created = True
                else:
                    shift_vectors_restricted =  np.append(shift_vectors_restricted, [shift_vector_wz], axis = 0)

# calculate the polar angle and projection angles (in degrees)

##################### NO RESTRICTIONS ON Z RANGE #####################################
## Declare array for azi and polar angles
#azis = np.zeros(len(shift_vectors))
#polars = np.zeros(len(shift_vectors))
#xzs = np.zeros(len(shift_vectors))
#yzs = np.zeros(len(shift_vectors))
### NEED TO BE CAREFUL HERE IF IGNORING SOME LATER
#
## iterate through shift_vectors and calculate angles
#for i in range(len(shift_vectors)):
#    
#
#    # Testing version (no restrictions on z)
#    if True:
##        shift_distance = np.linalg.norm(shift_vector)
#        shift_distance = np.sqrt(shift_vectors[i,0]**2 + shift_vectors[i,1]**2 + shift_vectors[i,2]**2)
#        
#        # calculate the azimuthal angle (in degrees)
#        azis[i] = np.arctan(shift_vectors[i,1]/shift_vectors[i,0])*180/np.pi
#        polars[i] = np.arccos(shift_vectors[i,2]/shift_distance)*180/np.pi
#        xzs[i] = np.arctan(shift_vectors[i,2]/shift_vectors[i,0])*180/np.pi
#        yzs[i] = np.arctan(shift_vectors[i,2]/shift_vectors[i,1])*180/np.pi
                    
                    
# Trim zeros from end of shift_vectors arrays
#np.trim_zeros rewritten to work for 2D
# iterate backwards through first column of shift_vectors      
last = len(shift_vectors)
for k in shift_vectors[:,1][::-1]:
    if k != 0.:
        break
    else:
        last = last - 1
shift_vectors = shift_vectors[:last, :]        
        
last = len(shift_vectors_restricted)
for k in shift_vectors_restricted[:,1][::-1]:
    if k != 0.:
        break
    else:
        last = last - 1
shift_vectors_restricted = shift_vectors_restricted[:last, :]        
        

################ RESTRICTING Z VERSION #####################################
#Declare array for azi and polar angles
azis = np.zeros(len(shift_vectors_restricted))
polars = np.zeros(len(shift_vectors_restricted))
xzs = np.zeros(len(shift_vectors_restricted))
yzs = np.zeros(len(shift_vectors_restricted))

ypolars = np.zeros(len(shift_vectors_restricted))

# testing "x polar angle"
xpolars = np.zeros(len(shift_vectors_restricted))

# iterate through shift_vectors and calculate angles
for i in range(len(shift_vectors_restricted)):
    
    shift_distance = np.sqrt(shift_vectors_restricted[i,0]**2 + shift_vectors_restricted[i,1]**2 + shift_vectors_restricted[i,2]**2)
    # play with alternate method to calculate distance
    shift_distance2= np.linalg.norm(shift_vectors_restricted[i, 0:3])
    
    # calculate the azimuthal angle (in degrees)
    azis[i] = np.arctan(shift_vectors_restricted[i,1]/shift_vectors_restricted[i,0])*180/np.pi
    polars[i] = np.arccos(shift_vectors_restricted[i,2]/shift_distance)*180/np.pi
    
    xzs[i] = np.arctan(shift_vectors_restricted[i,2]/shift_vectors_restricted[i,0])*180/np.pi
    yzs[i] = np.arctan(shift_vectors_restricted[i,2]/shift_vectors_restricted[i,1])*180/np.pi
    
    ypolars[i] = np.arccos(shift_vectors_restricted[i,1]/shift_distance)*180/np.pi
    xpolars[i] = np.arccos(shift_vectors_restricted[i,0]/shift_distance)*180/np.pi


# histogram of bond angles
h_a, bin_edges_a = np.histogram(azis, bins=30, density = False)
pdf_h_a = np.array(h_a)/float(sum(h_a))

h_p, bin_edges_p = np.histogram(polars, bins=30, density = False)
pdf_h_p = np.array(h_p)/float(sum(h_p))

h_xz, bin_edges_xz = np.histogram(xzs, bins=30, density = False)
pdf_h_xz = np.array(h_xz)/float(sum(h_xz))

h_yz, bin_edges_yz = np.histogram(yzs, bins=30, density = False)
pdf_h_yz = np.array(h_yz)/float(sum(h_yz))

h_yp, bin_edges_yp = np.histogram(ypolars, bins=30, density = False)
pdf_h_yp = np.array(h_yp)/float(sum(h_yp))

h_xp, bin_edges_xp = np.histogram(xpolars, bins=30, density = False)
pdf_h_xp = np.array(h_xp)/float(sum(h_xp))

# plot the histogram of probablilies
plt.plot(bin_edges_a[1:], pdf_h_a, 'b:o', label = 'xy')

plt.plot(bin_edges_xz[1:], pdf_h_xz, 'r:o', label = 'xz')

plt.plot(bin_edges_yz[1:], pdf_h_yz, 'g:o', label = 'yz')

plt.plot(bin_edges_p[1:], pdf_h_p, 'r:o', label = 'Polar')

plt.plot(bin_edges_yp[1:], pdf_h_yp, 'k:o', label = 'yPolar')

plt.plot(bin_edges_xp[1:], pdf_h_xp, 'b:o', label = 'xPolar')

#plt.grid(True)
#plt.xlim(0, 10)
plt.ylim(0, .1)
plt.xlabel('Bond Angle', fontsize = 12)
plt.ylabel('Probability', fontsize = 12)
#plt.ylabel('$P(\phi)$', fontsize = 12)
#plt.title('Bond Angle', fontsize = 12)
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()   


# try polar plot
plt.polar(bin_edges_a[1:]*np.pi/180., pdf_h_a, 'b')
plt.polar(bin_edges_a[1:]*np.pi/180., pdf_h_xz, 'r')
plt.polar(bin_edges_a[1:]*np.pi/180., pdf_h_yz, 'g')
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()
    
    
## TESTING
#    
#polars2 = np.zeros(len(shift_vectors))
#
#for i in range(len(shift_vectors)):
#    polars2[i] =np.arctan(np.sqrt(shift_vectors[i,0]**2 + shift_vectors[i,1]**2)/shift_vectors[i, 2])
#    
#    np.arccos(shift_vectors[i, 2] / np.sqrt(shift_vectors[i,0]**2 + shift_vectors[i,1]**2 + shift_vectors[i,2]**2))
