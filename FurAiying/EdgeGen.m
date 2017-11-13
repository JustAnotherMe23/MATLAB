clear;
clc;
close all;

load('fMRI_preproc.mat');

lengthData = length(roiClass);
lengthTest = roiClass(end);

[height, width] = size(im_sorted);
testData = zeros(height, lengthTest);

for tall = 1: 1: height
    repCount = zeros(1, lengthTest);
    for long = 1: 1: width
        repCount(roiClass(long)) = repCount(roiClass(long)) + 1;
        testData(tall, roiClass(long)) = im_sorted(tall, long) + testData(tall, roiClass(long));
    end
end

for tall = 1: 1: height
    for long = 1: 1: roiClass(end)
        testData(tall, long) = testData(tall, long) / repCount(long);
    end
end

irrTestData = testData([1: 92], :);
healthyTestData = testData([93: end], :);

irrCorr = corrcoef(irrTestData);
healthyCorr = corrcoef(healthyTestData);

function [Z] = fishTrans(corMat)
    Z = 1/2
end