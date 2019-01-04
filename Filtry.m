clear all;
close all;
%% wczytanie danych
data = importdata('data.txt');

ax = data(:,1:1)*4/65535; %[m/s^2]
ay = data(:,2:2)*4/65535; 
az = data(:,3:3)*4/65535;
gx = data(:,4:4)*250/32768; %[°/s]
gy = data(:,5:5)*250/32768;
gz = data(:,6:6)*250/32768;

dt = 0.1;
t = data(:,7:7)*dt/100000; % [s]
%% pomiar 
pomiar = zeros(length(data),1); 
gyro=gx;
for i = 1:length(data);
    pomiar(i) = atan2( ay(i) , az(i)) * 180/pi; %phi
end

%% filtr kalmana
v0 = 3;
w0 = 3;
V = [v0*v0*dt 0; 0 v0*v0*dt];
W = w0*w0;

A = [1 -dt; 0 1];
B = [dt; 0];
C = [1 0];

x0 = [0; 0];
P0 = [1 0; 0 1];
x1 = x0;
P1 = P0;
x2 = x0;
P2 = P0;

kalman = zeros(length(data),1);
for i = 1:length(data);
    
    if i == 1;
        x2 = [pomiar(i); 0];
    else
        x1 = A*x2 + B*gyro(i);
        P1 = A*P2*A' + V;
        
        e = pomiar(i) - C*x1;
        S = C*P1*C' + W;
        K = P1*C'*S^(-1);
        x2 = x1 + K*e;
        P2 = P1 - K*S*K';
    end
    
        kalman(i) = x2(1);
        
end

%% filtr komplementarny
alfa_c = 0.35;
complementary = zeros(length(data),1);
complementary(1) = pomiar(1);
for i=2:length(data) 
    
    complementary(i) = alfa_c * pomiar(i) + ( 1 - alfa_c ) * ( complementary(i-1) + gyro(i) * dt );
    
end

%% filtr mahonego
Gain_i = 0.5;
Gain_p = 3.3;
alfa_m = 1 - Gain_p * dt;
i_m = zeros(length(data),1);
mahony = zeros(length(data),1);
mahony(1) = pomiar(1);
for i=2:length(data) 
      
    i_m(i) = i_m(i-1) + Gain_i * ( pomiar(i) - mahony(i-1) ) * dt;
    mahony(i) = alfa_m * mahony(i-1) + ( i_m(i) + gyro(i) ) * dt + ( 1 - alfa_m ) * pomiar(i);
    
end

%% wykres
plot(t, pomiar, 'b', t, kalman, 'r', t, complementary, 'g', t, mahony, 'y')
legend('Pomiar', 'Filtr Kalmana', 'Filtr komplementarny', 'Filtr Mahonego')
xlabel('Czas [s]')
ylabel('\phi [°]')