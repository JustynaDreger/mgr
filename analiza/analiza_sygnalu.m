clc
close all
clear all

%wczytanie danych
data = load('dane/REGISTER_2021-8-18_13-35-29_dane_wynikowe.mat');
signal = data.dane_wynikowe.EEG_signal;

Fs = data.dane_wynikowe.OpisEXP.Fs; %czestotliwosc probkowania sygnalu (500Hz)

%podzielic dane dla kazdego etapu
events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy epok z czasem ich rozpoczecia
time = data.dane_wynikowe.EEG_time;
% eventsTime = [];
% for i=1:length(events)
%     i
%     eventsTime = [eventsTime;seconds(str2num(cell2mat(events(i,1))))]% seconds(str2num(cell2mat(events(i+1,1))))]; %czas trwania kazdej epoki - s
% end
% t = round(seconds(diff(eventsTime(:,1))),3)
% %ile probek w epoce
% sampleNumPerEvent = floor(Fs*t);
eventSignal = {};
for i=2:length(events)
    eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))))
end
%wybrac dane dla kalibracji i dla kazdego video

%przeanalizowac sygnal zgodnie z algorytmem