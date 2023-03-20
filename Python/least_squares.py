# -*- coding: utf-8 -*-
"""
least squares fit

Created on Wed Feb 28 15:25:45 2018

@author: Eric
"""

import numpy as np

y = np.array([1/860., 1/625., 1/500., 1/363.])
x = np.array([1.08, 1.54, 1.90, 2.68])

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# homemade OLS linear regression
# beta = (X.t * X)^(-1) * X.t
X = np.array([np.ones(len(x)),x]).transpose()

m1 = np.linalg.inv(np.matmul(X.transpose(), X))
m2 = np.matmul(m1, X.transpose())
beta = np.matmul(m2, y)
# beta[0] = yint
# beta[1] = slope

xpts = np.arange(np.min(x), np.max(x), np.max(x)/np.min(x)/10.)
plt.plot(xpts, beta[1]*xpts + beta[0], 'r')
plt.plot(x, y, 'b:o', label = '')
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.show()

I = np.array([3.72,6.10,11.3,21.5])*10**-3
x = np.array([1.08, 1.54, 1.90, 2.68])*10**-4

f = (x/8.3)**2 / I * 344/(3.5*10**-5)