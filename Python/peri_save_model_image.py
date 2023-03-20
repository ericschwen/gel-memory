# -*- coding: utf-8 -*-
"""
peri_save_model_image

Script to pull, display, and save model image created by peri. This isn't hard
to do, I'm just making a script so I remember how to do it later.


Created on Tue Dec 18 16:30:30 2018

@author: Eric
"""

from peri import util, runner, models, states
from peri.comp import objs, comp, ilms, exactpsf
import peri.opt.optimize as opt
import peri.opt.addsubtract as addsub
from peri.viz.interaction import OrthoManipulator, OrthoViewer, OrthoPrefeature
import numpy as np


import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# for saving images
import scipy.misc
from PIL import Image


# import a sample state
folder = r'C:/Eric/Xerox/Python/peri/1-6-18 data/256x256x50'
peri_path = r'/u0.tif-peri-m-finished.pkl'
st = states.load(folder+peri_path)

# plotting raw data and model
# 2D image for frame 15. vmin and vmax optional.


plt.imshow(st.model[15], vmin = 0.0, vmax = 1.0, cmap = 'bone')
plt.show()

plt.imshow(st.data[15], vmin = 0.0, vmax = 1.0, cmap = 'bone')
plt.show()


savepath_model = folder + r'/u0-finished-model.csv'
np.savetxt(savepath_model, st.model[15], delimiter=',')

savepath_data = folder + r'/u0-finished-data.csv'
np.savetxt(savepath_data, st.data[15], delimiter=',')

# Try saving images in different formats
simage_data = scipy.misc.toimage(st.data[15], cmin=0.0, cmax = 1.0)
spath_data =  folder + r'/u0-finished-data.tif'
simage_data.save(spath_data)
#simage = scipy.misc.toimage(st.model[15])

# Try saving images in different formats
simage_model = scipy.misc.toimage(st.model[15], cmin=0.0, cmax = 1.0)
spath_model =  folder + r'/u0-finished-model.tif'
simage_model.save(spath_model)


## Using PIL. currently adjusting intensity in ways i don't want.
#im = Image.fromarray(st.data[15]) 
#im.show()
#spath3 =  r'C:/Eric/Xerox/Python/peri/1-6-18 data/128x128x50 p200/u0-finished-model_PIL.tif'
#im.save(spath3, compression='none', mode = 'L')