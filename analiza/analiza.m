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

%podzial na okna
frames = {};
for i = 1:max(size(data))
    frames{i} = dividePerFrames(data{i},2,500); %dane do podzialu, rozmiar okna (s), czestotliwosc fs
end

%liczenie mocy pasmowej
for i = 1:max(size(data)) %petla po badanych
    bands{i} = calcBandPower(frames{i}, 500); %dane w oknach, czestotliwosc fs
end
