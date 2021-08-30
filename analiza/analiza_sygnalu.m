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

%filtracja pasmowa
signalDelta = {};
signalTheta = {};
signalAlpha = {};
signalBeta = {};
signalGamma = {};
for i = 1:max(size(signalVideo))
    signalDelta{i} = filtr(signalVideo{i},0.5,4,500);
    signalTheta{i} = filtr(signalVideo{i},4,8,500);
    signalAlpha{i} = filtr(signalVideo{i},8,13,500);
    signalBeta{i} = filtr(signalVideo{i},13,30,500);
    signalGamma{i} = filtr(signalVideo{i},30,100,500);
end
%wyznaczenie wskaznikow
alphaPower = {};
betaPower = {};
gammaPower = {};
deltaPower = {};
thetaPower = {};
for i = 1:max(size(signalVideo))
    alphaPower{i} = bandpower(signalAlpha{i}');
    betaPower{i} = bandpower(signalBeta{i}');
    gammaPower{i} = bandpower(signalGamma{i}');
    deltaPower{i} = bandpower(signalDelta{i}');
    thetaPower{i} = bandpower(signalTheta{i}');
end
aurosalBA = []; % wzor 2.3
valence = []; % wzor 2.1
asymmetryF4F3 = []; %wzor 2.6
asymmetryF8F7 = []; %wzor 2.7
figure
hold on
for i = 1:max(size(signalVideo))
    aurosalBA(i) = (betaPower{i}(1,6)+betaPower{i}(1,4))./(alphaPower{i}(1,6)+alphaPower{i}(1,4));
    valence(i) = (alphaPower{i}(1,6)/betaPower{i}(1,6)) - (alphaPower{i}(1,4)/betaPower{i}(1,4));
    plot(valence(i), aurosalBA(i),'*');
    text(valence(i), aurosalBA(i),int2str(i),'VerticalAlignment','top','HorizontalAlignment','left')
    
    asymmetryF4F3(i) = log(alphaPower{i}(1,6)) - log(alphaPower{i}(1,4));
    asymmetryF8F7(i) = log(alphaPower{i}(1,7)) - log(alphaPower{i}(1,3));
    
end
figure
subplot(4,1,1)
plot(valence)
subplot(4,1,2)
plot(aurosalBA)
subplot(4,1,3)
plot(asymmetryF4F3)
subplot(4,1,4)
plot(asymmetryF8F7)