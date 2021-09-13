function [] = plotsPerPerson(data, personNum)
    
    bandsName = ["theta", "alfa", "SMR", "beta 1", "beta 2"];
    for i = 1:5
        figure
        v = zeros(19,10);
        for channel = 1:19
            for video = 1:10
                v(channel,video) = data{video}{channel,i}{1};
            end
        end
        for ch = 1:19
            subplot(5,4,ch)
            bar(v(ch,:))
            sgtitle(strcat('Osoba nr ',int2str(personNum),', pasmo ',bandsName(i)))
        end
    end
end

