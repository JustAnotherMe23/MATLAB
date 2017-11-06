function [omega] = minOmega(corr, limit, interval)

    global E p testSpace;
    E = corr;
    p = length(corr);

    testSpace = linspace(-limit, limit, interval)

    numRec = 1;
    testMatrix = NaN(p, p);
    [result, min0] = findMatrix(numRec, testMatrix);

    if min0 == 100
        print('No estimation found');
        omega = 0;
    else
        omega = result;
    end
end

function [result, min0] = findMatrix(numRec, testMatrix)
    global p;
    global testSpace;

    fprintf("\n" + numRec);
    row = ceil(numRec / p);
    column = mod(numRec, p);
    min = 100;
    matrix = NaN(p, p);
    
    if column == 0
        column = p;
    end

    if numRec == p ^ 2
        for point = testSpace
            testMatrix(row, column) = point;
            valid = filterNeg(testMatrix);
            if valid
                testMin = findMin(testMatrix);
                if testMin < min
                    min = testMin;
                    matrix = testMatrix;
                end
            end
        end
    else
        for point = testSpace
            testMatrix(row, column) = point;
            [testResult, testMin] = findMatrix(numRec + 1, testMatrix);
            if testMin < min
                matrix = testResult;
                min = testMin;
            end
        end
    end 
    result = matrix;
    min0 = min;
end

function [accuracy] = findMin(testMatrix)
    global E;
    
    distances = trace(E * testMatrix) - log(abs(testMatrix));
    accuracy = min(min(distances));
end

function [valid] = filterNeg(test) %Shows if determinant of test (omega) is less than 0
    global p;
    
    true = 1;
    for div = 1: 1: p
        sub = test(1:p, 1:p);
        if det(sub) < 0
            true = 0;
        end
    end
    valid = true;
end