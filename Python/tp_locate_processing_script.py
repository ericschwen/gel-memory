# -*- coding: utf-8 -*-
"""
Script to run trackpy particle location on a bunch of zstacks.

Created on Wed Jun 28 02:09:42 2017

@author: Eric
"""
from tp_locate_custom_v1 import tp_locate_custom

folder = r'C:\Eric\Xerox Data\30um gap runs\6-28-17 0.3333Hz\1.0V'
l1 = ['p0', 'p100', 'p200', 'p300', 'p400', 'p500']
l2 = ['u1', 'u2', 'u3', 's1', 's2']

name = 'bpass_3D'

bslash = '\\'
uscore = '_'
extension = r'\*.tif'

for i in range(len(l1)):
    for j in range(len(l2)):
        path = folder + bslash + 'zstacks_' + l1[i] + bslash + l2[j] + '_bpass3D' + extension
        tp_locate_custom(path)                                               
        print(path)
                                   