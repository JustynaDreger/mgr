function [signalSel, signalTime] = selectSignal(data)
    signalSel = [];
    
    signal = data.dane_wynikowe.EEG_signal;
    events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy eventow z czasem ich rozpoczecia
    time = data.dane_wynikowe.EEG_time;
    
    signalTime = [];
    for i=2:length(events)
        eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
        signalTime = [signalTime time((time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))))];
    end
    
    selected = [2 3 4:3:33]; % 2 kalibracja zamkniete
                            % 3 kalibracja otwarte
                            % 4 - 31 reklamy
    
    for i = selected
        signalSel = [signalSel eventSignal{i}];
    end
    
    size(signalSel)
    size(signalTime)
    %signalTime
end

