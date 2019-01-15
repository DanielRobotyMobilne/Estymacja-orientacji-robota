clear all 
%% wczytanie danych
% fi - roll - przechylenie - na bok
% teta - pitch - pochylenie - do przodu
% psi - yaw - odchylenie - obrót wokół osi pionowej
data = importdata('data.txt'); 
ax = data(:,1)*4/65535;                   
ay = data(:,2)*4/65535;         
az = data(:,3)*4/65535;         
gx = data(:,4)*250/32768; 
gy = data(:,5)*250/32768;
gz = data(:,6)*250/32768;
t = data(:,7)/1000000;
dlugosc = length(data);
%dt = t(2:end)-t(1:end-1);
dt = 1/1024;           %czestotliwosc probkowania 1 kHz

fiA = zeros(dlugosc,1);
tetaA = zeros(dlugosc,1);
psiA = zeros(dlugosc,1);
fiG = zeros(dlugosc,1);
tetaG = zeros(dlugosc,1);
psiG = zeros(dlugosc,1);
fiF = zeros(dlugosc,1);
tetaF = zeros(dlugosc,1);
psiF = zeros(dlugosc,1);
%% filtr komplementarny

for i = 1:length(data);
    fiA(i) = atan2(az(i),ay(i)) * 180/pi;
    g = sqrt(az(i)^2 + ay(i)^2);
    %g = 9.81;
    tetaA(i) = (atan2(-ax(i),g)) * 180/pi;
    %psiA(i) = atan2(sqrt(ay(i)^2 + ax(i)^2), az(i)) * 180/pi;;
end

T = 0.3;
p = T/(dt + T);

for i=2:dlugosc
    fiG(i) =  fiG(i-1) + gx(i)*dt* 180/pi ;
    tetaG(i) = tetaG(i-1) + gz(i)*dt* 180/pi ;
    psiG(i) = psiG(i-1) + gy(i)*dt * 180/pi;
    
    fiF(i) = p*fiF(i-1) + (1-p)*fiA(i) + p*(fiG(i) - fiG(i-1));
    tetaF(i) = p*tetaF(i-1) + (1-p)*tetaA(i) + p*(tetaG(i) - tetaG(i-1));
    psiF(i) = p*psiF(i-1) + (1-p)*psiA(i) + p*(psiG(i) - psiG(i-1));
end

%% wykres 
figure(1)
plot(t, fiA, 'b', t, fiG, 'r', t, fiF, 'g')
legend( 'Kąt z akcelerometru','Kąt z żyroskopu', 'Kąt po filtracji')
xlabel('t [s]')
ylabel('\phi [°]')
title('Przechylenie')
grid on
figure(2)
plot(t, tetaA, 'b', t, tetaG, 'r', t, tetaF, 'g')
legend( 'Kąt z akcelerometru','Kąt z żyroskopu', 'Kąt po filtracji')
xlabel('t [s]')
ylabel('\theta [°]')
grid on
title('Pochylenie')
figure(3)
plot(t, psiG, 'r', t, psiF, 'g')
legend('Kąt z żyroskopu', 'Kąt po filtracji')
xlabel('t [s]')
ylabel('\psi [°]')
grid on
title('Odchylenie')
