function [signalVideo] = readData(path)
    data = load(path);
    signal = data.dane_wynikowe.EEG_signal;
    
    
    
    
    %podzielic dane dla kazdego etapu
    events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy eventow z czasem ich rozpoczecia
    time = data.dane_wynikowe.EEG_time;
    eventSignal = {};
    for i=2:length(events)
        eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
    end
    %wybrac dane dla kazdego video
    signalVideo = {};
    it = 1;
    for i = 4:3:33
        signalVideo{it} = eventSignal{i};
        it = it + 1;
    end
    
end

