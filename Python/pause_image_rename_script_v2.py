# -*- coding: utf-8 -*-
"""
pause_image_rename_script

Renames the images in folder to tell order and sheared or unsheared state.

Useful for images that have been saved as just "Image467.lsm" instead of with
a descriptive name.

Created on Mon Aug 14 13:27:15 2017

Mod History:
v2: modify names to also include xy time series.

!!!!!!!!! NOTE: Order currently wrong if going from Image99 to Image100, etc.!!!!!!!!
Should fix by checking to make sure all file names are same length.

@author: Eric
"""

import shutil as shutil
import os


#folder = r'C:\Eric\Xerox Data\30um gap runs\8-29-17 0.3333Hz\Untrained short\ampsweep'

folder = r'C:\Eric\Xerox Data\30um gap runs\1-6-18 0.3333Hz\1.0V'

## Choose all subfolers in the folder
#subfolders = os.listdir(folder)

## maunal subfolders
subfolders = ['p150 order']
#subfolders = ['']
#subfolders = ['p0', 'p50', 'p100', 'p150', 'p200', 'p300', 'p400', 'p500']

# Set new names for the files to be renamed to:
## 5 shear cycles
#names = ['u0', 's1', 'u1', 's2', 'u2', 's3', 'u3', 's4', 'u4', 's5', 'xy_ts', 'u5']

## 3 shear cycles (pauses)
names = ['u0', 's1', 'u1', 's2', 'u2', 's3', 'xy_ts', 'u3']

## 4 shear cycles
#names = ['u0', 's1', 'u1', 's2', 'u2', 's3', 'u3', 's4', 'xy_ts', 'u4']
## 6 shear cycle version
#names = ['u0', 's1', 'u1', 's2', 'u2', 's3', 'u3', 's4', 'u4', 's5', 'u5', 's6', 'xy_ts', 'u6']



for sub in subfolders:
    f = folder + '\\' +sub
    image_names = os.listdir(f)
    if len(image_names) != len(names):
        print(sub + ' skipped. Wrong number of files.')
    elif image_names[0][0:5] != 'Image':
        print(sub + ' skipped. Already renamed.')
    else:
        for i in range(len(image_names)):
            old_file = f + '\\' + image_names[i]
            new_file = f + '\\' + names[i] + '.lsm'
            shutil.move(old_file, new_file)
#            os.rename(old_file, new_file)
        print(sub + ' done.')
