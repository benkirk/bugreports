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


times = defaultdict(list)
paths = set()
hosts = set()
fname2path = {}


dfs = {}

def load_data():
    alltimes = set()
    
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
        hosts.add(host)
        paths.add(path)
        fname2path[filename] = path
        
        #print(host, path)    
        
        df = pd.read_csv(filename,
                         skipinitialspace=True,
                         dtype=dtype,
                         comment='#',
                         parse_dates=['Date'],
                        )
        df.set_index('Date',inplace=True)

        dfs[filename] = df
    
        alltimes.update(set(df['Elapsed(s)'].to_list()))
        
        times[path].extend(df['Elapsed(s)'].to_list())
        
        #fastest = np.max(fastest,df['Elapsed(s)'].max())
        #print(fastest)
        #display(df)
        #display(df.info(memory_usage=True))
    
        #print(pd.to_datetime(df.iloc[-1]))
        #break
    
    return (min(alltimes), max(alltimes)) 

fastest, slowest = load_data()


# In[ ]:


import ipywidgets as widgets
def selection(list=None,selected=None):
    if not selected:
        selected=list
    w = widgets.SelectMultiple(options=sorted(list),
                               value=selected,
                               rows=len(list),
                               description='CSVs',
                               layout={'width': 'initial'},
                               disabled=False)
    display(w)
    return w

sel = selection(list(times.keys()),
               selected=[x for x in list(times.keys()) if 'foobar' not in x] )


# In[ ]:


print(sel.value)


# In[ ]:


def histogram(items):
    
    fig, ax = plt.subplots(1, 1,
                           figsize=(12,6))
    format_ax(ax)
    
    
    bins = np.linspace(fastest, slowest, 11)
    #print(bins)
    
    ts = list()
    ls = list()
    
    for p in items:
        assert p in times
        t = times[p]
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
    return


# In[ ]:


histogram(sel.value)


# In[ ]:


def history(items):

    selected = set(items)
    
    fig, ax = plt.subplots(1, 1,
                           figsize=(12,6))
    format_ax(ax)

    colors = {}
    
    for k,df in dfs.items():        
        #print(k)
        p = fname2path[k]
        if p not in items: continue
        p = p.replace('/benkirk/git_clone_tests','')
        #print(p)
        #print(df)
        for t in df.index:
            start = t
            duration = df.loc[t,'Elapsed(s)']
            end = start + pd.to_timedelta(duration, unit='seconds')
            #print(start,duration, end)
            l = ax.plot([start, end], 
                        [duration, duration], 
                        color=colors[p] if p in colors else None,
                        label=p if p not in colors else None,
                        linewidth=4)
            
            colors[p] = l[0].get_color()

    ax.set_ylim(0, slowest*1.05)
    ax.set_ylabel('CESM clone time (s)')
    ax.set_title('CESM git clone + ./manage_externals/checkout_externals')
    ax.set_xlabel('Date & Time')
    ax.legend(fancybox=True, loc=2)
    ax.tick_params(axis='x', labelrotation=60)
    
    plt.show()
    plt.close()
    return


# In[ ]:


history(sel.value)


# In[ ]:





# In[ ]:




