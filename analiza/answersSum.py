# -*- coding: utf-8 -*-
"""
Created on Thu Oct  7 13:22:00 2021

@author: justyna
"""

import glob
import os
import pandas as pd

correct = pd.read_csv("questions.csv", sep=";")

files = glob.glob(os.path.join('', "dane/answers/answers/*.csv"))

it = 1
for file in files:
    cor = 0
    data = pd.read_csv(file, sep=",")
    for video in range(1,11):
        for q in range(1,4):
            
            temp1 = data["answer"][(data["videoID"]==video) & (data["questionID"]==q)].to_list()
            if temp1 != []:
                temp1 = temp1[0]
            temp2 = correct["correct"][(correct["videoID"]==video) & (correct["questionID"]==q)].to_list()[0]

            if temp1 == temp2:
               cor = cor + 1
    print("Badany: "+str(it)+" pkt: " + str(cor))
    it = it + 1
