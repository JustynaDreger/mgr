# mgr
praca magisterska informatyka

Wykorzystanie sygnałów EEG w badaniu emocji odbiorców przekazu reklamowego prezentowanego w formie video

Program wymaga instalacji kodeków do mp4 np. https://www.codecguide.com/download_kl.htm
oraz pakietu PyQt5.


Opis plików:
  answers.csv:
    - zawiera odpowiedzi na pytania dotyczące reklam
    - struktura: videoID|answer|questionID
  data.csv:
    - zawiera emocje, które osoba przypisała do filmu
    - struktura: videoID|answer
  questions.csv:
    - zawiera listę pytań i odpowiedzi do rekla wraz z poprawną odpowiedzią
    - struktura: videoID|questionID|question|ansA|ansB|ansC|ansD|correct
  videoInfo.txt:
    - zawiera informacje na temat reklam: numer id, czas trwania w sekundach oraz listę emocji które przypisano
    - struktura: videoID|duration[s]|emotion
