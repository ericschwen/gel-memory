""""
# Modified optimize from runner's optimize from initial function. Try to avoid
assertion error by including more add_subtract calls
"""
# Have to actually import these if not already imported when running peri.
from peri import states, logger
import peri.opt.optimize as opt
import peri.opt.addsubtract as addsub
import numpy as np

RLOG = logger.log.getChild('runner')

def emod_optimize_from_initial(s, max_mem=1e9, invert=True, desc='', rz_order=3,
		min_rad=None, max_rad=None):
    """
    Optimizes a state from an initial set of positions and radii, without
    any known microscope parameters.

    Parameters
    ----------
        s : :class:`peri.states.ImageState`
            The state to optimize. It is modified internally and returned.
        max_mem : Numeric, optional
            The maximum memory for the optimizer to use. Default is 1e9 (bytes)
        invert : Bool, optional
            True if the image is dark particles on a bright background,
            False otherwise. Used for add-subtract. Default is True.
        desc : String, optional
            An additional description to infix for periodic saving along the
            way. Default is the null string ``''``.
        rz_order : int, optional
            ``rz_order`` as passed to opt.burn. Default is 3
        min_rad : Float or None, optional
            The minimum radius to identify a particles as bad, as passed to
            add-subtract. Default is None, which picks half the median radii.
            If your sample is not monodisperse you should pick a different
            value.
        max_rad : Float or None, optional
            The maximum radius to identify a particles as bad, as passed to
            add-subtract. Default is None, which picks 1.5x the median radii.
            If your sample is not monodisperse you should pick a different
            value.

    Returns
    -------
        s : :class:`peri.states.ImageState`
            The optimized state, which is the same as the input ``s`` but
            modified in-place.
    """
    RLOG.info('Initial burn:')
    opt.burn(s, mode='burn', n_loop=3, fractol=0.1, desc=desc + 'initial-burn',
			max_mem=max_mem, include_rad=False, dowarn=False)
    opt.burn(s, mode='burn', n_loop=3, fractol=0.1, desc=desc + 'initial-burn',
			max_mem=max_mem, include_rad=True, dowarn=False)

    RLOG.info('Start add-subtract')
    rad = s.obj_get_radii()
    if min_rad is None:
		min_rad = 0.5 * np.median(rad)
    if max_rad is None:
		max_rad = 1.5 * np.median(rad)
    addsub.add_subtract(s, tries=30, min_rad=min_rad, max_rad=max_rad,
			invert=invert)
    states.save(s, desc=desc+'initial-addsub')

    RLOG.info('Final polish:')
    opt.burn(s, mode='polish', n_loop=3, fractol=3e-4, desc=desc +
			'addsub-polish', max_mem=max_mem, rz_order=rz_order, dowarn=False)
    # My modifications. Reduce number of loops and add add_subtract calls
    addsub.add_subtract(s)
    opt.burn(s, mode='polish', n_loop=3, fractol=3e-4, desc=desc +
			'addsub-polish', max_mem=max_mem, rz_order=rz_order, dowarn=False)
    addsub.add_subtract(s)
    d = opt.burn(s, mode='polish', n_loop=3, fractol=3e-4, desc=desc +
			'addsub-polish', max_mem=max_mem, rz_order=rz_order, dowarn=False)

    if not d['converged']:
        RLOG.warn('Optimization did not converge; consider re-running')
    return s
	
	
# ORIGINAL CODE FROM RUNNER
def optimize_from_initial(s, max_mem=1e9, invert=True, desc='', rz_order=3,
        min_rad=None, max_rad=None):
    """
    Optimizes a state from an initial set of positions and radii, without
    any known microscope parameters.

    Parameters
    ----------
        s : :class:`peri.states.ImageState`
            The state to optimize. It is modified internally and returned.
        max_mem : Numeric, optional
            The maximum memory for the optimizer to use. Default is 1e9 (bytes)
        invert : Bool, optional
            True if the image is dark particles on a bright background,
            False otherwise. Used for add-subtract. Default is True.
        desc : String, optional
            An additional description to infix for periodic saving along the
            way. Default is the null string ``''``.
        rz_order : int, optional
            ``rz_order`` as passed to opt.burn. Default is 3
        min_rad : Float or None, optional
            The minimum radius to identify a particles as bad, as passed to
            add-subtract. Default is None, which picks half the median radii.
            If your sample is not monodisperse you should pick a different
            value.
        max_rad : Float or None, optional
            The maximum radius to identify a particles as bad, as passed to
            add-subtract. Default is None, which picks 1.5x the median radii.
            If your sample is not monodisperse you should pick a different
            value.

    Returns
    -------
        s : :class:`peri.states.ImageState`
            The optimized state, which is the same as the input ``s`` but
            modified in-place.
    """
	
    RLOG.info('Initial burn:')
    opt.burn(s, mode='burn', n_loop=3, fractol=0.1, desc=desc + 'initial-burn',
            max_mem=max_mem, include_rad=False, dowarn=False)
    opt.burn(s, mode='burn', n_loop=3, fractol=0.1, desc=desc + 'initial-burn',
            max_mem=max_mem, include_rad=True, dowarn=False)

    RLOG.info('Start add-subtract')
    rad = s.obj_get_radii()
    if min_rad is None:
        min_rad = 0.5 * np.median(rad)
    if max_rad is None:
        max_rad = 1.5 * np.median(rad)
    addsub.add_subtract(s, tries=30, min_rad=min_rad, max_rad=max_rad,
            invert=invert)
    states.save(s, desc=desc+'initial-addsub')

    RLOG.info('Final polish:')
    d = opt.burn(s, mode='polish', n_loop=8, fractol=3e-4, desc=desc +
            'addsub-polish', max_mem=max_mem, rz_order=rz_order, dowarn=False)
    if not d['converged']:
        RLOG.warn('Optimization did not converge; consider re-running')
    return s
	