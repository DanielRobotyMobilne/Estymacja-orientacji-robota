clear all 
%% wczytanie danych
data = importdata('data.txt'); 
ax = data(:,1); 
ay = data(:,2); 
az = data(:,3);
gx = data(:,4);
gy = data(:,5);
gz = data(:,6);
t = data(:,7)/1000000;
dt = t(2:end)-t(1:end-1);
dlugosc = length(data);
   
%% filtr komplementarny
kat_akcel = atan2(ay,az) * 180/pi;
T = 0.1;

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