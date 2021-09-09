clc
close all
clear all

catalog = 'dane/eeg/';
paths = dir(catalog); %katalog z danymi

for i = 1:size(paths,1)
    if paths(i).name ~= "." & paths(i).name ~= ".." & i ~= 12
        figure('units','normalized','outerposition',[0 0 1 1])
        data = load(strcat(catalog,paths(i).name));
        signal = data.dane_wynikowe.EEG_signal;
        for channel=1:size(signal,1)
            subplot(5,4,channel)
            plot(signal(channel,:));
            
        end
        %przetworzenie
            for channel=1:size(signal,1)
                if i == 11 %dla badanego nr 9
                     prc10 = prctile(signal(channel,:),3);
                     prc90 = prctile(signal(channel,:),97);
                     
                     signal(channel, signal(channel,:)<prc10) = prc10;
                     signal(channel, signal(channel,:)>prc90) = prc90;
                end
                buff = 500;
                [pks,locsMax] = findpeaks(signal(channel,:),'SortStr','descend', 'NPeaks',10, 'MinPeakDistance',buff);
                [pks,locsMin] = findpeaks(-signal(channel,:),'SortStr','descend', 'NPeaks',10, 'MinPeakDistance',buff);
                sig = signal(channel,:);
                sig(locsMax) = [];
                sig(locsMin) = [];
                m = mean(sig)
                for loc = locsMax
                    if loc-buff>1
                        lMin = loc-buff;
                    else
                        lMin = 1;
                    end
                    if loc+buff>size(signal, 2)
                        lMax = size(signal, 2);
                    else
                        lMax = loc+buff;
                    end
                    signal(channel,lMin:lMax) = m;    
                end
                for loc = locsMin
                    if loc-buff>1
                        lMin = loc-buff;
                    else
                        lMin = 1;
                    end
                    if loc+buff>size(signal, 2)
                        lMax = size(signal, 2);
                    else
                        lMax = loc+buff;
                    end
                    signal(channel,lMin:lMax) = m;    
                end
            end
        
        figure('units','normalized','outerposition',[0 0 1 1])
        for channel=1:size(signal,1)
            subplot(5,4,channel)
            plot(signal(channel,:));            
        end
    end
end