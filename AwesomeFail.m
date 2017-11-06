% points where F(X) = F(X-1)^2 + c diverges

clear;
clc;

upperX = 5;
lowerX = -5;
upperY = 5;
lowerY = -5;
xRes = 250;
yRes = 250;

xPoints = linspace(lowerX, upperX, xRes);
yPoints = linspace(lowerY, upperY, yRes);

area = [];
final = [];
for x = 1: 1: xRes
    for y = 1: 1: yRes
        area(x, y) = xPoints(x) + i * yPoints(y);
    end
end
areaCopy = area;
valid = 0;
while 1
    areaCopy = area;
    area = area .^2;
    
    for x = 1: 1: xRes
        for y = 1: 1: yRes
            if abs(area(x, y)) == Inf
                valid = 1;
                break;
            end
        end
        
        if valid == 1
            break;
        end
    end
    
    if valid == 1;
        break;
    end
end

final = areaCopy;
final = log(final)/log(10)
fprintf('Plotting\n');

surf(imag(final), 'linestyle', 'none')