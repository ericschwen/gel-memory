# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 13:20:47 2017

@author: Eric

Contains modified versions of annotate3d from trackpy. 
Zrange adds circles around the particles.
zrange_savestack adds the circles and saves the image files with the circles
aroudn located particles.
"""

#%matplotlib inline
# not sure what the % sign was supposed to do there, but it did not evaluate
# as correct syntax so I commented it out.
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))
import numpy as np
import pandas as pd
from pandas import DataFrame, Series  # for convenience

import pims
import trackpy as tp
import os

try:
    from pims import plot_to_frame, plots_to_frame, normalize
except ImportError:
    plot_to_frame = None
    plots_to_frame = None
    normalize = None

def annotate3d_zrange(centroids, image, **kwargs):
    """Annotates a 3D image and returns a scrollable stack for display in
    IPython.
    
    Parameters
    ----------
    centroids : DataFrame including columns x and y
    image : image array (or string path to image file)
    circle_size : Deprecated.
        This will be removed in a future version of trackpy.
        Use `plot_style={'markersize': ...}` instead.
    color : single matplotlib color or a list of multiple colors
        default None
    invert : If you give a filepath as the image, specify whether to invert
        black and white. Default True.
    ax : matplotlib axes object, defaults to current axes
    split_category : string, parameter to use to split the data into sections
        default None
    split_thresh : single value or list of ints or floats to split
        particles into sections for plotting in multiple colors.
        List items should be ordered by increasing value.
        default None
    imshow_style : dictionary of keyword arguments passed through to
        the `Axes.imshow(...)` command the displays the image
    plot_style : dictionary of keyword arguments passed through to
        the `Axes.plot(...)` command that marks the features
    Returns
    -------
    pims.Frame object containing a three-dimensional RGBA image
    See Also
    --------
    annotate : annotation of 2D images
    """
    import trackpy as tp
    
    if plots_to_frame is None:
        raise ImportError('annotate3d requires pims 0.3 or later, please '
                          'update pims')

    import matplotlib as mpl
    import matplotlib.pyplot as plt

    if image.ndim != 3 and not (image.ndim == 4 and image.shape[-1] in (3, 4)):
        raise ValueError("image has incorrect dimensions. Please input a 3D "
                         "grayscale or RGB(A) image. For 2D image annotation, "
                         "use annotate. Multichannel images can be "
                         "converted to RGB using pims.display.to_rgb.")

    # We want to normalize on the full image and stop imshow from normalizing.
    normalized = (normalize(image) * 255).astype(np.uint8)
    imshow_style = dict(vmin=0, vmax=255)
    if '_imshow_style' in kwargs:
        kwargs['imshow_style'].update(imshow_style)
    else:
        kwargs['imshow_style'] = imshow_style

    max_open_warning = mpl.rcParams['figure.max_open_warning']
    was_interactive = plt.isinteractive()
    try:
        # Suppress warning when many figures are opened
        mpl.rc('figure', max_open_warning=0)
        # Turn off interactive mode (else the closed plots leave emtpy space)
        plt.ioff()

        figures = [None] * len(normalized)
        for i, imageZ in enumerate(normalized):
            fig = plt.figure()
            kwargs['ax'] = fig.gca()
            
            # Can use centroidsZ to specify how close particles need to be in
            # the z-direction to be circled. Default uses zhold = 0
            zhold = 5;
            centroidsZ = centroids[(centroids['z'] > i - zhold - 0.5) &
                                   (centroids['z'] < i + zhold + 0.5)]
            tp.annotate(centroidsZ, imageZ, **kwargs)
            
#             # Use regular centriods to put all circles on every image
#             tp.annotate(centroids, imageZ, **kwargs)
            
            figures[i] = fig

        result = plots_to_frame(figures, width=512, close_fig=True,
                                bbox_inches='tight')
    finally:
        # put matplotlib back in original state
        if was_interactive:
            plt.ion()
        mpl.rc('figure', max_open_warning=max_open_warning)

    return result

def annotate3d_zrange_saveStack(centroids, image, path, **kwargs):
    """Annotates a 3D image and returns a scrollable stack for display in
    IPython.
    
    Parameters
    ----------
    centroids : DataFrame including columns x and y
    image : image array (or string path to image file)
    circle_size : Deprecated.
        This will be removed in a future version of trackpy.
        Use `plot_style={'markersize': ...}` instead.
    color : single matplotlib color or a list of multiple colors
        default None
    invert : If you give a filepath as the image, specify whether to invert
        black and white. Default True.
    ax : matplotlib axes object, defaults to current axes
    split_category : string, parameter to use to split the data into sections
        default None
    split_thresh : single value or list of ints or floats to split
        particles into sections for plotting in multiple colors.
        List items should be ordered by increasing value.
        default None
    imshow_style : dictionary of keyword arguments passed through to
        the `Axes.imshow(...)` command the displays the image
    plot_style : dictionary of keyword arguments passed through to
        the `Axes.plot(...)` command that marks the features
    Returns
    -------
    pims.Frame object containing a three-dimensional RGBA image
    See Also
    --------
    annotate : annotation of 2D images
    """
    import trackpy as tp
    
    if plots_to_frame is None:
        raise ImportError('annotate3d requires pims 0.3 or later, please '
                          'update pims')

    import matplotlib as mpl
    import matplotlib.pyplot as plt

    if image.ndim != 3 and not (image.ndim == 4 and image.shape[-1] in (3, 4)):
        raise ValueError("image has incorrect dimensions. Please input a 3D "
                         "grayscale or RGB(A) image. For 2D image annotation, "
                         "use annotate. Multichannel images can be "
                         "converted to RGB using pims.display.to_rgb.")

    # We want to normalize on the full image and stop imshow from normalizing.
    normalized = (normalize(image) * 255).astype(np.uint8)
    imshow_style = dict(vmin=0, vmax=255)
    if '_imshow_style' in kwargs:
        kwargs['imshow_style'].update(imshow_style)
    else:
        kwargs['imshow_style'] = imshow_style

    max_open_warning = mpl.rcParams['figure.max_open_warning']
    was_interactive = plt.isinteractive()
    try:
        # Suppress warning when many figures are opened
        mpl.rc('figure', max_open_warning=0)
        # Turn off interactive mode (else the closed plots leave emtpy space)
        plt.ioff()

        figures = [None] * len(normalized)
        for i, imageZ in enumerate(normalized):
            fig = plt.figure()
            kwargs['ax'] = fig.gca()
            
            # Can use centroidsZ to specify how close particles need to be in
            # the z-direction to be circled. Default uses zhold = 0
            zhold = 5;
            centroidsZ = centroids[(centroids['z'] > i - zhold - 0.5) &
                                   (centroids['z'] < i + zhold + 0.5)]
            tp.annotate(centroidsZ, imageZ, **kwargs)
            
#             # Use regular centriods to put all circles on every image
#             tp.annotate(centroids, imageZ, **kwargs)
            
            figures[i] = fig
            
            # Make new directory and save path
            newpath = newpath = path[:-5]+ r'annotated'
            if not os.path.exists(newpath):
                os.makedirs(newpath)
            savepath = path[:-5]+ r'annotated\z' + str(i) + '.tif';
            fig.savefig(savepath,bbox_inches='tight')
        result = plots_to_frame(figures, width=512, close_fig=True,
                                bbox_inches='tight')
    finally:
        # put matplotlib back in original state
        if was_interactive:
            plt.ion()
        mpl.rc('figure', max_open_warning=max_open_warning)

    return result
