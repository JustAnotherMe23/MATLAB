function [beta] = minBeta(columnNum, covariance, lambda, limit, interval)
    height = length(covariance);
    eTest = zeros(height, 1);
    eTest(columnNum, 1) = 1;
    
    testSpace = linspace(-limit, limit, interval);
    
    numRec = 1;
    testColumn = NaN(height, 1);
    [result, min0] = findColumn(numRec, testColumn, testSpace, lambda, covariance, eTest);
    min0
    if min0 >= lambda
        print('No estimation found');
        beta = 0;
    else
        beta = result;
    end
end


function [result, min0] = findColumn(numRec, testColumn, testSpace, lambda, covariance, eTest)

    min = lambda;
    column = NaN(length(testColumn), 1);

    if numRec == length(testColumn)
        for point = testSpace
            testColumn(numRec, 1) = point;
            testMin = findMin(testColumn, covariance, eTest);
            if testMin < min
                min = testMin;
                column = testColumn;
            end
        end
    else
        for point = testSpace
            testColumn(numRec, 1) = point;
            [testResult, testMin] = findColumn(numRec + 1, testColumn, testSpace, lambda, covariance, eTest);
            if testMin < min
                column = testResult;
                min = testMin;
            end
        end
    end
    result = column;
    min0 = min;
end

function [min0] = findMin(testColumn, covariance, eTest)
    minMatrix = covariance * testColumn - eTest;
    min0 = abs(max(minMatrix));
end