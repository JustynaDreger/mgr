function [signalCalibrationOpen,signalVideo,signalPrzed,signalPo,signalICA] = readDataWithCalibration(path, it)
    data = load(path);

    [signal, time] = selectSignal(data);
    signalPrzed = signal;
    
%     figure()
%      for el = 1:19
%          subplot(5,4,el)
%          plot(signal(el,:))
%      end

    %signal = data.dane_wynikowe.EEG_signal;
    
    %przetworzenie sygnalu
    signal = signalProcess(signal,it);
    signalPo = signal;
%     if mod(it-3,4)==0
%         figure('units','normalized','outerposition',[0 0 1 1])
%     end
%     subplot(4,1,mod(it-3,4)+1)
%     plot(1:size(signal,2),signal(1,:))
%     xlim([1 size(signal,2)])
%     xlabel('Numer próbki') 
%     ylabel('Wartość sygnału') 
%     title(strcat('Badany nr ',num2str(it-2)))
%figure()
%for sub = 1:16
%     for el = 1:19
%         subplot(5,4,el)
%         plot(signal(el,:))
%     end
%end
    
    %ICA
    signal = ica(signal, it);
    signalICA = signal;
%      figure()
% % %for sub = 1:16
%      for el = 1:19
%          subplot(5,4,el)
%          plot(signal(el,:))
%      end
%     
    %podzielic dane dla kazdego etapu
    events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy eventow z czasem ich rozpoczecia
    %time = data.dane_wynikowe.EEG_time;
    eventSignal = {};
    it = 1;
    for i=[2 3 4:3:33]+1
        eventSignal{it} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
        it = it + 1;
    end

    %sygnal dla kalibracji
    %signalCalibrationClose = eventSignal{1};
    signalCalibrationOpen = eventSignal{2};
    
    %wybrac dane dla kazdego video
    signalVideo = {};
    it = 1;
    for i = 3:size(eventSignal,2)
        signalVideo{it} = eventSignal{i};
        it = it + 1;
    end
    
end

