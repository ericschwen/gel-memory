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
    v8: play with switching y direction to make sure right handed? Also use tan2 9-27-18
    v9: save histograms of bond angles to file 8-20-19
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
#path = r'C:\\Eric\\Xerox Data\\30um gap runs\\1-6-18 0.3333Hz\\1.0V\\p0\\u_combined_o5\\linked_mod.csv'
#path = r'C:\\Eric\\Xerox Data\\30um gap runs\\1-6-18 0.3333Hz\\1.0V\\p300\\u_combined_o5\\linked_mod.csv'
path = r'C:\\Eric\\Xerox Data\\30um gap runs\\1-6-18 0.3333Hz\\1.0V\\p500\\u_combined_o5\\linked_mod.csv'
#c_range = 2.1;

save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\bond_angles_2p1.csv'

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
zmin = 40
zmax = 110
#zmin = 60
#zmax = 90
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
        
        
#        # nearest neighbors vesion
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
            
            # create an array of all all shift vectors (or add to it if already made)
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
                    
                    
# Trim zeros from end of shift_vectors arrays (orignially allocate more space than necessary)
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

###### Reverse sign of y (to effectively switch to right handed axis)
for i in range(len(shift_vectors_restricted)):
    shift_vectors_restricted[i,1] = - shift_vectors_restricted[i,1]


################ RESTRICTING Z VERSION #####################################
#Declare array for azi and polar angles
azis = np.zeros(len(shift_vectors_restricted))
polars = np.zeros(len(shift_vectors_restricted))

# Alternate angle definitions
#xzs = np.zeros(len(shift_vectors_restricted))
#yzs = np.zeros(len(shift_vectors_restricted))
#ypolars = np.zeros(len(shift_vectors_restricted))
## testing "x polar angle"
#xpolars = np.zeros(len(shift_vectors_restricted))

# Make array for shift distances
shift_distances = np.zeros(len(shift_vectors_restricted))

# iterate through shift_vectors and calculate angles
for i in range(len(shift_vectors_restricted)):
    
    shift_distance = np.sqrt(shift_vectors_restricted[i,0]**2 + shift_vectors_restricted[i,1]**2 + shift_vectors_restricted[i,2]**2)
    # play with alternate method to calculate distance
    shift_distance2= np.linalg.norm(shift_vectors_restricted[i, 0:3])
    
    shift_distances[i] = shift_distance
    
    # calculate the azimuthal angle (in degrees)
    azis[i] = np.arctan2(shift_vectors_restricted[i,1],shift_vectors_restricted[i,0])*180/np.pi
    polars[i] = np.arccos(shift_vectors_restricted[i,2]/shift_distance)*180/np.pi
    
#    xzs[i] = np.arctan2(shift_vectors_restricted[i,2],shift_vectors_restricted[i,0])*180/np.pi
#    yzs[i] = np.arctan2(shift_vectors_restricted[i,2],shift_vectors_restricted[i,1])*180/np.pi
#    ypolars[i] = np.arccos(shift_vectors_restricted[i,1]/shift_distance)*180/np.pi
#    xpolars[i] = np.arccos(shift_vectors_restricted[i,0]/shift_distance)*180/np.pi


# histogram of bond angles
#h_a, bin_edges_a = np.histogram(azis, bins=30, density = False)
#pdf_h_a = np.array(h_a)/float(sum(h_a))
#
#h_p, bin_edges_p = np.histogram(polars, bins=30, density = False)
#pdf_h_p = np.array(h_p)/float(sum(h_p))

h_a, bin_edges_a = np.histogram(azis, bins=np.arange(-180, 181, 12), density = False)
pdf_h_a = np.array(h_a)/float(sum(h_a))

h_p, bin_edges_p = np.histogram(polars, bins=np.arange(0, 181, 6), density = False)
pdf_h_p = np.array(h_p)/float(sum(h_p))

#h_xz, bin_edges_xz = np.histogram(xzs, bins=30, density = False)
#pdf_h_xz = np.array(h_xz)/float(sum(h_xz))
#
#h_yz, bin_edges_yz = np.histogram(yzs, bins=30, density = False)
#pdf_h_yz = np.array(h_yz)/float(sum(h_yz))
#
#h_yp, bin_edges_yp = np.histogram(ypolars, bins=30, density = False)
#pdf_h_yp = np.array(h_yp)/float(sum(h_yp))
#
#h_xp, bin_edges_xp = np.histogram(xpolars, bins=30, density = False)
#pdf_h_xp = np.array(h_xp)/float(sum(h_xp))


# bin centers (for plotting centers of histogram bins instead of edges)
bin_diff_p = bin_edges_p[2]-bin_edges_p[1]
bin_centers_p = bin_edges_p[:-1] + bin_diff_p/2
bin_diff_a = bin_edges_a[2]-bin_edges_a[1]
bin_centers_a = bin_edges_a[:-1] + bin_diff_a/2


