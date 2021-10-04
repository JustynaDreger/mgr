function [signalNorm] = normalization(dat,cal)
    signalNorm = {};
    
    for i = 1:size(dat,2)
        for j = 1:size(dat{i},1)
            for k = 1:size(dat{i},2)
                signalNorm{i}{j,k} = num2cell(dat{i}{j,k}{1}/cal{j,k}{1});
            end
        end
    end
end

