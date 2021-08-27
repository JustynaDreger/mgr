clc
close all
clear all

%wczytanie danych
data = load('dane/eeg/REGISTER_2021-8-18_13-35-29_dane_wynikowe.mat');
signal = data.dane_wynikowe.EEG_signal;

Fs = data.dane_wynikowe.OpisEXP.Fs; %czestotliwosc probkowania sygnalu (500Hz)

%podzielic dane dla kazdego etapu
events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy epok z czasem ich rozpoczecia
time = data.dane_wynikowe.EEG_time;
% %ile probek w epoce
eventSignal = {};
for i=2:length(events)
    eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
end
%wybrac dane dla kalibracji i dla kazdego video
signalCalibrationClose = eventSignal{2};
signalCalibrationOpen = eventSignal{3};
signalVideo = {};
it = 1;
for i = 4:3:33
    signalVideo{it} = eventSignal{i};
    it = it + 1;
end
%przeanalizowac sygnal zgodnie z algorytmem
%odszumianie
plot(signalCalibrationClose(1,:))
%filtracja pasmowa
signalDelta = filtr(signalCalibrationClose,0.5,4,500);
signalTheta = filtr(signalCalibrationClose,4,8,500);
signalAlpha = filtr(signalCalibrationClose,8,13,500);
signalBeta = filtr(signalCalibrationClose,13,30,500);
signalGamma = filtr(signalCalibrationClose,30,100,500);
figure(2)
plot(signalDelta(1,:))
%wyznaczenie wskaznikow