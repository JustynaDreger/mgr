function [values] = plotsPerChannelBand(data, channelNum, bandNum)
    figure
    bandsName = ["theta", "alfa", "SMR", "beta 1", "beta 2"];
    for i = 1:size(data,2) %po badanych
        subplot(4,4,i)
        values = cellfun(@(v)v(channelNum, bandNum),data{i});
        hold on
        for j=1:max(size(values))
            bar(j,cell2mat(values{j}),'b')
        end
        hold off
    end
    sgtitle(strcat('Kanal ',int2str(channelNum),', pasmo ',bandsName(bandNum)))
end

