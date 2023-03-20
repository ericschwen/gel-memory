# -*- coding: utf-8 -*-
"""


Created on Thu Dec 07 19:52:09 2017

@author: Eric
"""

folder = r'C:\Eric\Xerox\Python\peri\pauses translate'

folder = r'C:\Eric\Xerox\Python\peri\128x128x50_pauses'

folder = r'C:\Eric\Xerox\Python\peri\128x128x50_static'

filename = r'\linked_peri.csv'
modified_file = r'\linked_mod.csv'

import tp_custom_functions_v12 as tpc

# calculate displacements
tpc.displacements_pd(folder + filename)
# calculate adjusted displacements
tpc.adj_displacements(folder + modified_file)

