function [] = plotEmotion(arousal, valence)
    C = [0, 0.4470, 0.7410;
         0, 0,      1;
         0.8500, 0.3250, 0.0980;
         0, 0.5, 0;
         0.9290, 0.6940, 0.1250;
         1, 0, 0;
         0.4940, 0.1840, 0.5560;
         0, 0.75, 0.75;
         0.4660, 0.6740, 0.1880;
         0.75, 0, 0.75;
         0.3010, 0.7450, 0.9330;
         0.75, 0.75, 0;
         0.6350, 0.0780, 0.1840;
         0.25, 0.25, 0.25;
         1,0,1;
         0,1,1;
         1.0,1.0,0.2;
         0.4,1.0,0;
         ];
    %rand(length(arousal),3);
    figure()
    labels = string(1:10);
    hold on
    for person = 1:size(arousal,2)
        v = []; a = [];
        for video = 1:size(arousal{person},2)
            v = [v valence{person}{video}(1)];
            a = [a arousal{person}{video}(1)];
        end
        scatter(v,a,20,ones(10,3).*C(person,:),'filled')
        text(v,a+0.01,labels,"HorizontalAlignment","center","verticalAlignment","bottom");
    end
    axis("padded");
    legend(strcat("Osoba ",string(1:16)))
    xlabel('Valence') 
    ylabel('Arousal') 
    title(strcat("Emocje (beta 1)"))
    
    figure()
    labels = string(1:10);
    hold on
    for person = 1:size(arousal,2)
        v = []; a = [];
        for video = 1:size(arousal{person},2)
            v = [v valence{person}{video}(2)];
            a = [a arousal{person}{video}(2)];
        end
        scatter(v,a,20,ones(10,3).*C(person,:),'filled')
        text(v,a+0.01,labels,"HorizontalAlignment","center","verticalAlignment","bottom");
    end
    axis("padded");
    legend(strcat("Osoba ",string(1:16)))
    xlabel('Valence') 
    ylabel('Arousal') 
    title(strcat("Emocje (beta 2)"))
end

