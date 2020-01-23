## ----setup, include=!FALSE, echo=FALSE---------
knitr::opts_chunk$set(echo = TRUE, cache = !T)
library(reticulate)


## import statistics as st

## import numpy as np

## import seaborn as sb

## import matplotlib.pyplot as plt

## import pandas as pd

## import scipy as sp


## nums = [-2,-4,1,2,3,5,7,9]

## st.mean(nums)


## Dict = {1:"one",2:"two",3:"three"}

## 
## Dict

## 
## st.mean(Dict)


## nums = [-2,-4,1,2,3,5,7,9]

## st.median(nums)


## Dict = {1:"one",2:"two",3:"three"}

## 
## st.median(Dict)


## nums = [-2,-4,1,2,3,5,7,9]

## st.mode(nums)

## 
## ## StatisticsError: no unique mode; found 8 equally common values

## ##

## ## Detailed traceback:

## ##   File "<string>", line 1, in <module>

## ##   File "C:\Users\Aubur\Anaconda3\lib\statistics.py", line 506, in mode

## ##     'no unique mode; found %d equally common values' % len(table)


## max(nums) - min(nums)


## st.variance(nums)


## st.variance(Dict)


## st.stdev(nums)


## st.stdev(Dict)


## N_obs = 4000

## 
## normal = np.random.normal(loc = 1, scale = 10000, size = N_obs)

## 
## lognormal = np.random.lognormal(mean = 10, sigma = .75, size = N_obs)


## d = {'normal': normal, 'lognormal': lognormal}

## d


## df = pd.DataFrame(data = d)


## df.head(10)


## # Settings

## sb.set_style("whitegrid")

## 
## # Create histogram

## plot = sb.distplot(df['normal'],

##                    kde = False,

##                    bins = int(N_obs / 10),

##                    axlabel = "x NOR(0,1)")

## 
## # add vertical line showing the location of the mean, median

## plot = plt.axvline(df['normal'].mean(),   0,1, color = 'red')

## plot = plt.axvline(df['normal'].median(), 0,1, color = 'orange')

## 
## plt.show(plot)


## # Create histogram

## plot = sb.distplot(df['lognormal'],

##                    kde = False,

##                    bins = int(N_obs / 10),

##                    axlabel = "x LOGNOR(10,0.75)")

## 
## # add vertical line showing the location of the mean, median

## plot = plt.axvline(df['lognormal'].mean(),   0,1, color = 'red')

## plot = plt.axvline(df['lognormal'].median(), 0,1, color = 'orange')

## 
## plt.show(plot)


## plot = sb.boxplot(data = df)

## 
## plt.show(plot)


## sb.jointplot("normal","lognormal", data = df)

## 
## plt.show()


## plot = sb.jointplot("lognormal","lognormal", data = df)

## 
## plt.show(plot)


## cov1 = df.cov()

## cov1


## df.corr()


## X = df['normal']

## Y = df['lognormal']

## X_diff = X - st.mean(X)

## Y_diff = Y - st.mean(Y)

## prod = X_diff * Y_diff

## 
## cov2 = sum(prod) / (len(X) - 1)

## 
## cov1['lognormal'][0] - cov2

