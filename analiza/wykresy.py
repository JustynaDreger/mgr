# -*- coding: utf-8 -*-
"""
Created on Wed Aug 25 11:43:00 2021

@author: justyna
"""

import glob
import os
import pandas as pd

data = pd.concat(map(pd.read_csv, glob.glob(os.path.join('', "dane/answers/data/*.csv"))))
data = data.drop(columns=['Unnamed: 0'])
labelOrigin = ["Happy","Angry","Sad","Fear","Disgust","Suprised","Excited","Calm"]
labelPlot = ["radość","złość","smutek","strach","wstręt","zaskoczenie","podniecenie","spokój/obojętne"]

for an,pl in zip(labelOrigin,labelPlot):
    data["answer"][data["answer"]==an] = pl

for i in range(1,11):
    dataVideo = data[data["videoID"]==i].groupby(['answer']).agg(['count'])
    dataVideo.plot.bar(legend=False, title="Reklama nr "+str(i),xlabel="Emocje",ylabel="Liczba odpowiedzi",rot=0)
    