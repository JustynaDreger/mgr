function [] = plotsPerVideo(data, videoNum)
    bandsName = ["theta", "alfa", "SMR", "beta 1", "beta 2"]
        for i = 1:5
            figure
            v = zeros(19,16);
            for channel = 1:19
                for person = 1:16
                    v(channel,person) = data{person}{channel,i}{1};
                end
            end
            for ch = 1:19
                subplot(5,4,ch)
                bar(v(ch,:))
                sgtitle(strcat('Video nr ',int2str(videoNum),', pasmo ',bandsName(i)))
            end
        end
end

