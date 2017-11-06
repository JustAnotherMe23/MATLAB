clear;
clc;
close all;

% Setting the constants for n
nNewtonian = 1;
nSaline = 0.9;
nRBC = 0.75;

% Create range of 0 to 1 to test over for the ratio of r/R
rRatio = linspace(0, 1, 100);

% Calculate u/V for every n value
uRatioN = (1 + 3 * nNewtonian) / (1 + nNewtonian) * (1 - (rRatio) .^ ((nNewtonian + 1) / nNewtonian));
uRatioS = (1 + 3 * nSaline) / (1 + nSaline) * (1 - (rRatio) .^ ((nSaline + 1) / nSaline));
uRatioR = (1 + 3 * nRBC) / (1 + nRBC) * (1 - (rRatio) .^ ((nRBC + 1) / nRBC));

% Plot over the entire range
plot(rRatio, uRatioN, rRatio, uRatioS, rRatio, uRatioR);
title('r/R vs u/V for Fluids of Various n-Values');
ylabel('u/V');
xlabel('r/R');
legend({'Newtonian Fluid', 'Saline', 'RBC in Serum'});

% Change range to go from 0 to 0.1
rRatio = linspace(0, 0.1, 100);
% Recalculate u/V
uRatioN = (1 + 3 * nNewtonian) / (1 + nNewtonian) * (1 - (rRatio) .^ ((nNewtonian + 1) / nNewtonian));
uRatioS = (1 + 3 * nSaline) / (1 + nSaline) * (1 - (rRatio) .^ ((nSaline + 1) / nSaline));
uRatioR = (1 + 3 * nRBC) / (1 + nRBC) * (1 - (rRatio) .^ ((nRBC + 1) / nRBC));

% Plot over new range
figure;
plot(rRatio, uRatioN, rRatio, uRatioS, rRatio, uRatioR);
title('r/R vs u/V for Fluids of Various n-Values Near Centerflow');
ylabel('u/V');
xlabel('r/R');
legend({'Newtonian Fluid', 'Saline', 'RBC in Serum'});

% Repeat as above except for of 0.9 to 1
rRatio = linspace(0.9, 1, 100);
uRatioN = (1 + 3 * nNewtonian) / (1 + nNewtonian) * (1 - (rRatio) .^ ((nNewtonian + 1) / nNewtonian));
uRatioS = (1 + 3 * nSaline) / (1 + nSaline) * (1 - (rRatio) .^ ((nSaline + 1) / nSaline));
uRatioR = (1 + 3 * nRBC) / (1 + nRBC) * (1 - (rRatio) .^ ((nRBC + 1) / nRBC));

figure;
plot(rRatio, uRatioN, rRatio, uRatioS, rRatio, uRatioR);
title('r/R vs u/V for Fluids of Various n-Values Near Edge');
ylabel('u/V');
xlabel('r/R');
legend({'Newtonian Fluid', 'Saline', 'RBC in Serum'});
