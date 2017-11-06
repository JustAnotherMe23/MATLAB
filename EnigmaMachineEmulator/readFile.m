function [rotorS,rotorPos] = readFile()
%This function reads in the specific day input from a specific month
%    month = specified month
%    day = specified day
month = input('Please input what month it is (no.1-12):\n');
while month<=0 || month>=13 || round(month)~=month
    fprintf('Error: Please input a positive integer between 1-12:\n')
    month = input('');
end
if sum([1:2:7]==month) || sum([8:2:12]==month)
    max_day = 31;
elseif month==2
    fprintf('Would it happen to be a leap year? Please intput Y/N: ');
    leap = input('','s');
    while ~strcmpi(leap,'Y') && ~strcmpi(leap,'N')
        leap = input('\nError: Please input either Y/N for leap year: ','s');
    end
    if strcmpi(leap,'Y')
        max_day = 29;
    elseif strcmpi(leap,'N')
        max_day = 28;
    end
else
    max_day = 30;
end
fprintf('Please input what day it is (no.1-%0.0f): ',max_day);
day = input('');
while day<=0 || day>(max_day) || round(day)~=day
    fprintf('\nError: Please input a positive integer between 1-%0.0f for the day: ',max_day);
    day = input('');
end
data = csvread('calendar.csv',0,0);
data_wanted = data(day,(month*3-2):month*3);
rotorS = [];
rotorPos = [];
for i = 1:1:length(data_wanted)
    r = rem(data_wanted(i),100);
    rotorPos(end+1) = r;
    amount = (data_wanted(i) - r)/100;
    rotorS(end+1) = amount;
end

