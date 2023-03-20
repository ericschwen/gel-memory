# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 01:25:39 2017

@author: Eric

Making the basic featuers of locate_particles_3D_v11 into a function
"""

def tp_locate_custom(path):
    """ Takes the path to a folder off tiffs (zslices in a zstack) and runs
    tp.locate with custom sizes."""
    
    import pims
    import trackpy as tp
        
        
    "path = r'C:\Eric\Xerox Data\30um gap runs\6-22-17 0.3333Hz\1.4V sweep pauses\zstack_p100_1_bpass3D\*.tif';"
    frames = pims.ImageSequenceND(path, axes_identifiers = ['z'])
    
    features = tp.locate(frames[0], diameter=(15, 15, 15), invert = False, separation = (7,7,7), preprocess = False, minmass = 60000) 
    
    #Save the data to csv file
    features.to_csv(path[:-5] + 'features.csv')
    return