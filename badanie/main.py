# -*- coding: utf-8 -*-
"""
Created on Tue Jul 20 20:38:23 2021

@author: justyna

pyuic5 -x mgrTest.ui -o mgrTest.py
"""
"""
przygotuje Pan skrypt, którego zadaniem będzie odtworzenie wybranych
 filmów reklamowych. Między filmami powinien być ekran, z kilkoma etykietami
 emocji, spośród których uczestnik powinien wskazać te, które jego zdaniem wywołał dany film.
 Po nim powinien następować 2-gi ekran w którym zadaje Pani 3 pytania testowy na temat jakiś 
 szczegółów, które pojawiły się na filmie. Odpowiedzi poprawne powinny być zliczane, 
 a na zakończenie całego skryptu uczestnikowi powinna wyświetlać się informacja z jego wynikiem. 
 W celach motywacyjnych będzie Pani musiała przygotować sobie do badania np. zestaw cukierków i 
 wyraźnie na początku poinformować uczestnika, że musi  dokładnie oglądać filmy, 
 żeby odpowiedzieć na jak największą liczbę pytać i tym samym otrzymać nagrodę. 
 Oczywiście trzeba też ustalić, że np. za wszystkie bezbłędne odpowiedzi są 3 cukierki, 
 za dwie błędne 2, za 4 błędne 1, a za więcej - brak nagrody. 
 Przed rozpoczęciem 1-szego filmu potrzebujemy jeszcze zarejestrować sygnał w trakcie relaksu uczestnika, 
 więc w ciągu pierwszej minuty na ekranie musi być jakaś informacja o relaksie z zamkniętymi oczami, 
 w ciągu kolejnej minuty relaks z otwartymi oczami (przez całe dwie minuty powinna być jakaś relaksująca muzyka). 
 W trakcie każdej zmiany ekranu będzie Pani przesyłała informacje o zdarzeniu do systemu rejestrującego sygnał EEG,
 ale o tym napiszę Pani później jak przygotuje Pani skrypt.
"""
import sys
import time
import pandas as pd
from PyQt5 import QtCore, QtGui, QtWidgets, QtMultimedia, QtTest
from PyQt5.uic import loadUi
import mainWindow
import mgrTest

videoNum = 3
class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.ui = mainWindow.Ui_MainWindow()
        self.ui.setupUi(self)

        # PAGE 1
        self.ui.btnBegin.clicked.connect(self.relaxClose)
        self.ui.btnNext.clicked.connect(self.btnNextClicked)
        self.ui.btnNext_2.clicked.connect(self.btnNextClicked)

        #set video player
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
                print("started")
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
                print("finished")
                self.musicPlayer.stateChanged.connect(musicStateChangedOpen)
                self.relaxOpen()
        def musicStateChangedOpen(state):
            if state == QtMultimedia.QMediaPlayer.PlayingState:
                print("started")
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
                print("finished")
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
                self.playVideo()
        self.musicPlayer.stateChanged.connect(musicStateChangedClose)
        self.musicPlayer2 = QtMultimedia.QMediaPlayer()
        self.musicPlayer2.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("music/Sleep_Mountain.mp3")))
        self.musicPlayer2.stateChanged.connect(musicStateChangedOpen)
        
        self.currentVideo = 1
        
        self.data = pd.DataFrame(columns=["videoID","questionID","answer"])
        self.answers = self.data.copy()
        
        self.show()
    
    def relaxClose(self):
        print("closeTUUUUUUUUU")
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_1)
        self.musicPlayer.play()
        #QtTest.QTest.qWait(60000)
        
        
    def relaxOpen(self):
        print("openTUUUU")
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_2)
        self.musicPlayer2.play()
        
        
    def playVideo(self):
        self.player.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("videos/videoplayback.mp4")))
        self.player.play()
    
    def emotion(self):
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_4)

    def btnNextClicked(self):
        if self.ui.stackedWidget.currentIndex() == 4:
            for box in self.ui.groupBoxEmotion1.findChildren(QtWidgets.QCheckBox):
                if box.isChecked():
                    self.data = self.data.append({"videoID":self.currentVideo,"questionID":1,"answer":box.objectName()[8:]}, ignore_index=True)
                    box.setChecked(False)
            self.ui.stackedWidget.setCurrentWidget(self.ui.page_5)
            
        else:
            if self.currentVideo != videoNum:
                
                self.checkAnswers()                       
                self.currentVideo = self.currentVideo + 1
                self.ui.labelVideoNum_1.setText("Film "+str(self.currentVideo))
                self.ui.labelVideoNum_2.setText("Film "+str(self.currentVideo))
                self.ui.labelVideoNum_3.setText("Film "+str(self.currentVideo))
                self.ui.label_num.setText(str(self.currentVideo)+"/"+str(videoNum))
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
                self.playVideo()
            else:
                self.saveData()
                self.checkAnswers()
                self.sumAnswers()
                print(self.answers)
                self.ui.stackedWidget.setCurrentWidget(self.ui.page_6)
           
    def saveData(self):
        print("Zapis danych")
        self.data.to_csv("answers.csv")
    
    def checkAnswers(self):
        for radio in self.ui.page_5.findChildren(QtWidgets.QRadioButton):
            if radio.isChecked():
                self.answers = self.answers.append({"videoID":self.currentVideo,"questionID":radio.objectName()[-2],"answer":radio.objectName()[-2:]}, ignore_index=True)
                radio.setAutoExclusive(False)
                radio.setChecked(False)
                radio.setAutoExclusive(True)
    
    def sumAnswers(self):
        pass
    
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())