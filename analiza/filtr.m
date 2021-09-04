function [signalFilter] = filtr(signal,low,high,fs)
    buffor = 0.5;
    order = 4;
    [a, b] = butter(order,[low-buffor high+buffor]/(fs/2),'bandpass');
    [w, k] = size(signal);
    signalFilter = filter(a,b,signal);
end

