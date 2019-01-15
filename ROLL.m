clear all 
%% wczytanie danych
data = importdata('data.txt'); 
ay = data(:,1);                  
az = data(:,2); 
ax = data(:,3);
gy = data(:,4)*250/32768; 
gz = data(:,5)*250/32768;
gx = data(:,6)*250/32768;
t = data(:,7)/1000000;
dt = t(2:end)-t(1:end-1);
dlugosc = length(data);

%% filtr komplementarny
kat_akcel = atan2(ay,az) * 180/pi;
T = 0.5;

kat_zyro = zeros(dlugosc,1);
kat_filtr = zeros(dlugosc,1);
    
    for i=2:dlugosc
        if i==2
            kat_zyro(1) = gx(1)*dt(1);
            p = T./(dt(1)+T);
            kat_filtr(1) = (1-p).*kat_akcel(1) + p.*kat_zyro(1);
        end
        
        kat_zyro(i) = kat_zyro(i-1) + gx(i)*dt(i-1);
        p = T./(dt(i-1) +T);
        kat_filtr(i) = p.*kat_filtr(i-1) + (1-p).*kat_akcel(i) +p.*(kat_zyro(i)-kat_zyro(i-1));
        
    end

%% wykres 
plot(t, kat_zyro, 'b', t, kat_akcel, 'r', t, kat_filtr, 'g')
legend('kat z zyroskopu', 'kat z akcelerometru', 'kat po filtracji')
xlabel('t')
ylabel('\phi')