# -*- coding: utf-8 -*-
"""
Created on Fri Sep 15 13:18:12 2017

Script to save single frame of data
@author: Eric
"""
import pandas as pd

path = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\1.0\p400\u_combined\linked_w_displacements_w_contacts_w_adj_disp.csv'

t_frame = 0

# filepath to tp trajectories
linked_features_file = path

# sepcific frame to look at
frame = t_frame

linked = pd.read_csv(linked_features_file)

# delete unnamed column if necessary
if 'Unnamed: 0' in linked.columns:
    del linked['Unnamed: 0']


# define distances in um instead of pixels (if not already done)
if not 'xum' in linked.columns:
    linked['xum'] = linked['x'] * 0.125
    linked['yum'] = linked['y'] * 0.125
    linked['zum'] = linked['z'] * 0.12

    
# create dataframe with just current frame
f_full = linked.loc[linked['frame'] == frame]

f = f_full[['xum', 'yum', 'zum', 'dr', 'dr_adj_x']]

save_short_filepath = linked_features_file[:-4] + '_t0.csv'
f.to_csv(save_short_filepath, index = False)
