# -*- coding: utf-8 -*-
"""
polymat_3_1

Polymeric Materials Hmwk 3 Problem 1

Created on Wed Feb 28 10:53:10 2018

@author: Eric
"""
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

X = np.array([.125, .250, .5, 1.0, 4.0, 8.0])
Y = np.array([.150, .358, .602, 1.33, 4.72, 10.63])

f1 = X/(1+X)
F1 = Y/(1+Y)

a = (Y-1)/X
b = Y/X**2


# plot
plt.plot(b, a, 'b:o', label = '')
#plt.xlim(0, 10)
#plt.ylim(0, .3)
#plt.xlabel('Contact number $\mathit{z}$', fontsize = 12)
#plt.ylabel('$P(z)$', fontsize = 12)
#plt.title('Contact number distribution', fontsize = 12)
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
#plt.legend(loc = 'upper left', fontsize = 12)
plt.show() 

# homemade OLS linear regression
# beta = (X.t * X)^(-1) * X.t
regX = np.array([np.ones(len(a)),b]).transpose()

m1 = np.linalg.inv(np.matmul(regX.transpose(), regX))
m2 = np.matmul(m1, regX.transpose())
beta = np.matmul(m2, a)
# beta[0] = yint
# beta[1] = slope

# plot regression
xpts = np.arange(11)
plt.plot(xpts, beta[1]*xpts + beta[0], 'r')
plt.plot(b, a, 'b:o', label = '')
plt.yticks(fontsize = 12)
plt.xticks(fontsize = 12)
plt.show()

 
# plot F1 vs f1
plt.plot(f1, F1, 'b:o')
plt.show()