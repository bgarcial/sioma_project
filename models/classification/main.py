# -*- coding: utf-8 -*-
"""
Archivo principal
"""

import read_data as rd
import prep as pp
import random
import cluster

# Set a seed
random.seed(10000)

# Specify filename
fname = 'CompletoAllInputsOutput_28_weeks_RawData.csv'

# Read data and create dummy variables
n, data, labels, clabels, qlabels = rd.rdata(fname)

# Scale data to 0-1
datan = rd.sdata(data, qlabels, n)

# Split percentages
pe = 0.7
pv = 0.2
pt = 0.1

# Samples of validation, test and training
ne, nv, ind_e, ind_v, ind_t = rd.slists(n, pe, pv)

# Split data and scaled data
data_e, data_v, data_t, datan_e, datan_v, datan_t = rd.datasplit(data, datan, ind_e, ind_v, ind_t)

# Descriptive statistics
des = data[qlabels].describe()

# Correlation matrix
corr = data[qlabels].corr()

# Initial plots
nq = len(qlabels)
npl = 6

# Scatter plots
pp.plots(data, qlabels, npl, nq)

# Variable of interest
ylabel = 'peso'

# Correlation percentage
cp = 0.9;

# Drop variables with high correlation
cc = 4

# Plot variables vs peso
z, c, lv = pp.plotsc(datan, qlabels, ylabel, nq, npl, cp, cc)

# ylabels for classification
ylabels = []
"""
0: Pequeño (0-15)
1: Mediano (15-23)
2: Grande (23-)
"""

for i in range(n):
    if data[ylabel].iloc[i] < 15:
        ylabels.append(0)
    elif data[ylabel].iloc[i]>=15 and data[ylabel].iloc[i]<23:
        ylabels.append(1)
    elif data[ylabel].iloc[i]>=23: 
        ylabels.append(2)


# Cluster Analysis
