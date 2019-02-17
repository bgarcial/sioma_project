# -*- coding: utf-8 -*-
"""
Análisis previo de los datos
"""

import matplotlib.pyplot as plt
import seaborn as sns
import numpy
import random
# Set a seed
random.seed(10000)

def plots(data, qlabels, np, nq):
    """
    Initial plots to detect atypical data
    """
    # Itere entre 0, nq(la longitud de las columnas numericas - 30 en el caso de decision tree)
    # np=6 
    for i in range(0, nq, np):
        # se grafica dividiendo entre cada posicion de columna y np 
        fig = plt.figure(i/np)
        
        # Se itera sobre un rango de 0 a 6
        for j in range(np):
            
            ax1 = fig.add_subplot(231+j)
            var = qlabels[j+i]
            ax1.scatter(data.index, data[var])
            ax1.set_xlabel(var)
    


def plotsc(datan, qlabels, ylabel, nq, np, cp, cc):
    """
    Plot variables and interest variable
    """
    v = qlabels.copy()
    v.remove(ylabel)
    
    for i in range(0, nq-1, np):
        fig = plt.figure(i/np)
        
        for j in range(np):
            
            ax1 = fig.add_subplot(231+j)
            var = qlabels[j+i]
            ax1.scatter(datan[var], datan[ylabel])
            ax1.set_xlabel(var)
    
    corr = datan.corr().abs()
    upper = corr.where(numpy.triu(numpy.ones(corr.shape), k=1).astype(numpy.bool))
    # Get values above correlation percentage criteria
    z = upper>=cp
    # Get number of correlated variables
    c = z.sum()
    cv = c[c >= cc]
    lv = list(cv.index)
    
    return z, c, lv
        
    #corr_matrix = datan.corr().abs()
    #upper = corr_matrix.where(np.triu(np.ones(corr_matrix.shape)
    
    
    # Variables with correlation
#    varc = []
#    cont = 0
#    for i in range(nq):
#        v = qlabels[i]
#        w = corr[v][(corr[v]>0.9)]
#        w = list(w.index)
#        w.remove(v)
#        
#        if len(w)>0:
#            cont += 1;
#            
#            fig = plt.figure(cont)
#            z = datan[w]
#            
#            sns.pairplot(z)
#            
#            
#        for item in w:
#            if not(item in varc):
#                varc.append(item)
    
    # Plot high correlated variables