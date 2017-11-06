clear;
clc;
close all;
format compact;

TitleFontSize = 25;
LabelFontSize = 16;

filename = input('Please enter the filename: ', 's');
rawData = xlsread(filename);

Data = rawData(:, 5);

timestamp = [];
count = [];
position = 1;
for point = Data
    if point > timestamp+5 | count(position - 1) > 5
        timestamp(position) = Data;
        count(position) = 1;
        position = position + 1;
    else
        count(position - 1) = count(position - 1) + 1;
        
    