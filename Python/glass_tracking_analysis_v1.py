# -*- coding: utf-8 -*-
"""
glass_tracking_analysis_v1

Script calculates relevant displacement information for Gardner transition 
from particle positions located using PERI and tracked using trackpy. Input
file is linked_peri_mod.csv created by peri_buld_df_v3.py.

Created on Wed Feb 19 10:50:24 2020

@author: Eric
"""

import pandas as pd
import numpy as np
import os
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))


folder = r'C:\Users\Eric\Desktop\From cluster\gardner_glass 2-14-20\11-5-19 bidisperse 1p5-2\peri-ts2-500ms'
linked_filename = r'\linked_peri_mod.csv'
linked_filepath = folder + linked_filename

t = pd.read_csv(linked_filepath)

# Look at non-nan displacements
tdx = t.dxum.values[~np.isnan(t.dxum.values)]
tdy = t.dyum.values[~np.isnan(t.dyum.values)]
tdz = t.dzum.values[~np.isnan(t.dzum.values)]

