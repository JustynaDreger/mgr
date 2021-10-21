function [signalClear] = ica(signal, i)
    signalClear = [];
%     figure()
%     plot(signal(1,:))
    %icasig - maciesz skladowych
    %A - macierz miksujaca
    %W - macierz demiksujaca
    [icasig, A, W] = fastica(signal,'verbose','off');
    
%     figure()
%     for el = 1:19
%         subplot(5,4,el)
%         plot(signal(el,:))
%     end
%     
%     figure()
%     for el = 1:19
%         subplot(5,4,el)
%         plot(icasig(el,:))
%     end
    
    fs = 500;
    indeksy_skladowych={}; kryterium=[]; macierz_skladowych=[]; indeksy_do_usuniecia=[];
    niechciane_pasma = [0.1 5];

    %Wyznaczenie mocy składowych
    for skladowa=1:size(icasig,1)
        for nr_kryt=1:size(niechciane_pasma,1)
            kryterium(skladowa,nr_kryt)=bandpower(icasig(skladowa,:),fs,niechciane_pasma(1,:));
        end
    end
    
    %Oznaczenie składowych do usunięcia
    for nr_kryt=1:size(kryterium,2)
        indeksy_skladowych{nr_kryt}=find(kryterium(:,nr_kryt)>=mean(kryterium(:,nr_kryt))+1.5*std(kryterium(:,nr_kryt)));
        indeksy_do_usuniecia=[indeksy_do_usuniecia; indeksy_skladowych{nr_kryt}];
    end

    %Usuniecie oznaczonych skladowych 
    indeksy_do_usuniecia=unique(indeksy_do_usuniecia);
    for skladowa=1:size(icasig,1)
        for indeks=1:length(indeksy_do_usuniecia)
            if skladowa==indeksy_do_usuniecia(indeks)
                icasig(skladowa,:)=0;
            end
        end
    end

%     figure()
%     for el = 1:19
%         subplot(5,4,el)
%         plot(icasig(el,:))
%     end
    
    %Zlozenie i wyświetlenie sygnalow
    signalClear = A * icasig;
% 
%     figure()
%     for el = 1:19
%         subplot(5,4,el)
%         plot(signalClear(el,:))
%     end
%     hold on
%     %figure()
%     plot(signalClear(1,:))
end

