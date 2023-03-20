% DLVO calculation
%
% Use DLVO theory to calcualte potential for gel particles. Combine vdW
% forces and electrostatic forces (Debye-Huckel) to get net potential.
%
% Author: Eric Schwen
% Date: 12/19/17

% Total potential energy phi:
% phi = phi_vdw + phi_el

% van der Waals forces
% phi_vdw = -A*a / (12*h)
% phi_el = q*lamb / (ep * ep0) * exp(-h/lamb)
% lamb = Debye length

% h = surface-to-surface separation in meters
h = (0.005:0.005:2)*1e-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vdW forces
A = 2.4e-21; % Joules
a = 1e-6; % 1um

% vdW potential (normalized by kT)
phi_vdW = -A*a./(12*h) * 1/(k*T);

figure;
hold on
plot(h(:)/1e-6, phi_vdW(:), 'b:o');
title('van der Waals \phi_{vdw}','FontSize', 20);
xlabel('Surface Separation h (um)','FontSize', 18);
ylabel('\phi_{vdW}','FontSize', 18);

% xlim([0 510])
% ylim([-.1 .1])

% leg = legend('Location', 'northeast');
% set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% electrostatic forces

ep0 = 8.85e-12; % (F/m)
ep = 70; % Dielectric constant
k = 1.38e-23; % Boltzmann's Constant (J/K)
T = 295; % Temp (K)
e = 1.602e-19; % Charge (C)
Z = 2; % Divalent salt
n = 6.022e26; % number density (m^-3)

% Debye lenth in meters
lamb = sqrt((ep * ep0 * k * T)/(2 * e^2 * Z^2 * n));

sig = 25e-3; % surface charge density (C/m^2)

% Electrostatic potential (normalized by kT)
phi_el = (sig * lamb)/(ep * ep0) * exp(-h./lamb) * 1/(k*T);

figure;
hold on
plot(h(:)/1e-6, phi_el(:), 'b:o');
title('Electrostatic Pot. \phi_{el}','FontSize', 20);
xlabel('Surface Separation h (um)','FontSize', 18);
ylabel('\phi_{el}','FontSize', 18);

% xlim([0 510])
ylim([0 10])

% leg = legend('Location', 'northeast');
% set(leg, 'FontSize', 16)

xt = get(gca,'XTick');
set(gca, 'FontSize', 16);
hold off





