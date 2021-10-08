function [signal] = signalProcess(signal,it)

%Trzeba więc najpierw z pełnej macierzy danych wyciągnąć dane odnoszące się 
%do tych 12 eventów (w zasadzie 11, bo kalibracja a zamkniętymi oczami się raczej nie przyda),
%następnie połączyć te eventy w 1 długi sygnał, zrobić preprocessing z percentylami, 
%potem zrobić ICA i ponownie rozłożyć oczyszczony sygnał na składowe.




    for channel=1:size(signal,1)
                if it == 11 %dla badanego nr 9
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
                m = mean(sig);
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
end

