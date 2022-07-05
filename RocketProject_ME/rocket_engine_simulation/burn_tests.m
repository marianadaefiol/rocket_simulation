clc;
tic;
clear;
close;

% Constantes
dg = 9.8e-3;
Pa = 1.01325e5;
gamma = 1.1639;
Ag = pi * dg^2/4;
alpha = 16.3*pi/180;
delta = (gamma-1)/gamma;
zeta = 2/((1+cos(alpha))*Ag*sqrt(2*gamma^2/(gamma-1)*(2/(gamma+1))^...
       ((gamma+1)/(gamma-1))));

% Dados dos ensaios
dadosP1 = readtable('data/Tiro2_P1.csv','NumHeaderLines',1);
dadosP2 = readtable('data/Tiro1_P2.csv','NumHeaderLines',1);
dadosP3 = readtable('data/Tiro3_P3.csv','NumHeaderLines',1);

% Empuxo dos ensaios
EmpP1 = movmean(dadosP1.Var2,10);
EmpP2 = movmean(dadosP2.Var2,10);
EmpP3 = movmean(dadosP3.Var2,10);

% Tempo
time = zeros(length(EmpP1),1);
for index = 2:length(EmpP1)
    time(index) = time(index-1)+1;
end
time = time/1000;

% Impulso
IP1 = cumtrapz(time,EmpP1);
IP2 = cumtrapz(time,EmpP2);
IP3 = cumtrapz(time,EmpP3);

% Pressão interna
PoP1 = zeros(length(time),1);
PoP2 = zeros(length(time),1);
PoP3 = zeros(length(time),1);
for index=1:length(time)
    if(index == 1)
        PoP1(index,1) = pressure(delta,zeta*EmpP1(index),Pa);
        PoP2(index,1) = pressure(delta,zeta*EmpP2(index),Pa);
        PoP3(index,1) = pressure(delta,zeta*EmpP3(index),Pa);
    else
        PoP1(index,1) = pressure(delta,zeta*EmpP1(index),PoP1(index-1));
        PoP2(index,1) = pressure(delta,zeta*EmpP2(index),PoP2(index-1));
        PoP3(index,1) = pressure(delta,zeta*EmpP3(index),PoP3(index-1));
    end
end

graphic(1,EmpP1,IP1,PoP1);
graphic(2,EmpP2,IP1,PoP2);
graphic(3,EmpP3,IP1,PoP3);

toc