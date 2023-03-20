Processing p500 pauses from 1-8-17

procedure u0:

runner.optimize_from_initial(st)

opt.burn(st, mode = 'burn', n_loop = 4, desc = '', fractol = 1e-2)
addsub.add_subtract(st)
opt.burn(st, mode = 'polish', n_loop = 4, desc = '')
addsub.add_subtract(st)
runner.finish_state(st)

addsub.add_subtract(st)
runner.optimize_from_initial(st)
addsub.add_subtract(st)

opt.burn(st, mode = 'burn', n_loop = 3, desc = '', fractol = 1e-3)
addsub.add_subtract(st)
opt.burn(st, mode = 'polish', n_loop = 3, desc = '')
addsub.add_subtract(st)
runner.finish_state(st)