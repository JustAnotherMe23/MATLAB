clear; clc; close all;
rotorSet = zeros(1, 3);

data = zeros(31, 36);

for a = 1: 1: 31
    for b = 1: 1: 12
        for c = 1: 1: 3
            
            valid = 0;
            while valid == 0
                rotorSet(c) = round(rand() * 4) + 1;
                
                if sum(rotorSet(c) == rotorSet) == 1
                    valid = 1;
                end
            end
        end
        position = b * 3;
        data(a, position - 2: 1: position) = rotorSet * 100;
        data(a, position - 2) = data(a, position - 2) + round(rand() * 26) + 1;
        data(a, position - 1) = data(a, position - 1) + round(rand() * 26) + 1;
        data(a, position) = data(a, position) + round(rand() * 26) + 1;
    end
end

csvwrite('calendar.csv', data);