# -*- coding: utf-8 -*-
"""
peri_build_df

Script to take positions from subsequent peri states and build a dataframe
to use for trackpy linking.

Second section links the particles with trackpy. 

Created on Tue Nov 28 11:31:43 2017

Mod History:
    v2: add radii to dataframe
    v3: add optional custom trackpy displacements and adj_displacements
    v4: reformat string importing to take a range of numbers

@author: Eric
"""

from peri import states
import numpy as np
import pandas as pd

######################################################
# Build and save dataframe

#folder = r'C:\Users\Eric\Desktop\From cluster\gardner_glass 3-3-20\2-14-20 testing\ts-post-2-stacked-translated'
folder = r'C:\Users\Eric\Desktop\From cluster\gardner_glass 3-3-20\11-5-19 bidisperse 1p5-2\ts2-500ms-stacked'
range_start = 200
range_end = 320
digits = 4
# build a single dataframe of positions with frames labeled
for frame in range(range_start, range_end):
    # load peri state and get positions and radii
    state_file = r'\t' + str(('%0' + str(digits) + 'd') % frame) + '.tif-peri-m-finished.pkl'
    st = states.load(folder + state_file)
    pos = st.obj_get_positions()
    rad = st.obj_get_radii()
    
    # add the radii to the positions array
    pos = np.append(pos, rad[...,None], 1)
    # add a column for the current frame
    pos = np.append(pos, frame* np.ones((len(pos),1)), 1)
     
    # make a dataframe (and append it to the original frame for later steps)
    if frame==range_start:
        df = pd.DataFrame(pos, columns = ['z','y','x', 'rad', 'frame'])
    else:
        # append to dataframe
        df2 = pd.DataFrame(pos, columns = ['z','y','x', 'rad', 'frame'])
        df = df.append(df2, ignore_index = True)
        
# delete unneeded variables
del st
del pos
del rad
del df2


#Save the data to csv file
df.to_csv(folder + r'\positions_peri.csv', index = False)

####################################################################
# link with trackpy
import trackpy as tp

df['xum'] = df['x'] * 0.127
df['yum'] = df['y'] * 0.127
df['zum'] = df['z'] * 0.12

linked = tp.link_df(df, 0.5, pos_columns=['xum', 'yum', 'zum'])

#Save the data to csv file
linked.to_csv(folder + '\linked_peri.csv', index = False)

# calculate displacements with tpc
import tp_custom_functions_v15 as tpc

tpc.displacements_pd(folder + '\linked_peri.csv')
tpc.adj_displacements(folder + '\linked_peri_mod.csv')
#tpc.contact_number_linked(folder + '\linked_mod.csv', 2.5)        