# -*- coding: utf-8 -*-
"""
simple image rename

Created on Mon Aug 14 13:27:15 2017

Mod History:
v2: modify names to also include xy time series.

@author: Eric
"""

import shutil as shutil
import os
import numpy as np


f = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting t300-305_bpass'

f2 = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained delayed short\waiting t300-305_bpass_renamed'

image_names = os.listdir(f)
time = 2
start = time* 50
for i in np.arange(0, 50):
    old_file = f + '\\' + image_names[start + i]
    new_file = f2 + '\\' + image_names[start+i][0:9] + str(time) + image_names[start+i][12:15] + '.tif'
#    new_file = f2 + '\\' + 't' + str(start/50 + 1) + 'z' + str(i+1) + '.tif'
#    new_file = f2 + '\\' + 't' + str(start/50 + 1) + 'z' + str(i+1) + '.tif'
    shutil.copy(old_file, new_file)