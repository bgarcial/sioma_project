# -*- coding: utf-8 -*-
"""
Leer los datos
"""

import pandas as pd
import random

# Set a seed
random.seed(10000)

def rdata(fname):
    """
    Reads stored data in a CSV file
    """
    # Read data
    data = pd.read_csv(fname,sep=',',decimal='.')
    
    # Filter by rows without NAN
    data = data.dropna()
    
    # Number of samples
    n = len(data)
    # Create dummy variables for Wind Direction
    wd = list(set(data.Direccion))
    
    for w in wd:
        data[w]=1*(data['Direccion']==w)
    
    # Get labels
    labels = list(data.columns)
    # Caregorical labels
    clabels = wd + ['Direccion']
    # Numerical labels
    qlabels = list(filter(lambda x: x not in clabels, labels))
    
    return n, data, labels, clabels, qlabels

# Function to scale data ...
def sdata(data, qlabels, n):
    """
    Normalize and split data
    """
    # Create a copy to normalize data
    datan = data.copy()
    
    # Scaler
    # Itera sobre las etiquetas numericas
    for l in qlabels:
        # Aplican escalamiento de maxims y minimos a los datos puros
        # https://sebastianraschka.com/Articles/2014_about_feature_scaling.html#about-min-max-scaling
        datan[l] = (datan[l]-datan[l].min())/(datan[l].max()-datan[l].min())
        
    return datan

def slists(n, pe, pv):
    """
    Split lists
    """
    # Split data: Training, validation and test
    random.seed(10000)
    # iteran sobre la longitud de 4553 muestras
    ind = list(range(n))
    # Escogen aleatorias 
    ind = random.sample(ind, n)

    # QUE SIGNIFICA ESTO
    ne = int(n*pe)
    nv = int(n*pv)
    
    ind_e = ind[0:ne]
    ind_v = ind[ne:ne+nv]
    ind_t = ind[ne+nv:]
    
    return ne, nv, ind_e, ind_v, ind_t

def datasplit(data, datan, ind_e, ind_v, ind_t):
    # Split data
    data_e = data.iloc[ind_e]
    data_v = data.iloc[ind_v]
    data_t = data.iloc[ind_t]
    
    datan_e = datan.iloc[ind_e]
    datan_v = datan.iloc[ind_v]
    datan_t = datan.iloc[ind_t]
    
    return data_e, data_v, data_t, datan_e, datan_v, datan_t
