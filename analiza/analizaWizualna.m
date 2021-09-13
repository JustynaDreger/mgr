clc
close all
clear all

%skrypt do analizy sygnalow EEG pod katem emocji
catalog = 'dane/eeg/';
paths = dir(catalog); %katalog z danymi

%wczytanie danych i podzial
data = {};
it = 1;
for i = 1:size(paths,1)
    if paths(i).name ~= "." & paths(i).name ~= ".."
        data{it} = readData(strcat(catalog,paths(i).name));
        it = it + 1;
    end
end

%analiza graficzna
%poczatek i koniec fragmentu w sekundach
intervals = [0 10, %fa
             10 20, %banderas
             68 78, %allegro
             5 15, %unicef
             15 25, %torebki
             4 14, %tymbark
             16 26, %dkms
             42 52, %pieski
             163 173, %kobiety
             5 15]; %lody
         
%wybranie fragmentu z sygnalu
signals = {};
for i = 1:max(size(data))
    signals{i} = getParts(data{i},intervals, 500);
end
%obliczenie mocy
frames = {};
for i = 1:max(size(data))
    frames{i} = dividePerFrames(signals{i},10,500); %dane do podzialu, rozmiar okna (s), czestotliwosc fs
end
for i = 1:max(size(data)) %petla po badanych
    bands{i} = calcBandPower(frames{i}, 500); %dane w oknach, czestotliwosc fs
end

%wykresy
for i = 1:max(size(data)) %petla po badanych
    plotsPerPerson(bands{i},i);
end

for i = 1:max(size(intervals)) %petla po filmach
    sigVideo = cellfun(@(v)v(i),bands);
    plotsPerVideo(sigVideo,i);
end

for i = 1:size(bands{1}{1},1)% petla po kanalach
    for j =1:size(bands{1}{1},2) %petla po pasmach
        temp = plotsPerChannelBand(bands,i,j);
    end
end