function [parts] = getParts(dat,intervals, fs, type)
    parts = {};
    if type == 0
        for video = 1:size(dat,2)
            if intervals(video,1) == 0
                parts{video} = dat{video}(:,1:(intervals(video,2)*fs));
            else
                parts{video} = dat{video}(:,intervals(video,1)*fs:(intervals(video,2)*fs)-1);
            end
        end
    else
        %for video = 1:size(dat,2)
            if intervals(1) == 0
                parts = dat(:,1:(intervals(2)*fs));
            else
                parts= dat(:,intervals(1)*fs:(intervals(2)*fs)-1);
            end
        %end
    end
end

