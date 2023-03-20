# -*- coding: utf-8 -*-
"""
Functions for calculating and returning deviatoric fabric tensor averaged
over all particles in a range.

Functions for both first and second shell.

Author: Eric
Date: 12/5/17

"""


import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.rc('figure',  figsize=(10, 6))

# file path for linked particle positions from trackpy
#features_file = r'C:\Eric\Xerox\Python\peri\test\neighbors.csv'

def deviatoric_fabric_tensor(features_file):
    """
    Calculates the deviatoric fabric tensor for each particle. Returns the
    average deviatoric fabric tensor.
    
    Restricted to specific z-range. Could add this a parameters in function.
    
    Inputs:
        features_file: path to file of dataframe with fabric tensor calculated
        for each particle
    Outputs:
        xi: vector [xi_xx, xi_yy, xi_zz] of average deviatoric fabric tensor
    """
    

    f1 = pd.read_csv(features_file)
    
    # standard fabric tensor
    f1['traceZ'] = f1['Z_xx'] + f1['Z_yy'] + f1['Z_zz']
    f1['xi_xx'] = f1['Z_xx'] - f1['traceZ']/3
    f1['xi_yy'] = f1['Z_yy'] - f1['traceZ']/3
    f1['xi_zz'] = f1['Z_zz'] - f1['traceZ']/3
    
    
    # z cutoffs: neglect between 1 and 1.5 particle diameter in each direction
    # modify based on number of z frames
    # fabric tensor: require that fabric tensor > 0 (only count particles with nonzero contact number)
    
    # for 50 frames and 1.2 diameter(s)
    #f = f1.loc[(f1.z > 21) & (f1.z < 28)]
    f = f1.loc[(f1.z > 21) & (f1.z < 28) & (f1.Z_xx >0)]
    
    # for 100 frames and 1.5 diameters
    #f = f1.loc[(f1.z > 24) & (f1.zum < 76)]
    
    ## for 200 frames and 2 diameters(s)
    #f = f1.loc[(f1.z > 32) & (f1.z < 168) & (f1.Z_xx > 0)]
    
    xi_xx = f.xi_xx.values
    xi_yy = f.xi_yy.values
    xi_zz = f.xi_zz.values
    
    xi_averaged = [np.mean(xi_xx), np.mean(xi_yy), np.mean(xi_zz)]
    
#    # Plotting if desired
#    h, bin_edges = np.histogram(xi_xx, bins=np.arange(20)/10., density = False)
#    
#    pdf_h = np.array(h)/float(sum(h))
#    
#    # plot the histogram of probablilies
#    plt.plot(bin_edges[1:], pdf_h, 'b:o', label = 'Current')
#    plt.xlim(0, 2)
#    plt.ylim(0, .2)
#    plt.xlabel('xi_xx', fontsize = 18)
#    plt.ylabel('Probability', fontsize = 18)
#    plt.title('Deviatoric Fabric Tensor Histogram', fontsize = 18)
#    plt.yticks(fontsize = 18)
#    plt.xticks(fontsize = 18)
#    plt.legend(loc = 'upper left', fontsize = 18)
#    plt.show()   
    
    return xi_averaged


def deviatoric_fabric_tensor_2nd(features_file):
    """
    Calculates the 2ND SHELL deviatoric fabric tensor for each particle. Returns the
    average 2ND SHELL deviatoric fabric tensor.
    
    Restricted to specific z-range. Could add this a parameters in function.
    
    Inputs:
        features_file: path to file of dataframe with fabric tensor calculated
        for each particle
    Outputs:
        xi: vector [xi_xx, xi_yy, xi_zz] of average deviatoric fabric tensor
    """
    

    f1 = pd.read_csv(features_file)
    
#    # standard fabric tensor
#    f1['traceZ'] = f1['Z_xx'] + f1['Z_yy'] + f1['Z_zz']
#    f1['xi_xx'] = f1['Z_xx'] - f1['traceZ']/3
#    f1['xi_yy'] = f1['Z_yy'] - f1['traceZ']/3
#    f1['xi_zz'] = f1['Z_zz'] - f1['traceZ']/3
    
    
    # second shell fabric tensor
    f1['trace_2nd_Z'] = f1['Z_2nd_xx'] + f1['Z_2nd_yy'] + f1['Z_2nd_zz']
    f1['xi_2nd_xx'] = f1['Z_2nd_xx'] - f1['trace_2nd_Z']/3
    f1['xi_2nd_yy'] = f1['Z_2nd_yy'] - f1['trace_2nd_Z']/3
    f1['xi_2nd_zz'] = f1['Z_2nd_zz'] - f1['trace_2nd_Z']/3
    
    # z cutoffs: neglect between 1 and 1.5 particle diameter in each direction
    # modify based on number of z frames
    # fabric tensor: require that fabric tensor > 0 (only count particles with nonzero contact number)
    
    # for 50 frames and 1.2 diameter(s)
    #f = f1.loc[(f1.z > 21) & (f1.z < 28)]
    f = f1.loc[(f1.z > 21) & (f1.z < 28) & (f1.Z_xx >0)]
    
    # for 100 frames and 1.5 diameters
    #f = f1.loc[(f1.z > 24) & (f1.zum < 76)]
    
    ## for 200 frames and 2 diameters(s)
    #f = f1.loc[(f1.z > 32) & (f1.z < 168) & (f1.Z_xx > 0)]
    
    xi_2nd_xx = f.xi_2nd_xx.values
    xi_2nd_yy = f.xi_2nd_yy.values
    xi_2nd_zz = f.xi_2nd_zz.values
    
    xi_averaged = [np.mean(xi_2nd_xx), np.mean(xi_2nd_yy), np.mean(xi_2nd_zz)]
    
    
    h, bin_edges = np.histogram(xi_2nd_xx, bins=np.arange(20)/10., density = False)
    
    pdf_h = np.array(h)/float(sum(h))
    
    # plot the histogram of probablilies
    plt.plot(bin_edges[1:], pdf_h, 'b:o', label = 'Current')
    plt.xlim(0, 2)
    plt.ylim(0, .2)
    plt.xlabel('xi_xx', fontsize = 18)
    plt.ylabel('Probability', fontsize = 18)
    plt.title('Deviatoric Fabric Tensor Histogram', fontsize = 18)
    plt.yticks(fontsize = 18)
    plt.xticks(fontsize = 18)
    plt.legend(loc = 'upper left', fontsize = 18)
    plt.show()   
    
    return xi_averaged