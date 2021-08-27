function [signalFilter] = filtr(signal,low,high,fs)
[a, b] = butter(2,[low high]/(fs/2),'bandpass');
[w, k] = size(signal);
signalFilter = [];
for i = 1:w
    signalFilter(i,:) = filter(a,b,signal(i,:));
end
signalFilter;
end

