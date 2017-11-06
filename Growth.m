% Modeling Growth

% Pn = lambaP(n-1)(1 - P(n-1))
clear;
clc;

format long;
seperations = 10000;
infin = 2: 1: 50;
max = 4;
lambda = linspace(0, max, seperations);
Po = 0.5;
pop = [];
n = 0;
for growth = lambda
    n = n + 1;
    m = 1;
    pop(n, 1) = Po;
    for iterate = infin
        pop(n, iterate) = growth * pop(n, iterate - 1) * (1 - pop(n, iterate - 1));
    end
end
fprintf('Populations Calculated\n');
constants = [];
for part = 1: 1: seperations
    count = 2;
    final = pop(part, end);
    constants(part, 1) = final;
    for point = 49: -1: 1
        if abs(final - pop(part, point)) <= 0.002
            break;
        else
            constants(part, count) = pop(part, point);
            count = count + 1;
        end
    end
end

fprintf('Constants Evaluated\n');

sizeConstants = size(constants);
grapher = [lambda; constants(:, 1)'];
hold on;
scatter(lambda, constants(:, 1)', 1)
for column = 2: 1: sizeConstants(2)
    column = column;
    set = constants(:, column);
    lambdaCopy = lambda;
    set = set';
    delete = 1;
    while delete <= size(set);
        if abs(set(delete)) <= 0.001;
            set(delete) = [];
            lambdaCopy(delete) = [];
            continue;
        end
        delete = delete + 1;
        
    end
    set;
    lambdaCopy;
    
    scatter(lambdaCopy, set, 1);
end