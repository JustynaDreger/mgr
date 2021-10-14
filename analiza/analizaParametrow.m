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
intervals = [0 10, %fa radosc
             10 20, %banderas podniecenie
             68 78, %allegro smutek
             5 15, %unicef smutek
             15 25, %torebki podniecenie
             4 14, %tymbark radosc
             16 26, %dkms smutek
             42 52, %pieski smutek i strach
             163 173, %kobiety smutek i strach
             5 15]; %lody radosc
         
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


% 1) Na początek proponuję policzyć pobudzenie (arousal) (z wykorzystaniem elektrod F3 i F4) z każdego filmu 
%dla każdego uczestnika i porównać z emocjami, które uczestnicy Ci raportowali.
%pobudzenie
arousal = {};
valence = {};
for i = 1:max(size(data))
    arousal{i} = calcArousal(bandsNorm{i});
    valence{i} = calcValence(bandsNorm{i});
end

plotEmotion(arousal, valence);
% 2) Następnie, jeżeli da się pogrupować filmy w jakieś 3-4 grupy emocjonalne (np. wywołujące radość, smutek i spokój), 
%to proponuję zrobić analizę wariancji (anova) i sprawdzić czy arousal wszystkich uczestników razem różni się istotnie 
%między tymi grupami. Jeżeli nie da się pogrupować filmów, to po prostu trzeba będzie wybrać np. 3 filmy o skrajnych emocjach, 
%zrobić na nich anovę, potem kolejne 3 filmy o innych emocjach i pozostałe 4. To może pozwolić na stwierdzenie, 
%czy na podstawie tego indeksu możemy wnioskować o rozpoznaniu emocji, które zgłasza uczestnik.
%
groups = [1 6 10; %radosc
    2 5 0; %podniecenie
    4 7 3; %smutek
    8 9 0; %strach
    ];
anovaArousal = {};
for i = 1:size(groups,1)
    anovaArousal{i} = calcAnova(arousal, groups(i,:),0);
end

anovaBetweenGroupsArousal = calcAnova(arousal, [1 9],0); %miedzy radosc i strach

% 3) Następnie te kroki trzeba będzie powtórzyć dla indeksu asymetrii (z elektrodami F3 i F4; F7 i F8; 
%oraz z wszystkimi z lewej i prawej półkuli). Ale to później, najpierw proszę zrobić arousal.
assymetry = {};
for i = 1:max(size(data))
    assymetry{i} = calcAssymetry(bandsNorm{i});
end
anovaAssymetry = {};
for i = 1:size(groups,1)
    anovaAssymetry{i} = calcAnova(assymetry, groups(i,:),1);
end
anovaBetweenGroupsAssymetry = calcAnova(assymetry, [2 9],1);