# test_peri_loop.py

# more addsubs
for i in range(5):
	opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3)
	addsub.add_subtract(st)
	opt.burn(st, mode='polish', n_loop=3, desc='')
	addsub.add_subtract(st)
	addsub.add_subtract_locally(st)
	
	
# basic optimization	
for i in range(5):
	opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3)
	addsub.add_subtract(st)
	opt.burn(st, mode='polish', n_loop=3, desc='')
	
# psf optimization
state_vals	=[]
for i in range(10):  #or another big number
	opt.burn(st, mode='polish', n_loop=1)
	opt.do_levmarq(st, st.get('psf').params)
	state_vals.append(np.copy(st.state[st.params]))