# sine distribution for normalization
# NOTE: WHY NORMALIZE? It's 3D! Many particles can fit around the equator, but
# only one can fit directly above. Have to normalize the distribution to account
# for the geometry.
all_angles = np.arange(1,180,6)*np.pi/180
normalized_angles = np.zeros(len(all_angles))
for i in range(len(all_angles)):
    normalized_angles[i] = np.sin(all_angles[i])

pdf_normalized_angles = np.array(normalized_angles)/float(sum(normalized_angles))
#h_norm, bin_edges_norm = np.histogram(normalized_angles, bins=30, density = False)
#pdf_h_norm = np.array(h_norm)/float(sum(h_norm))
plt.plot(all_angles*180/np.pi, pdf_normalized_angles, 'g:o', label = 'Iso')
plt.plot(bin_centers_p, pdf_h_p, 'r:o', label = 'Polar')

plt.xlabel('Bond Angle', fontsize = 12)
plt.ylabel('Probability', fontsize = 12)
#plt.ylabel('$P(\phi)$', fontsize = 12)
#plt.title('Bond Angle', fontsize = 12)
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()   



# normalized polar distribution

norm_h_p = np.zeros(len(h_p))
for i in range(len(pdf_h_p)):
    norm_h_p[i] = h_p[i]/np.sin(bin_centers_p[i]*np.pi/180.)
norm_pdf_h_p = np.array(norm_h_p)/float(sum(norm_h_p))

#plt.plot(bin_edges_p[1:], pdf_h_p, 'r:o', label = 'Polar')
plt.plot(bin_centers_p, norm_pdf_h_p, 'r:o', label = 'Polar')
plt.plot(bin_centers_p, np.ones(len(bin_centers_p))*1./len(bin_centers_p), 'g:o', label = 'Iso')


plt.xlabel('Bond Angle', fontsize = 12)
plt.ylabel('Probability Normalized', fontsize = 12)
#plt.ylabel('$P(\phi)$', fontsize = 12)
#plt.title('Bond Angle', fontsize = 12)
plt.xlim(0,180)
plt.xticks(np.arange(0,210,30))
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()   



## plot the histogram of probablilies
plt.plot(bin_centers_a, pdf_h_a, 'b:o', label = 'azi')
#
#plt.plot(bin_edges_xz[1:], pdf_h_xz, 'r:o', label = 'xz')
#
#plt.plot(bin_edges_yz[1:], pdf_h_yz, 'g:o', label = 'yz')
#
#plt.plot(bin_edges_p[1:], pdf_h_p, 'r:o', label = 'Polar')
#
#plt.plot(bin_edges_yp[1:], pdf_h_yp, 'k:o', label = 'yPolar')
#
#plt.plot(bin_edges_xp[1:], pdf_h_xp, 'b:o', label = 'xPolar')


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
plt.polar(bin_centers_a*np.pi/180., pdf_h_a, 'b', label = 'Azimuthal')
plt.plot(bin_centers_a*np.pi/180, np.ones(len(bin_centers_a))*1./len(bin_centers_a), 'g', label = 'Iso')
#plt.polar(bin_edges_a[1:]*np.pi/180., pdf_h_xz, 'r')
#plt.polar(bin_edges_a[1:]*np.pi/180., pdf_h_yz, 'g')
plt.legend(loc = 'lower left', fontsize = 12)

plt.yticks(np.arange(0.01,0.04,0.01))
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.show()

# Build dictionary (dataframe) of all data to save
df = pd.DataFrame({'l_edges_a':bin_edges_a[:-1], 'counts_a':h_a, 'pdf_a': pdf_h_a,
                   'l_edges_p':bin_edges_p[:-1], 'counts_p':h_p, 'norm_pdf_p': norm_pdf_h_p,
                   'centers_a':bin_centers_a, 'centers_p':bin_centers_p})

#df.to_csv(save_filepath, index = False)





## TESTING
#    
#polars2 = np.zeros(len(shift_vectors))
#
#for i in range(len(shift_vectors)):
#    polars2[i] =np.arctan(np.sqrt(shift_vectors[i,0]**2 + shift_vectors[i,1]**2)/shift_vectors[i, 2])
#    
#    np.arccos(shift_vectors[i, 2] / np.sqrt(shift_vectors[i,0]**2 + shift_vectors[i,1]**2 + shift_vectors[i,2]**2))



## testing normalized standard is just plotting 1/number of bins (flat pdf)
#norm_sine = np.zeros(len(normalized_angles))
#for i in range(len(normalized_angles)):
#    norm_sine[i] = normalized_angles[i]/np.sin(all_angles[i])
#norm_pdf_sine = np.array(norm_sine)/float(sum(norm_sine))
#
#plt.plot(all_angles*180/np.pi, norm_pdf_sine, 'r:o', label = 'Normal')

