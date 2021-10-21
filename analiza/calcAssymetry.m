function [assymetry] = calcAssymetry(dat)
    assymetry = {};
    
    for i = 1:size(dat,2)
        assymetry{i} = {[0 0],[0 0]};
        
        Fp1A = dat{i}{1,2}{1}; %alpha
        Fp2A = dat{i}{2,2}{1};
        F3A = dat{i}{4,2}{1};
        F4A = dat{i}{6,2}{1};
        
        assymetry{i}{1}(1) = log(F4A) - log(F3A); % wzor 2.6
        assymetry{i}{1}(2) = log(Fp2A) - log(Fp1A);
        
        assymetry{i}{2}(1) = F3A/F4A; % wzor 2.9
        assymetry{i}{2}(2) = Fp1A/Fp2A;
        
    end
end

