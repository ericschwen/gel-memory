
# -*- coding: utf-8 -*-
"""
polymat_3_2

Polymeric Materials Hmwk 3 Problem 1

Created on Wed Feb 28 10:53:10 2018

@author: Eric
"""
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

r1 = [1.39, 0.01, 0.002]
r2 = [0.78, 55.0, 0.032]

f1 = np.arange(0,1.1,.01)
F1 = np.zeros((len(f1), len(r1)))

for i in range(len(r1)):
    F1[:,i] = ((r1[i] - 1)*f1**2 + f1)/((r1[i] + r2[i]-2)*f1**2 + 2*(1-r2[i])*f1 + r2[i])

plt.plot(f1,f1,'k')
plt.plot(f1, F1[:,0], 'b:o', label = 'a')
plt.plot(f1, F1[:,1], 'r:o', label = 'b')
plt.plot(f1, F1[:,2], 'g:o', label = 'c')
plt.xlabel('f1', fontsize = 12)
plt.ylabel('F1', fontsize = 12)
plt.xlim(0, 1)
plt.ylim(0, 1)
plt.legend(loc = 'upper left', fontsize = 12)
plt.show()