# -*- coding: utf-8 -*-
"""
peri_make_state

Imports an image and makes a state to run peri optimizations from. Follows
the core structure from the peri walkthrough. Go read the walkthrough for more
thorough documentation/description for most of this.

Created on Tue Nov 07 10:31:22 2017

Modification History:
v2: set parameters for 64x64x250
v3: set parameters for 128x128x50 and don't include a slab.
v4: tile section similar to center section (128x128x50) out of full zstack.
	Still has no coverslip assumed.

@author: Eric
"""

from peri import util, runner, models, states
from peri.comp import objs, comp, ilms, exactpsf
import peri.opt.optimize as opt
import peri.opt.addsubtract as addsub
from peri.viz.interaction import OrthoManipulator, OrthoViewer, OrthoPrefeature
import numpy as np

im_path = 'u0.tif'

#im_path = r'C:\Eric\Xerox\Python\peri\peri examples\small_confocal_image.tif'

################## import image #########################
#im_full = util.RawImage(im_path)

# tile image (selecting pixels 0-x of image in order [z, y, x])
tile = util.Tile(left = [0, 0, 0], right = [50, 512,512])
im = util.RawImage(im_path, tile= tile)

############ create objects ######################

# create particles
featuring_rad = 5.0
particle_positions = runner.locate_spheres(im, featuring_rad, dofilter = True)

particle_radii = 7.0
particles = objs.PlatonicSpheresCollection(particle_positions, particle_radii)

## create coverslip
#slip_zpos = 6
#coverslip = objs.Slab(zpos = slip_zpos)

# combine coverslip and particles into one category
#objects = comp.ComponentCollection([particles, coverslip], category = 'obj')
objects = comp.ComponentCollection([particles], category = 'obj')

# create illumination and background
illumination = ilms.BarnesStreakLegPoly2P1D(npts = (160, 120, 80, 60, 40, 40), zorder = 9)
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
# # basic premade optimization from runners
# runner.optimize_from_initial(st)
# # main optimization

# optimize.burn(st, mode = 'burn', n_loop = 6, desc = '', fractol = 1e-2)
# addsubtract.add_subtract(st)
# optimize.burn(st, mode = 'polish', n_loop = 4, desc = '')
# addsubtract.add_subtract(st)
# runner.finish_state(st)

#
#from peri.opt import optimize, addsubtract
## initial optimization
#optimize.burn(st, mode='burn', n_loop=4, desc='', fractol=0.1)
## add_subtract particles
#addsubtract.add_subtract(st, rad = 'calc', min_rad = 'calc', max_rad = 'calc',
#                         invert = True, max_npart = 'calc')
#
## main optimization
#optimize.burn(st, mode = 'burn', n_loop = 6, desc = '', fractol = 1e-2)
#optimize.burn(st, mode = 'polish', n_loop = 4, desc = '')
#
## can try other things from here, but no set structure to run
#


