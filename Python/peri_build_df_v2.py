# -*- coding: utf-8 -*-
"""
peri_build_df

Script to take positions from subsequent peri states and build a dataframe
to use for trackpy linking.

Second section links the particles with trackpy. 

Created on Tue Nov 28 11:31:43 2017

Mod History:
    v2: add radii to dataframe

@author: Eric
"""

from peri import states
import numpy as np
import pandas as pd

######################################################
# Build and save dataframe


#folder = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses'
#files = [r'\u0.tif-peri-m-test.pkl', r'\u1.tif-peri-polished-3.pkl',
#         r'\u2.tif-peri-polished-1.pkl', r'\u3.tif-peri-polish-1.pkl']

folder = r'C:\Eric\Xerox\Python\peri\1-6-17 data\128x128x50 p0'
files = [r'\u0.tif-peri-m-finished.pkl', r'\u1.tif-peri-m-finished.pkl',
         r'\u2.tif-peri-m-finished.pkl', r'\u3.tif-peri-m-finished.pkl']


#folder = r'C:\Eric\Xerox\Python\peri\128x128x50_static'
#files = [r'\t300.tif-peri-polished-some.pkl', r'\t301.tif-peri-translated.pkl',
#         r'\t302.tif-peri-addsub-polish.pkl', r'\t303.tif-peri-addsub-polish.pkl']


# build a single dataframe of positions with frames labeled
for i in range(len(files)):
    # load peri state and get positions and radii
    st = states.load(folder + files[i])
    pos = st.obj_get_positions()
    rad = st.obj_get_radii()
    
    # add the radii to the positions array
    pos = np.append(pos, rad[...,None], 1)
    # add a column for the current frame
    pos = np.append(pos, i* np.ones((len(pos),1)), 1)
    
    # make a dataframe (and append it to the original frame for later steps)
    if i==0:
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

linked = tp.link_df(df, 1.0, pos_columns=['xum', 'yum', 'zum'])

#Save the data to csv file
linked.to_csv(folder + '\linked_peri.csv', index = False)