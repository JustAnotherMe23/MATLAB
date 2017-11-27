clear;
clc;
close all;

load('fMRI_preproc.mat'); % Loads data

lengthData = length(roiClass); % Gets length
lengthTest = roiClass(end); % Gets highest number to average across (for AAL w/ cerebellum is 116)

[height, width] = size(im_sorted);
testData = zeros(height, lengthTest);

for tall = 1: 1: height % Sort the data into AAL 116 by adding each region together
    repCount = zeros(1, lengthTest);
    for long = 1: 1: width
        repCount(roiClass(long)) = repCount(roiClass(long)) + 1;
        testData(tall, roiClass(long)) = im_sorted(tall, long) + testData(tall, roiClass(long));
    end
end

for tall = 1: 1: height % Divide each region by the number of occurences to get average
    for long = 1: 1: roiClass(end)
        testData(tall, long) = testData(tall, long) / repCount(long);
    end
end

irrTestData = testData([1: 92], :); %Seperate healthy and schizophrenic data
healthyTestData = testData([93: end], :);

irrCorr = corr(irrTestData); %Gen Correlation Matrix
healthyCorr = corr(healthyTestData);

irrZ = fishTrans(irrCorr); %Apply Fisher tranformation, defined at bottom
healthyZ = fishTrans(healthyCorr);

irrP = normcdf(irrZ); %Create p-value matrix
healthyP = normcdf(healthyZ);

irrEdgeWeighted = pFilter(irrP, irrCorr); %Delete data below certain threshold, defined below
healthyEdgeWeighted = pFilter(healthyP, healthyCorr);
irrEdgeBoolean = genBool(irrEdgeWeighted); %Creates unweighted data set, defined below
healthyEdgeBoolean = genBool(healthyEdgeWeighted);

irrBooleanString = formatString(irrEdgeBoolean); %Formats each matrix into printable string
irrWeightedString = formatString(irrEdgeWeighted);
healthyBooleanString = formatString(healthyEdgeBoolean);
healthyWeightedString = formatString(healthyEdgeWeighted);

a = heatmap(irrEdgeWeighted);
a.Title = "Patient Data";
figure;
b = heatmap(healthyEdgeWeighted);
b.Title = "Average Data";

fileIB = fopen('results/irrBoolean.edge', 'w'); %Print each string to .edge file
fprintf(fileIB, irrBooleanString);
fclose(fileIB);
fileIW = fopen('results/irrWeighted.edge', 'w');
fprintf(fileIW, irrWeightedString);
fclose(fileIW);
fileHB = fopen('results/healthyBoolean.edge', 'w');
fprintf(fileHB, healthyBooleanString);
fclose(fileHB);
fileHW = fopen('results/healthyWeighted.edge', 'w');
fprintf(fileHW, healthyWeightedString);
fclose(fileHW);

% End individual analyses

differenceEdge = healthyEdgeBoolean - irrEdgeBoolean; % Create boolean of paths that differ between 2 sets
absDifferenceEdge = abs(differenceEdge); % negatives would show paths that patients have a average does not
absDiffString = formatString(absDifferenceEdge); % format to printable string

fileDB = fopen('results/absDifference.edge', 'w'); % Print as edge file for brain net viewer
fprintf(fileDB, absDiffString);
fclose(fileDB);

% heatmap(absDifferenceEdge);

function [Z] = fishTrans(corMat) %Applies fisher transformation
    [h, ~] = size(corMat);
    Z =  sqrt(h - 3) * 1/2 * log((1 + corMat) ./ (1 - corMat));
end

function [edge] = pFilter(pValues, matrix) % Deletes Values that don't meet a certain p-value
    corr = matrix;
    [a, b] = size(pValues);
    count = 0;
    for row = 1: 1: a
        for column = 1: 1: b
            if row == column
                corr(row, column) = 0;
            elseif pValues(row, column) < 1 % Adjust acceptable p-value here
                corr(row, column) = 0;
                count = count + 1;
            end
        end
    end
    %fprintf(count + "\n");
    edge = corr;
end

function [boolean] = genBool(matrix) %If element in matrix is not zero, becomes 1
    [a, b] = size(matrix);
    result = zeros(a, b);
    for row = 1: 1: a
        for column = 1: 1: b
            if matrix(row, column)
                result(row, column) = 1;
            else
                result(row, column) = 0;
            end
        end
    end
    boolean = result;
end

function [formString] = formatString(matrix) %Formats data into printable string
    [a, b] = size(matrix);
    string = "";
    for row = 1: 1: a
        for column = 1: 1: b
            string = string + matrix(row, column) + "\t";
        end
        if row ~= a
            string = string + "\n";
        end
    end
    formString = string;
end