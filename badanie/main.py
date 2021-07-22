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

        #set video player
        self.player = QtMultimedia.QMediaPlayer()
        self.player.setVideoOutput(self.ui.videoPlayer)
        def handle_state_changed(state):
            if state == QtMultimedia.QMediaPlayer.PlayingState:
                print("started")
            elif state == QtMultimedia.QMediaPlayer.StoppedState:
                print("finished")
                self.emotion()
        self.player.stateChanged.connect(handle_state_changed)
        
        self.currentVideo = 1
        
        self.show()
    
    def relaxClose(self):
        print("close")
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_1)
        QtTest.QTest.qWait(60000)
        self.relaxOpen()
        
    def relaxOpen(self):
        print("open")
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_2)
        QtTest.QTest.qWait(60000)
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
        self.playVideo()
        
    def playVideo(self):
        self.player.setMedia(QtMultimedia.QMediaContent(QtCore.QUrl.fromLocalFile("videos/videoplayback.mp4")))
        self.player.play()
    
    def emotion(self):
        self.ui.stackedWidget.setCurrentWidget(self.ui.page_4)

    def btnNextClicked(self):
        if self.currentVideo != videoNum:
            self.currentVideo = self.currentVideo + 1
            self.ui.labelVideoNum_1.setText("Film "+str(self.currentVideo))
            self.ui.stackedWidget.setCurrentWidget(self.ui.page_3)
            self.playVideo()
            

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())