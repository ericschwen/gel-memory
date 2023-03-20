# -*- coding: utf-8 -*-
"""
surface_separation_bond_angles

Modified code from surface_separation_neighbors_v2. After finding surface
separation neighbors, also finds bond angles and constructs bond angle
distribution.

Base code for calculating surface separation between particles and using it to find
nearest neighbors.Takes positional data and radii found by PERI. Assumes that
data is already put into a dataframe using a file such as peri_build_df_v3.

Better version could just take neghbors already found by surface_separation_neighbors
and calculate the angle to each of them, but that code is more work to write. Can
steal that code from bond_angle_distribution_v10.

v1: Working ok I think. Currently doesn't have a buffer to neglect particles
near the edges, though that probably won't matter much for xy and wont work for
polar angles because I dont have a large range. 9-25-19.

Created on Wed Sep 25 11:56:36 2019

@author: Eric
"""

import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p500\linked_peri_mod.csv'

save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\bond_dist_50nm_nobuff.csv'

# Max range to be counted as in contact (in nm). Range is measured
# as the surface separation between the particles.
contact_range = 100
contact_range_um = contact_range/1000.

# filepath to tp trajectories
features_file = path
# sample path = r'C:\Eric\Xerox\Python\peri\1-6-18 data\test\linked_peri_mod.csv'

