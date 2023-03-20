# -*- coding: utf-8 -*-
"""
peri_make_state

Imports an image and makes a state to run peri optimizations from. Follows
the core structure from the peri walkthrough. Go read the walkthrough for more
thorough documentation/description for most of this.

Created on Tue Nov 07 10:31:22 2017

@author: Eric
"""

from peri import util, runner, models, states
from peri.comp import objs, comp, ilms, exactpsf
import peri.opt.optimize as opt
import peri.opt.addsubtract as addsub
from peri.viz.interaction import OrthoManipulator, OrthoViewer, OrthoPrefeature
import numpy as np

im_path = 'zstack_pre_train.tif'
#im_path = r'C:\Eric\Xerox\Python\peri\peri examples\small_confocal_image.tif'

################## import image #########################
#im_full = util.RawImage(im_path)

# tile image (selecting pixels 0-x of image in order [z, y, x])
tile = util.Tile([170, 64, 64])
im = util.RawImage(im_path, tile= tile)

############ create objects ######################

# create particles
featuring_rad = 5.0
particle_positions = runner.locate_spheres(im, featuring_rad, dofilter = True)

particle_radii = 7.0
particles = objs.PlatonicSpheresCollection(particle_positions, particle_radii)

# create coverslip
slip_zpos = 6
coverslip = objs.Slab(zpos = slip_zpos)

# combine coverslip and particles into one category
objects = comp.ComponentCollection([particles, coverslip], category = 'obj')

# create illumination and background
illumination = ilms.BarnesStreakLegPoly2P1D(npts = (16, 10, 8, 4), zorder = 34)
background = ilms.LegendrePoly2P1D(order = (9,3,5), category = 'bkg')
offset = comp.GlobalScalar(name = 'offset', value = 0.)

# create psf
point_spread_function = exactpsf.FixedSSChebLinePSF()

# create model
model = models.ConfocalImageModel()

############### create state ###################################
st = states.ImageState(im, [objects, illumination, background,
                            point_spread_function, offset], mdl = model)

runner.link_zscale(st)

################# begin optimization ######################
## basic premade optimization from runner
#runner.optimize_from_initial(st)



