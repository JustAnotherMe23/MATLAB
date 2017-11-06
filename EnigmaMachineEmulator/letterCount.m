clear;
clc;
close all;

R_0 = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O'...
    'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];

percentCut = 5;
fileName = 'convertedLongText.txt';
fidRead = fopen(fileName, 'r');

text = fgetl(fidRead);
count = zeros(1, 27);

while ~(sum(ischar(text)) & sum(text == -1))

    for charc = text
        valid = 0;
        for compare = R_0
            if strcmpi(charc, compare)
                valid = 1;
                break;
            end
        end
            
        if valid
            letter = upper(charc) - 64;
            count(1, letter) = count(1, letter) + 1;
        end
    end

    text = fgetl(fidRead);

    if text == -1
        break;
    end
end
count(1, 27) = count(1, 26);
stairs(count);
xlim([1, 27]);
title('Occurence of Letters');
xlabel('Letter(Alphabetical)');
ylabel('Number of Occurences');
set(gca, 'XTick', 1: 1: 27);
set(gca, 'XTickLabel', {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z', ''});
fclose(fidRead);

count = count(1, [1:26]);
count = count * 100 / sum(count);

percentages = [];
letters = [];
lastmin = 0;
for column = 1: 1: 26
    min = 100;
    mark = 0;
    track = 26;
    for spot = count
        mark = mark + 1;
        if spot < min & spot > lastmin
            min = spot;
            track = mark;
        end
    end
    
    percentages(1, column) = min;
    lastmin = min;
    letters(1, column) = R_0(1, track)
end
letters = char(letters);

figure;
percentages(1, 27) = percentages(1, 26);
stairs(percentages);
xlim([1, 27]);
title('Occurence of Letters');
xlabel('Letter(Alphabetical)');
ylabel('Number of Occurences');
set(gca, 'XTick', 1: 1: 27);
set(gca, 'XTickLabel', {letters(1) letters(2) letters(3) letters(4) letters(5) letters(6) letters(7) letters(8) letters(9) letters(10) letters(11) letters(12) letters(13) letters(14) letters(15) letters(16) letters(17) letters(18) letters(19) letters(20) letters(21) letters(22) letters(23) letters(24) letters(25) letters(26), ''});
% 
% sum = 0;
% mark = 0;
% integral = zeros(1, 27);
% for a = percentages
%     mark = mark + 1;
%     if sum + a < percentCut
%         sum = sum + a;
%         integral(1, mark) = a;
%     end
% end
% 
% hold on;
% stairs(integral);