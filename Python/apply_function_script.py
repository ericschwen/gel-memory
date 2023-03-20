# -*- coding: utf-8 -*-
"""
apply_function_script

Just a dumb script to apply the same function to a set of different confocal
images. I'll probably repurpose it for multiple data sets/functions

Doesn't import any modules or whatever. Assumes already done.

Created on Tue Mar 26 17:01:38 2019

@author: Eric
"""

paths_list = [r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p0\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p50\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p100\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p150\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p200\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p300\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p400\linked_peri_mod.csv',
              r'C:\Eric\Xerox\Python\peri\1-6-18 data\128x128x50 p500\linked_peri_mod.csv']

import surface_separation_neighbors_v2 as ss

for path in paths_list:
    print(path)
    ss.surf_sep_neighbors(path, 100)