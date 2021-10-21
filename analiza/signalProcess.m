function [signal] = signalProcess(signal,it)

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
                prc10 = prctile(sig,3);
                prc90 = prctile(sig,97);
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
                    signal(channel,lMin:lMax) = prc90;    
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
                    signal(channel,lMin:lMax) = prc10;    
                end
            end
end

