function [signalSel, signalTime] = selectSignal(data)
    signalSel = [];
    signalTime = [];
    
    signal = data.dane_wynikowe.EEG_signal;
    events = data.dane_wynikowe.Events{:,[1 4]}; %nazwy eventow z czasem ich rozpoczecia
    time = data.dane_wynikowe.EEG_time;
    
    
    for i=2:size(events,1)
        eventSignal{i-1} = signal(:,(time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))));
        eventTime{i-1} = [signalTime time((time<str2num(cell2mat(events(i,1))))&(time>=str2num(cell2mat(events(i-1,1)))))];
    end
    
    selected = [2 3 4:3:33]; % 2 kalibracja zamkniete
                            % 3 kalibracja otwarte
                            % 4 - 31 reklamy
    
    for i = selected
        signalSel = [signalSel eventSignal{i}];
        signalTime = [signalTime eventTime{i}];
    end
    
end

