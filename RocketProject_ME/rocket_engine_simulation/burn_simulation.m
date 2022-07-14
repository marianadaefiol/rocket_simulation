close;
clear;
tic;

% Par�metros constantes
alfa = 16.3;        % �ngulo entre a se��o divergente e eixo do motor (deg)
rho = 1730.0;       % densidade do propelente (kg/m^3)
a = 0.073;          % coeficiente de queima (m/s)
e = 1.4;            % coeficiente de eros�o
n = 0.51;           % expoente de queima
R = 8.3143;         % constante universal dos gases (J/(mol * K))
g = 9.8;            % acelera��o da gravidade (m/s^2)
T = 0.001;          % tamanho do passo temporal
Pa = 101325.0;      % press�o atmosf�rica ao n�vel do mar (Pa)

% Par�metros do motor
dg = 9.8e-3;        % di�metro da garganta
de = 19.3e-3;       % di�metro de escape da se��o divergente
Ag = pi * dg^2/4;   % �rea da garganta -> At
Ae = pi * de^2/4;   % �rea de escape da se��o divergente -> Ae

% Par�metros do propelente
din = 0.008;        % di�metro interno m�dio do propelente (m)
dex = 0.04;         % di�metro externo m�dio do propelente (m)
m = 0.300;          % massa m�dia do propelente (kg)

% Par�metros de partida
Pext = 101325.0;    % press�o externa inicial (Pa)
Po(1) = 20 * Pa;    % press�o interna inicial (Pa)

% Comprimento m�dio do propelente
hpr = m / (rho * pi * 0.25 * (dex^2 - din^2));

% �ngulo da tubeira
AngTub = (1 + cos(alfa * pi / 180))/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0;
while(1)
t = t + 1;
   
% gamma com a press�o //////////
gamma(t) = 1.15032 + 0.03418 * exp(-Po(t)/(23.24512 * Pa)); %#ok<*SAGROW>

% Pext
if (t == 1)
	Pext(t) = newton_raphson(Ag,Ae,gamma(t),Po(t),Pa);
else
	Pext(t) = newton_raphson(Ag,Ae,gamma(t),Po(t),Pext(t-1));
end

% tau com a press�o /////////////
tau(t) = ((2/(gamma(t) + 1))^((gamma(t) + 1)/(gamma(t) - 1)));

% G ///////////////
G(t) = 1 - (Pext(t)/Po(t))^((gamma(t) - 1)/(gamma(t)));

% H 
H(t) = 2 * gamma(t) * gamma(t) / (gamma(t) - 1);

% M com a press�o
M(t) = (26.86788 + 1.01785 * exp(-Po(t)/(40.53856 * Pa))) * 0.001; 

% To com a press�o
To(t) = 1811 - 296.66491 * exp(-Po(t)/(27.92945 * Pa)); 

% X com a press�o 
X(t) = 0.7363 + 0.11995 * exp(-Po(t)/(26.71262 * Pa));

% rs com a press�o ////////////
rs(t) = 0.01 * e * a * (Po(t)/Pa)^n;

% Retrocesso e avan�o dos di�metros externo e interno durante a queima
D = dex; % - 2 * T * sum(rs(1:t))
d(t) = din + 2 * T * sum(rs(1:t));

% �rea de queima //////////////
Ab(t) = pi * hpr * (dex + din) + pi*(dex^2 - din^2)/2 - 6 * pi * (din + dex) * T * sum(rs(1:t));

% Empuxo /////////////
Emp(t) = AngTub * (Ag * Po(t) * sqrt(H(t) * tau(t) * G(t)) + (Pext(t) - Pa) * Ae);

% Se o avan�o externo for menor ou igual ao avan�o interno -> alterado
% condi��o para acabar a queima; se igualar a simula��o n�o para pois de de
% 2,998 para 2,999...... 
if (d(t) >= D)  
   break;
end

% Press�o interna
Po(t+1) = (Ab(t) * rs(t) * rho * X(t))/(Ag * sqrt(M(t) * tau(t) / R / To(t))); 
end

%%%%%%%%%%% Estudando as equa��es acima, geram as que necessitam pra
%%%%%%%%%%% tabela 

% Empuxo m�ximo
Emax = max(Emp);

% Impulso total
I = T * cumsum(Emp);

% Impulso total m�ximo
Imax = max(I);

% Impulso espec�fico
Is = max(I)/(m*g);

% Tempo de queima
Tq = t/1000;

%%%%%%%%%%% PLOTS
% Gr�ficos
figure('Name', 'Empuxo');
plot(Emp,'b-','LineWidth',2);
xlabel('Tempo (ms)');
ylabel('Empuxo (N)');
hold on;
grid on;

figure('Name', 'Impulso');
plot(I,'r-','LineWidth',2);
xlabel('Tempo (ms)');
ylabel('Impulso (Ns)');
hold on;
grid on;

figure('Name', 'Po');
plot(Po, 'm-','LineWidth',2);
xlabel('Tempo (ms)');
ylabel('Po (Pa)');
hold on;
grid on;

toc