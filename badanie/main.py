# -*- coding: utf-8 -*-
"""
Created on Tue Jul 20 20:38:23 2021

@author: justyna

pyuic5 -x mgrTest.ui -o mgrTest.py
"""

import sys
import time
import winsound
import pandas as pd
from PyQt5 import QtCore, QtGui, QtWidgets, QtMultimedia, QtTest
from PyQt5.uic import loadUi
import mainWindow
import mgrTest

#liczba reklam
videoNum = 10
class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.ui = mainWindow.Ui_MainWindow()
        self.ui.setupUi(self)

        #
        self.ui.btnBegin.clicked.connect(self.relaxClose)
        self.ui.btnNext.clicked.connect(self.btnNextClicked)
        self.ui.btnNext_2.clicked.connect(self.btnNextClicked)

        #
        self.player = QtMultimedia.QMediaPlayer()
        self.player.setVideoOutput(self.ui.videoPlayer)
        
        def videoStateChanged(state):
            if state == QtMultimedia.QMediaPlayer.PlayingState:
                print("started")
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
                print("finished")
                self.emotion()
                
        self.player.stateChanged.connect(videoStateChanged)
        
        self.musicPlayer = QtMultimedia.QMediaPlayer()
        self.musicPlayer.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("music/Sleep_Mountain.mp3")))
        
        def musicStateChangedClose(state):
            if state == QtMultimedia.QMediaPlayer.PlayingState:
                #print("started")
                pass
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
               # print("finished")
                self.musicPlayer.stateChanged.connect(musicStateChangedOpen)
                duration = 100  # milliseconds
                freq = 440  # Hz
                winsound.Beep(freq, duration)
                self.relaxOpen()
                
        def musicStateChangedOpen(state):
            if state == QtMultimedia.QMediaPlayer.PlayingState:
                #print("started")
                pass
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
                #print("finished")
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
                self.playVideo()
                
        self.musicPlayer.stateChanged.connect(musicStateChangedClose)
        self.musicPlayer2 = QtMultimedia.QMediaPlayer()
        self.musicPlayer2.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("music/puung.mp3")))
        self.musicPlayer2.stateChanged.connect(musicStateChangedOpen)
        
        self.currentVideo = 1
        
        self.data = pd.DataFrame(columns=["videoID","answer"])
        self.answers = self.data.copy()
        self.questions = pd.read_csv("questions.csv", sep=";")
        #print(self.questions)
        
        self.show()
    
    def relaxClose(self):
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_1)
        self.musicPlayer.play()
        
        
    def relaxOpen(self):
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_2)
        self.musicPlayer2.play()
        
        
    def playVideo(self):
        self.player.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("videos/"+str(self.currentVideo)+".mp4")))
        self.player.play()
    
    def emotion(self):
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_4)

    def btnNextClicked(self):
        if self.ui.stackedWidget.currentIndex() == 4:
            for box in self.ui.groupBoxEmotion1.findChildren(QtWidgets.QCheckBox):
                if box.isChecked():
                    self.data = self.data.append({"videoID":self.currentVideo,"answer":box.objectName()[8:]}, ignore_index=True)
                    box.setChecked(False)
            self.setQuestions()
            self.ui.stackedWidget.setCurrentWidget(self.ui.page_5)
            
        else:
            if self.currentVideo != videoNum:
                self.getAnswers()                       
                self.currentVideo = self.currentVideo + 1
                self.ui.labelVideoNum_1.setText("Film "+str(self.currentVideo))
                self.ui.labelVideoNum_2.setText("Film "+str(self.currentVideo))
                self.ui.labelVideoNum_3.setText("Film "+str(self.currentVideo))
                self.ui.label_num.setText(str(self.currentVideo)+"/"+str(videoNum))
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
                self.playVideo()
            else:
                self.saveData()
                self.getAnswers()
                self.sumAnswers()
                #print(self.answers)
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_6)
                
    def setQuestions(self):
        question = self.questions[self.questions["videoID"]==self.currentVideo]
        self.ui.label_q1.setText(question["question"].iloc[0])
        self.ui.label_q2.setText(question["question"].iloc[1])
        self.ui.label_q3.setText(question["question"].iloc[2])
        #odp A
        self.ui.radioButtonQ1A.setText(question["ansA"].iloc[0])
        self.ui.radioButtonQ2A.setText(question["ansA"].iloc[1])
        self.ui.radioButtonQ3A.setText(question["ansA"].iloc[2])
        #odp B
        self.ui.radioButtonQ1B.setText(question["ansB"].iloc[0])
        self.ui.radioButtonQ2B.setText(question["ansB"].iloc[1])
        self.ui.radioButtonQ3B.setText(question["ansB"].iloc[2])
        #odp C
        self.ui.radioButtonQ1C.setText(question["ansC"].iloc[0])
        self.ui.radioButtonQ2C.setText(question["ansC"].iloc[1])
        self.ui.radioButtonQ3C.setText(question["ansC"].iloc[2])
        #odp D
        self.ui.radioButtonQ1D.setText(question["ansD"].iloc[0])
        self.ui.radioButtonQ2D.setText(question["ansD"].iloc[1])
        self.ui.radioButtonQ3D.setText(question["ansD"].iloc[2])
        
    def saveData(self):
        print("Zapis danych")
        self.data.to_csv("data.csv")#zapis odpowiedzi o emocje
        self.answers.to_csv("answers.csv")#zapis odpowiedzi do reklam
    
    def getAnswers(self):
       
        for radio in self.ui.page_5.findChildren(QtWidgets.QRadioButton):
            if radio.isChecked():
                self.answers = self.answers.append({"videoID":self.currentVideo,"questionID":radio.objectName()[-2],"answer":radio.text()}, ignore_index=True)
                #print(self.answers)
                radio.setAutoExclusive(False)
                radio.setChecked(False)
                radio.setAutoExclusive(True)
    
    def sumAnswers(self):
        correct = 0
        for i in range(0,len(self.questions)):
            if self.questions["correct"].iloc[i]==self.answers["answer"].iloc[i]:
                correct = correct + 1
        self.ui.label_Points.setText(str(correct)+"/"+str(videoNum*3))
    
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())