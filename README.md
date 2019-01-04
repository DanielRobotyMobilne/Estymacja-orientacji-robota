# Roboty Mobilne
Subocz, Stencel, Dzierżawski, Bieszk

  Tematem projektu była konstrukcja zdalnie sterowanego robota moblinego oraz estymacja jego orientacji na podstawie danych z umieszczonego na nim akcelerometru. 

  W robocie wykorzystano moduł MPU-6050. Zawiera on 3-osiowy żyroskop oraz 3-osiowy akcelerometr. Wskład modułu wchodzi również czujnik temperatury, lecz nie jest on wykorzystywany w tym projekcie. Do komunikacji robota ze stacją Arduino wykorzystano moduł radiowy nRF24L01. Zawiera nadajnik i odbiornik pracujący na częstotliwości 2,4 GHz.

  Operator steruje robotem za pomocą joysticka umieszczonego przy nadajniku. Kąt oraz kierunek wychylenia gałki jest przekształcany przez przetwornik do postaci cyfrowej, a następnie przesyłany za pomocą modułu radiowego. Informacja odebrana przez moduł znajdujący się w robocie jest przekazywana do Arduino.

  Do sterowania silnikami wykorzystywane są wyjścia PWM (pozwalające na modulację szerokości impulsów), przez które sygnał sterujący trafia do wzmacniaczy. Za każdy z silników odpowiedzialne są dwa wzmacniacze. W zależności od pożądanego kierunku ruchu (a zatem odpowiadającym mu kierunkom obrotów silnika) sygnały przesyłane są na odpowiednie wyjścia.

  Informacja o położeniu robota w przestrzeni jest otrzymywana poprzez akcelerometr i żyroskop. Dane z nich przesyłane są do operatora poprzez kolejny kanał modułu radiowego. Do estymacji orientacji wykorzystano filtr Kalmana, filtr komplementarny oraz filtr Mahonego. Otrzymane wyniki zostały przedstawione w sprawozdaniu.
