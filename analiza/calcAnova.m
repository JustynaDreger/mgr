function [pvalue] = calcAnova(data,videoIDs,p)
    pvalue = [0,0];
    
    videoIDs(videoIDs == 0) = [];
    
    y = [];
    y2 = [];
    it = 1;
    if p == 0
        for person = 1:size(data,2)
            for video = videoIDs
                y(person,it) = data{person}{video}(1); %arousal policzony z betha1
                y2(person,it) = data{person}{video}(2); %arousal policzony z betha2
                it = it + 1;
            end
            it = 1;
        end
        pvalue(1) = anova1(y);
        pvalue(2) = anova1(y2);
    else
        for person = 1:size(data,2)
            for video = videoIDs
                y(person,it) = data{person}{video}{1}(1); %asymetria policzony z betha1
                y2(person,it) = data{person}{video}{1}(2); %asymetria policzony z betha2
                y3(person,it) = data{person}{video}{2}(1); %asymetria policzony z betha1
                y4(person,it) = data{person}{video}{2}(2); %asymetria policzony z betha2
                it = it + 1;
            end
            it = 1;
        end
        pvalue(1) = anova1(y);
        pvalue(2) = anova1(y2);
        pvalue(3) = anova1(y3);
        pvalue(4) = anova1(y4);
    end
end

