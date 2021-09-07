function [parts] = getParts(dat,intervals, fs)
    parts = {};
    for video = 1:size(dat,2)
        if intervals(video,1) == 0
            parts{video} = dat{video}(:,1:(intervals(video,2)*fs));
        else
            parts{video} = dat{video}(:,intervals(video,1)*fs:(intervals(video,2)*fs)-1);
        end
    end
end

