#!/usr/bin/env python
"""
========
Ctang, A bar plot of time variability changes projection 
        from CORDEX AFR-44, in Southern Africa
        Data was restored on titan
========
"""
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

import pandas as pd

import textwrap
import datetime
import ctang

from mpl_toolkits.basemap import Basemap 

from matplotlib.ticker import AutoMinorLocator
from matplotlib.dates import DayLocator, HourLocator, DateFormatter, drange

import math
from scipy import stats
import subprocess

plt.close('all')

#=================================================== pre-defined
VAR='ssrd'
#=================================================== 

# input file
DJF='ssrd.clt.season.fldcor.DJF.nc'
JJA='ssrd.clt.season.fldcor.JJA.nc'
COR='ssrd.clt.season.fldcor.nc'

#=================================================== read
# read time series
TIME_DJF=ctang.get_netcdf_time(DJF)
TIME_JJA=ctang.get_netcdf_time(JJA)

# read correlation
COR_DJF=ctang.read_time_netcdf(VAR,DJF)
COR_JJA=ctang.read_time_netcdf(VAR,JJA)

#=================================================== 
# define subplots
fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(12,7),\
        facecolor='w', edgecolor='k') # figsize=(w,h)

# set limits
# ax.set_xlim( dates[0], dates[-1] )

# set grid
ax.yaxis.grid(color='gray', linestyle='dashed')
ax.xaxis.grid(color='gray', linestyle='dashed')

# set title
ax.set_xlabel('time', fontsize=12)
ax.set_ylabel('Correlation of CLT vs SSR', fontsize=12)

# big title
Title='Seasonal series of fldcor of CLT vs SSR over SA between 1983-2005'
plt.suptitle(Title)

# The hour locator takes the hour or sequence of hours you want to
# tick, not the base multiple

ax.xaxis.set_major_formatter( DateFormatter('%Y') )
ax.fmt_xdata = DateFormatter('%Y')
fig.autofmt_xdate()

#=================================================== plot

ax.plot(TIME_DJF,COR_DJF,label='DJF',color='b')
ax.plot(TIME_DJF,COR_JJA,label='JJA',color='r')
#=================================================== others
ax.legend()

#=================================================== output

# save image
Out_Image='seasonal.series.fldcor'

plt.savefig(Out_Image+'.eps',format='eps')
plt.savefig(Out_Image+'.png')

plt.show()
