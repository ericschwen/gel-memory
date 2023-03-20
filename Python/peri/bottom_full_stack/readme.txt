Runs peri on bottom tile (128x128x50) of full zstack_post_train.tif.
0.6V data from 8/29/17

#optimize history:
runner.optimize_from_initial(st)
addsub.add_subtract(st)

for i in range(5):
	opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3)
	addsub.add_subtract(st)
	opt.burn(st, mode='polish', n_loop=3, desc='')

addsub.add_subtract(st)
opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3);
opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3);

states.save(st, desc='m-finished')

addsub (nothing changed)
opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3);