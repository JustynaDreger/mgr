function [valence] = calcValence(dat)
    valence = {};
    
    %wzor 2.1
    
    for i = 1:size(dat,2)
        valence{i} = [0 0];
        
        %alpha
        F3A = dat{i}{3,2}{1};
        F4A = dat{i}{4,2}{1};
        
        %beta 1
        F3B1 = dat{i}{3,4}{1};
        F4B1 = dat{i}{4,4}{1};
        
        %beta 2
        F3B2 = dat{i}{3,5}{1};
        F4B2 = dat{i}{4,5}{1};
                    
        valence{i}(1) = (F4A/F4B1)-(F3A/F3B1);
        valence{i}(2) = (F4A/F4B2)-(F3A/F3B2);
    end 
end

