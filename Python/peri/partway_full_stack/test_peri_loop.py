# test_peri_loop.py


for i in range(5):
	opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3)
	addsub.add_subtract(st)
	opt.burn(st, mode='polish', n_loop=3, desc='')