1-6-18 data. Working with u0 from p50 in 1.0V.

peri code run:

# hit assertion error.
addsub.add_subtract(st)

# main optimization

opt.burn(st, mode = 'burn', n_loop = 6, desc = '', fractol = 1e-2)
addsub.add_subtract(st)
opt.burn(st, mode = 'polish', n_loop = 4, desc = '')
addsub.add_subtract(st)
runner.finish_state(st)