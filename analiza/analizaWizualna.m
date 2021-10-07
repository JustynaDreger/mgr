clc
close all
clear all

%skrypt do analizy sygnalow EEG pod katem emocji
catalog = 'dane/eeg/';
paths = dir(catalog); %katalog z danymi

%wczytanie danych i podzial
data = {};
calibration = {};
it = 1;

for i = 1:size(paths,1)
    if paths(i).name ~= "." & paths(i).name ~= ".."
        [calibration{it}, data{it}] = readDataWithCalibration(strcat(catalog,paths(i).name),i);
        it = it + 1;
    end
end

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
    signals{i} = getParts(data{i},intervals, 500,0);
end
intervals = [45 55];
signalsCal = {};
for i = 1:max(size(calibration))
    signalsCal{i} = getParts(calibration{i},intervals, 500,1);
end

%obliczenie mocy
frames = {};
framesCal = {};
for i = 1:max(size(data))
    frames{i} = dividePerFrames(signals{i},10,500,0); %dane do podzialu, rozmiar okna (s), czestotliwosc fs
    framesCal{i} = dividePerFrames(signalsCal{i},10,500,1);
end
for i = 1:max(size(data)) %petla po badanych
    bands{i} = calcBandPower(frames{i}, 500,0); %dane w oknach, czestotliwosc fs
    bandsCal{i} = calcBandPower(framesCal{i}, 500,1);
end

%normalizacja
bandsNorm = {};
for i = 1:max(size(data))
    bandsNorm{i} = normalization(bands{i},bandsCal{i});
end



%wykresy
% for i = 1:max(size(data)) %petla po badanych
%     plotsPerPerson(bands{i},i);
% end

% for i = 1:max(size(intervals)) %petla po filmach
%     sigVideo = cellfun(@(v)v(i),bands);
%     plotsPerVideo(sigVideo,i);
% end
% 
for i = 1:size(bands{1}{1},1)% petla po kanalach
    for j =1:size(bands{1}{1},2) %petla po pasmach
        temp = plotsPerChannelBand(bands,i,j);
    end
end