df = pd.read_csv(features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in df.columns:
    del df['Unnamed: 0']

############################
# add an extra index column for testing
# save a varialbe equal to the original dataframe index for each particle at each time
# (used to combine dataframes later)
df['i'] = range(len(df))

# Code to check for missing columns and add them if necessary  

# define distances in um instead of pixels (if not already done)
if not 'xum' in df.columns:
    df['xum'] = df['x'] * 0.127
    df['yum'] = df['y'] * 0.127
    df['zum'] = df['z'] * 0.12

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

# add particle column if not already there
if not 'particle' in df.columns:
    df['particle'] = np.arange(len(df))
    
# add a column for rad_um if not already there
# radius conversion uses xy pixel size (confirmed correct with Meera/Brian)
if not 'rad_um' in df.columns:
    df['rad_um'] = df['rad'] * 0.127
    
# Add columns to dataframe for nearest neighbors
a = np.empty([len(df), 1], dtype = object)
a[:] = 'none'
df.loc[:, 'neighbors'] = a
#    df.loc[:, 'next_nbs'] = a
df.loc[:, 'contacts'] = a

# Declare lists for angle distributions
# Possibly preallocate and trim if I want to go faster
azis = np.zeros(0)
polars = np.zeros(0)
xzs = np.zeros(0)
yzs = np.zeros(0)    
    
# Iterate through frames and find neighbors
for frame in range(int(num_frames)):
    
## Alternate version to only use frame 0
#for frame in range(0,1):
    
    if num_frames > 0:
        # create dataframe with just current frame
        f = df.loc[df['frame'] == frame]
    else:
        f = df
        
    # create a temporary index for this frame
    f.loc[:, 'temp_index'] = np.arange(len(f))
    f = f.set_index('temp_index')
    
    # declare np array for positions
#        positions = np.transpose(np.array([f['xum'],f['yum'], f['zum']]))
    pos_rad = np.transpose(np.array([f['xum'],f['yum'], f['zum'], f['rad_um']]))
       
    
    # find neighbors and nearest neighbors
    for i in range(len(pos_rad)):
        
        # calculate the relative position vector. (Calculate for every other
        # particle in one step with repmat)
        # np.tile takes one row of the center matrix and repeats it for each other
        # row to make it the size of data. Then subtract to have distances.
    
#            shift_vector = abs(positions - np.tile(positions[i,:], (len(positions),1)))
        
#        # absolute value version
#        shift_vector = abs(pos_rad[:,0:3] - np.tile(pos_rad[i,0:3], (len(pos_rad),1)))
        
        
        shift_vector = pos_rad[:,0:3] - np.tile(pos_rad[i,0:3], (len(pos_rad),1))
    
        # Counter variable for the number of particles in contact.
        contact_count = 0
        # list for nearest neighbors
        neighbors = []

        # select neighbors
        for j in range(len(shift_vector)):
            # center to center distance
            c2c_distance = np.linalg.norm(shift_vector[j,:])
            if c2c_distance != 0:
                # surface separation = c2c-r1-r2
                surf_sep = c2c_distance-pos_rad[i,3] - pos_rad[j,3]
                if (surf_sep < contact_range_um):
                    contact_count = contact_count + 1
                    # find name for particle and
                    # append the neighboring particle to the neighbors list
                    particle = int(f.at[j, 'particle'])
                    neighbors.append(particle)
                    
                    # ADD IF STATEMENT HERE to have buffer zone.
                    
                    # add to bond angle calculation for nearest neighbors
                    azis = np.append(azis, np.arctan2(shift_vector[j,1],shift_vector[j,0])*180/np.pi)
                    polars = np.append(polars, np.arccos(shift_vector[j,2]/c2c_distance)*180/np.pi)
                    xzs = np.append(xzs, np.arctan2(shift_vector[j,2],shift_vector[j,0])*180/np.pi)
                    yzs = np.append(yzs, np.arctan2(shift_vector[j,2],shift_vector[j,1])*180/np.pi)
                    
                    
        f.at[i, 'neighbors'] = neighbors
        f.at[i, 'contacts'] = contact_count
        
        if (i % 1000) == 0:
            print(str(i) + '/' + str(len(pos_rad)) + ' in frame ' + str(frame))
        
            
    # reindex combined array by original dataframe index (saved as i)
    f = f.set_index('i', drop = False)
    
    # add the contact number to the dataframe features object
#        contacts_column_name = 'contacts_' + str(contact_range).split('.')[0] + 'pt' + str(contact_range).split('.')[1] + 'um'
    contacts_column_name = 'contacts_' + str(contact_range) +'nm'
   
    # update master dataframe if more than one frame
    if num_frames > 0:
        df.loc[df['frame']== frame, contacts_column_name] = f['contacts']
        df.loc[df['frame']== frame, 'neighbors'] = f['neighbors']
        #####################################
#            df.loc[df['frame']== frame, 'next_nbs'] = f['next_nbs']
        

# Delete extra index column
del df['i'] 

# Delete the contacts column (not actually used to save anything. just temporary)
# I could get rid of that part of the code entirely, but it's extra work not worth
del df['contacts']

#    # save dataframe file with contacts
##    save_filepath = '\\'.join(path.split('\\')[:-1]) + r'\linked_peri_mod.csv'
#    save_filepath = features_file
#    df.to_csv(save_filepath, index = False)

# Contact distribution histograms
h_a, bin_edges_a = np.histogram(azis, bins=np.arange(-180, 181, 12), density = False)
pdf_h_a = np.array(h_a)/float(sum(h_a))

h_p, bin_edges_p = np.histogram(polars, bins=np.arange(0, 181, 6), density = False)
pdf_h_p = np.array(h_p)/float(sum(h_p))

h_xz, bin_edges_xz = np.histogram(xzs, bins=np.arange(-180, 181, 12), density = False)
pdf_h_xz = np.array(h_xz)/float(sum(h_xz))

h_yz, bin_edges_yz = np.histogram(yzs, bins=np.arange(-180, 181, 12), density = False)
pdf_h_yz = np.array(h_yz)/float(sum(h_yz))

# bin centers (for plotting centers of histogram bins instead of edges)
bin_diff_p = bin_edges_p[2]-bin_edges_p[1]
bin_centers_p = bin_edges_p[:-1] + bin_diff_p/2
bin_diff_a = bin_edges_a[2]-bin_edges_a[1]
bin_centers_a = bin_edges_a[:-1] + bin_diff_a/2
bin_diff_xz = bin_edges_xz[2]-bin_edges_xz[1]
bin_centers_xz = bin_edges_xz[:-1] + bin_diff_xz/2
bin_diff_yz = bin_edges_yz[2]-bin_edges_yz[1]
bin_centers_yz = bin_edges_yz[:-1] + bin_diff_yz/2

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
plt.plot(bin_edges_xz[1:], pdf_h_xz, 'r:o', label = 'xz')
#
plt.plot(bin_edges_yz[1:], pdf_h_yz, 'g:o', label = 'yz')
#
#plt.plot(bin_edges_p[1:], pdf_h_p, 'r:o', label = 'Polar')


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
hist_df = pd.DataFrame({'l_edges_a':bin_edges_a[:-1], 'counts_a':h_a, 'pdf_a': pdf_h_a,
                   'l_edges_p':bin_edges_p[:-1], 'counts_p':h_p, 'norm_pdf_p': norm_pdf_h_p,
                   'l_edges_xz':bin_edges_xz[:-1], 'counts_xz':h_xz, 'pdf_xz': pdf_h_xz,
                   'l_edges_yz':bin_edges_yz[:-1], 'counts_yz':h_yz, 'pdf_yz': pdf_h_yz,
                   'centers_a':bin_centers_a, 'centers_p':bin_centers_p,
                   'centers_xz':bin_centers_xz, 'centers_yz':bin_centers_yz})

hist_df.to_csv(save_filepath, index = False)

