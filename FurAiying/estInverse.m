function [inverse] = estInverse(covariance, lambda, perturb)
    global p;
    p = length(covariance);
    testInverse = NaN(p, p);
    
    if perturb
        eigenVal = eig(covariance);
        perturb = max([max(eigenVal) - p * min(eigenVal), 0]) / (p - 1);
        diagonal = diag(diag(covariance));
        covariance = covariance + diagonal;
    end
    
    for colNum = 1: 1: p
        column = covariance(:, colNum);
        testInverse(:, colNum) = calcBeta(covariance, colNum, column, lambda);
    end
    
    inverse = testInverse;
        
end

function [beta] = calcBeta(covariance, colNum, column, lambda)
    global p;
    
    f = [ones(1, p), -1 .* ones(1, p)];
    space = zeros(p, p);
    identity = eye(p, p);
    A = [covariance, covariance; -covariance, -covariance; -identity, space; space, identity];
    
    
    b = [linspace(lambda, lambda, 2 * p) zeros(1, 2 * p)];
    b(colNum) = b(colNum) + 1;
    secondPos = colNum + p;
    b(secondPos) = b(secondPos) - 1;
    
    assignin('base', 'A', A);
    assignin('base', 'b', b);
    assignin('base', 'f', f);
    betaPartials = linprog(f, A, b);
    assignin('base', 'betaPartials', betaPartials);
    beta = betaPartials([1: p]) + betaPartials([p + 1: end]);
end