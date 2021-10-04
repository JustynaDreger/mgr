function [frames] = dividePerFrames(dat,time, Fs, type)
    frames = {};
    samplesNum = Fs*time;
    k = size(dat,2);
    frames = {};
    if type==0
        for i = 1:k % petla po filmach
            kd = size(dat{i},2);
            it = 1:samplesNum:kd;
            frames{i} = {};
            kf = size(it,2);
            for ii = 1:kf %odcinku
                for iii = 1:19% po elektrodach
                    if ii < kf
                        frames{i}{iii}{ii} = dat{i}(iii,it(ii):it(ii+1)-1);
                    else
                        frames{i}{iii}{ii} = dat{i}(iii,it(ii):kd);
                    end
                end
            end
        end
    else
        %for i = 1:k % petla po filmach
            kd = size(dat,2);
            it = 1:samplesNum:kd;
            frames = {};
            kf = size(it,2);
            for ii = 1:kf %odcinku
                for iii = 1:19% po elektrodach
                    if ii < kf
                        frames{iii}{ii} = dat(iii,it(ii):it(ii+1)-1);
                    else
                        frames{iii}{ii} = dat(iii,it(ii):kd);
                    end
                end
            end
        %end
    end

end