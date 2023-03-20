# -*- coding: utf-8 -*-
"""
peri_translate_range_v1

Function for translating a featured image to many very similar images. Assumes
both the featured image and the images to feature are in the same selected
directory.

Assumes some imports have already run (to avoid redoing every time).
#run basic_peri_imports.py
#import binary_peri_optimization_v7 as bp

Created on Mon Feb 24 13:14:20 2020

@author: Eric
"""
from peri import runner, states
import binary_peri_optimization_v7 as bp

def translate_list(featured_st, first, last):
    """
    Function for translating a featured image to a range of similar images.
    Assumes both the featured image and the images to feature are in the
    current directory.
    
    Inputs:
        featured_st: The featured state to translate
        first: The first image number in a range to be translated
        last: The last image number in a range to be translated
    
    Sample inputs:    
        featured_st = r't060.tif-peri-m-finished.pkl'
        first = 61
        last = 70
    """
    
    featured_state = featured_st
    to_feature_first = first
    to_feature_last = last
    
    
    for i in range(to_feature_first, to_feature_last):
        new_im = 't0' + str(i) + '.tif'
        st = runner.translate_featuring(state_name = featured_state,
                                        im_name = new_im)
    
        bp.binary_opt(st)
        bp.binary_finish(st)
        states.save(st, desc = 'm-finished')
        print(new_im + ' finished')



# original code to make into a loop
#st = runner.translate_featuring(state_name = r't060.tif-peri-m-finished.pkl', ...
#                                im_name = r't089.tif')
#bp.binary_opt(st)
#bp.binary_finish(st)
#states.save(st, desc = 'm-finished')