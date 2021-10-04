function [bands] = calcBandPower(dat,Fs, type)
    bands = {};
    
    if type ==0
        for i = 1:size(dat,2)%petla po filmach
            bands{i} = cell(size(dat{i},2),5);
            for j = 1:size(dat{i},2) %petla po elektrodach
                bands{i}{j,1} = {};
                %filtrowanie i liczenie mocy
                for k = 1:size(dat{i}{j},2) %po oknach
                    bands{i}{j,1}{k} = bandpower(filtr(dat{i}{j}{k},4,8,500)); %theta
                    bands{i}{j,2}{k} = bandpower(filtr(dat{i}{j}{k},8,13,500)); %alfa
                    bands{i}{j,3}{k} = bandpower(filtr(dat{i}{j}{k},13,15,500)); %SMR (13-15)
                    bands{i}{j,4}{k} = bandpower(filtr(dat{i}{j}{k},15,18,500)); %beta 1 (15-18)
                    bands{i}{j,5}{k} = bandpower(filtr(dat{i}{j}{k},18,30,500)); %beta 2 (18-30)
                end
            end
        end
    else
        %for i = 1:size(dat,2)%petla po filmach
            bands = cell(size(dat,2),5);
            for j = 1:size(dat,2) %petla po elektrodach
                bands{j,1} = {};
                %filtrowanie i liczenie mocy
                for k = 1:size(dat{j},2) %po oknach
                    bands{j,1}{k} = bandpower(filtr(dat{j}{k},4,8,500)); %theta
                    bands{j,2}{k} = bandpower(filtr(dat{j}{k},8,13,500)); %alfa
                    bands{j,3}{k} = bandpower(filtr(dat{j}{k},13,15,500)); %SMR (13-15)
                    bands{j,4}{k} = bandpower(filtr(dat{j}{k},15,18,500)); %beta 1 (15-18)
                    bands{j,5}{k} = bandpower(filtr(dat{j}{k},18,30,500)); %beta 2 (18-30)
                end
            end
        %end
    end
end

