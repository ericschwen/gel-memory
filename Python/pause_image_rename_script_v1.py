# -*- coding: utf-8 -*-
"""
pause_image_rename_script

Renames the images in folder to tell order and sheared or unsheared state.

Useful for images that have been saved as just "Image467.lsm" instead of with
a descriptive name.


Created on Mon Aug 14 13:27:15 2017

@author: Eric
"""

import shutil as shutil
import os


folder = r'C:\Eric\Xerox Data\30um gap runs\8-11-17 0.3333Hz training\Untrained Amplitude Sweep 1\ampsweep'

#subfolders = os.listdir(folder)

subfolders = ['3.6', '4.0', '4.8']

names = ['u0', 's1', 'u1', 's2', 'u2', 's3', 'u3', 's4', 'u4', 's5', 'u5']

for sub in subfolders:
    f = folder + '\\' +sub
    image_names = os.listdir(f)
    for i in range(len(image_names)):
        old_file = f + '\\' + image_names[i]
        new_file = f + '\\' + names[i] + '.lsm'
        shutil.move(old_file, new_file)
#        os.rename(old_file, new_file)