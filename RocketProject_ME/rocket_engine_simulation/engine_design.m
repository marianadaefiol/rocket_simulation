clear;
close;

% Constant parameters
Pa = 1.01325e5;       % sea level atmospheric pressure (Pa) 
P0 = 20.265e5;        % propellant's burn pressure (Pa)
R = 8.3143;           % universal gas constant (J/(mol * K))
g = 9.80;             % gravitational acceleration (m/s^2)

% Engine's parameters
alpha = 16.3*pi/180;  % angle between divergent section and motor's axis

% Propellant's parameters
T0 = 1677;            % stagnation temperature (K)
gamma = 1.1639;       % specific heat ratio
chi = 0.7894;         % fraction of gaseous mass generated
M = 0.02742;          % average molecular mass of combustion byproducts (kg/mol)
e = 1.4;              % erosion coefficient
a = 7.3e-4;           % burn coefficient (m/s)
n = 0.51;             % burn exponent
rho = 1730;           % propellent's density (kg/m^3)
De = 2 * 0.020;       % propellant's external diameter (m)
Di = 2 * 0.004;       % propellant's internal diameter (m)
mp = 0.300;           % propellant's mass (kg)

% propellant's lenght (m)
h = mp/(rho*pi*(De^2-Di^2)*0.25)

% Burn rate
Rs = e*a*(P0/Pa)^n

% Average burn area
Abm = pi * h * (De + Di)

% Total burn time
Tq = (De - Di)/(4*Rs)

% Throat area
At = Abm*(P0^(n-1)/Pa^n)*e*a*rho*chi/...
    (sqrt(M*gamma/(R*T0)*(2/(gamma+1))^((gamma+1)/(gamma-1))))

% Throat diameter
Dt = 2*sqrt(At/pi)

% Escape area
Ae = At*(2/(gamma+1))^(1/(gamma-1))*(P0/Pa)^(1/gamma)/...
    (sqrt((gamma+1)/(gamma-1)*(1-(Pa/P0)^((gamma-1)/gamma))))

% Escape diameter
Des = 2*sqrt(Ae/pi)

% Engine thrust
tau = (1+cos(alpha))/2*(At*P0*sqrt((2*gamma^2)/(gamma-1)*...
      (2/(gamma+1))^((gamma+1)/(gamma-1))*(1-(Pa/P0)^((gamma-1)/gamma)))...
      +(Pa-Pa)*Ae)
  
% Total impulse
It = tau * Tq

% Specific impulse
Is = It/(mp*g)
