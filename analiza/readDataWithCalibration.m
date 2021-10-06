function [signalCalibrationOpen,signalVideo] = readDataWithCalibration(path, it)
    data = load(path);
    signal = data.dane_wynikowe.EEG_signal;
    
    %przetworzenie sygnalu
    signal = signalProcess(signal,it);

%     if mod(it-3,4)==0
%         figure('units','normalized','outerposition',[0 0 1 1])
%     end
%     subplot(4,1,mod(it-3,4)+1)
%     plot(1:size(signal,2),signal(1,:))
%     xlim([1 size(signal,2)])
%     xlabel('Numer próbki') 
%     ylabel('Wartość sygnału') 
%     title(strcat('Badany nr ',num2str(it-2)))
    
    %podzielic dane dla kazdego etapu
    events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy eventow z czasem ich rozpoczecia
    time = data.dane_wynikowe.EEG_time;
    eventSignal = {};
    for i=2:length(events)
        eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
    end
    
    %sygnal dla kalibracji
    %signalCalibrationClose = eventSignal{2};
    signalCalibrationOpen = eventSignal{3};
    
    %wybrac dane dla kazdego video
    signalVideo = {};
    it = 1;
    for i = 4:3:33
        signalVideo{it} = eventSignal{i};
        it = it + 1;
    end
end

