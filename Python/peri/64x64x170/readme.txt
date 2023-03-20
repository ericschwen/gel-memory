64x64x170 PERI
peri results for 64x64 xy-slices. 170 z-frames.

Data: 8-29-17 0.6V

zstack_post_train:

start from peri_make_state.py
optimize_from_initial

lots of other optimization, including a bit of manual work with
Orthomanipulator

save: m-polished-pre-bkg-change 12/7/17 -- initial optimization 

#####################################################################

Try new background:
background = ilms.LegendrePoly2P1D(order = (9,3,9), category = 'bkg')
more optimization didn't seem to do too much

save: m-polished-again 12/12/17 -- optimized with new background

########################################################################

Try new illumination: greater xy and lower z order

illumination = ilms.BarnesStreakLegPoly2P1D(npts = (24, 16, 10, 8, 4), zorder = 26)
processing:
addsub
opt.burn - burn
opt.burn - polish
runner.finish_state
addsub
opt.burn - burn
opt.do_levmarq - psf
opt.burn - polish

orthomanipulator looks almost the same as initial optimization. 
maybe a little bit worse (though error is 196 instead of 200).

save: m-new-ilm-polished 12/14/17

########################################################################

Try reoptimizing illumination and bkg from scratch.

illumination = ilms.BarnesStreakLegPoly2P1D(npts = (20, 16, 10, 8, 4), zorder = 26)
background = ilms.LegendrePoly2P1D(order = (9,3,9), category = 'bkg')
use st.set but without opt.fit_comp after to fit to old component.

opt.do_levmarq - ilm
opt.do_levmarq - bkg
opt.burn - burn
opt.burn - burn
opt.burn - polish
addsub
opt.burn - burn
opt.burn -polish
addsub
opt.burn - burn
addsub
opt.do_levmarq - psf
addsub
runner.finish_state
addsub
opt.do_levmarq - psf
runner.finish_state

save: m-polished-scratch2