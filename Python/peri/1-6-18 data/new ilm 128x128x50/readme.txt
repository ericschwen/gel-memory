1-6-18 data. Working with u0 from p50 in 1.0V.

peri code run:

runner.optimize_from_initial(st)

# hit assertion error.
addsub.add_subtract(st)

runner.optimize_from_initial(st)

# hit assertion error.
addsub.add_subtract(st)

# main optimization

opt.burn(st, mode = 'burn', n_loop = 6, desc = '', fractol = 1e-2)
addsub.add_subtract(st)
opt.burn(st, mode = 'polish', n_loop = 4, desc = '')
addsub.add_subtract(st)
runner.finish_state(st)

(some more optimization i forgot to record)

## Translate featuring to u1
st = runner.translate_featuring()

for i in range(2):
	opt.burn(st, mode='burn', n_loop=3, desc='', fractol=1e-3)
	addsub.add_subtract(st)
	opt.burn(st, mode='polish', n_loop=3, desc='')

addsub.addsubtract(st)
runner.finish_state(st)


Except for a few misfeatured particles--looks pretty good!
