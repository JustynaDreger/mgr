function [arousal] = calcArousal(dat)
    arousal = {};
    
    %Fp1, Fp2, F3 i F4 (czyli 1 indeks arousal na sumie mocy z tych 4 elektrod
    
    for i = 1:size(dat,2)
        arousal{i} = [0 0];
        
        Fp1A = dat{i}{1,2}{1}; %alpha
        Fp2A = dat{i}{2,2}{1};
        F3A = dat{i}{4,2}{1};
        F4A = dat{i}{6,2}{1};
        
        Fp1B1 = dat{i}{1,4}{1}; %beta 1
        Fp2B1 = dat{i}{2,4}{1};
        F3B1 = dat{i}{4,4}{1};
        F4B1 = dat{i}{6,4}{1};
        
        Fp1B2 = dat{i}{1,5}{1}; %beta 2
        Fp2B2 = dat{i}{2,5}{1};
        F3B2 = dat{i}{4,5}{1};
        F4B2 = dat{i}{6,5}{1};
            
        betha1 = Fp1B1 + Fp2B1 + F3B1 + F4B1;
        betha2 = Fp1B2 + Fp2B2 + F3B2 + F4B2;
        alpha = Fp1A + Fp2A + F3A + F4A;
        
        arousal{i}(1) = (betha1+betha2)/alpha;
        arousal{i}(2) = betha2/alpha;
    end 
end

