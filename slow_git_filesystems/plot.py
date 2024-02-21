#!/usr/bin/env python
# coding: utf-8

# # Plot user storage history

# In[ ]:


import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager
import pandas as pd
from collections import defaultdict
import sys
import yaml
import math
import glob
import os
import json
from tqdm.notebook import tqdm
from IPython.display import display,Image
from datetime import date
from ncar_branding import *

# Unit Conversions
kb2mb = 1000
kb2gb = 1000*kb2mb
kb2tb = 1000*kb2gb


# In[ ]:





# In[ ]:


fig, ax = plt.subplots(1, 1,
                       figsize=(12,6))
format_ax(ax)

times = defaultdict(list)
fastest = None
slowest = None

for filename in tqdm(glob.glob('logs/*.csv'), 
                     desc='Processing CSVs',
                     unit='file'): 

    dtype= {'Elapsed(s)'  : 'Int64',}

    #print(filename)
    host = None
    path = None
    with open(filename,'r') as f:
        for line in f:
            if '# ' in line:
                line=line.strip().split()
                #print(line[1], line[3])
                host = line[1]
                path = line[3]
                break

    assert host
    assert path
    
    #print(host, path)    
    
    df = pd.read_csv(filename,
                     skipinitialspace=True,
                     dtype=dtype,
                     comment='#',
                     parse_dates=['Date'],
                    )
    df.set_index('Date',inplace=True)

    max_s = df['Elapsed(s)'].max()
    min_s = df['Elapsed(s)'].min()
    if not fastest: fastest = min_s
    if not slowest: slowest = max_s

    fastest = min(fastest, min_s)
    slowest = max(slowest, max_s)

    times[path].extend(df['Elapsed(s)'].to_list())
    
    #fastest = np.max(fastest,df['Elapsed(s)'].max())
    #print(fastest)
    #display(df)
    #display(df.info(memory_usage=True))

    #print(pd.to_datetime(df.iloc[-1]))
    #break

print(fastest, slowest)

bins = np.linspace(fastest, slowest, 11)
print(bins)

ts = list()
ls = list()

for p,t in times.items():
    ts.append(t)
    ls.append(p.replace('/benkirk/git_clone_tests',''))

ax.hist(ts, bins=bins,
        zorder=10,
        alpha=1,
        stacked=True,
        label=ls),

ax.set_xlim(fastest, slowest)
ax.set_xlabel('CESM "git clone + /manage_externals/checkout_externals" time (s)')
ax.set_ylabel('Count (#)')
ax.legend(fancybox=True, loc=1)


plt.show()
plt.close()


# In[ ]:




