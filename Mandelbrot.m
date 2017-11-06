% points where F(X) = F(X-1)^2 + c diverges

clear;
clc;

constant = 1;
initial = 1;

upperX = 2;
lowerX = -2;
upperY = 2;
lowerY = -2;
xRes = 500;
yRes = 500;
infin = 30;

xPoints = linspace(upperX, lowerX, xRes);
yPoints = linspace(upperY, lowerY, yRes);

area = [];
final = [];
for x = 1: 1: xRes
    for y = 1: 1: yRes
        area(x, y) = xPoints(x) + i * yPoints(y);
        xySet = [area(x, y)];
        
        for trial = 2: 1: infin
            xySet(trial) = xySet(trial - 1) ^ 2 + area(x, y);
            final(x, y) = trial;
            if xySet(trial) == Inf + Inf * i | xySet(trial) == -Inf + Inf * i | xySet(trial) == Inf - Inf * i | xySet(trial) == -Inf - Inf * i
                break;
            end
        end
    end
    fprintf('Line %i complete\n', x);
end
fprintf('Plotting\n');

surf(final, 'linestyle', 'none');