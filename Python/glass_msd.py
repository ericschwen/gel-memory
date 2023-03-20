# -*- coding: utf-8 -*-
"""
glass_msd

Testing mean square displacemnt code on settled glass.

Created on Thu Feb 27 22:13:12 2020

@author: Eric
"""

import trackpy as tp
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# Import linked dataframe using positions from PERI
path = r'C:\Users\Eric\Desktop\From cluster\gardner_glass 2-28-20\2-14-20 testing\ts-post-1-stacked' \
r'\linked_peri_mod.csv'
linked = pd.read_csv(path)

# Should probably restrict data to particles within reasonable range.

# Calculate and plot msd
msd3D = tp.emsd(linked, mpp=1, fps=2, max_lagtime=110,
                pos_columns=['xum', 'yum', 'zum'])
ax = msd3D.plot(style='o', label='MSD in 3D')
ax.set_ylabel(r'$\langle \Delta r^2 \rangle$ [$\mu$m$^2$]')
ax.set_xlabel('lag time $t$')
#ax.set_xlim(0, 16)
#ax.set_ylim(0, 20)
ax.legend(loc='upper left');