function [remainderD, remainderL, remainderC, count] = filterZeroes(data, labels, colors)
    a = length(data);
    position = 1;
    while position <= a
        if data(position) == 0
            data(position) = [];
            labels(position) = [];
            colors(position, :) = [];
            a = a - 1;
            continue;
        end
        position = position + 1;
    end
    
    remainderD = data;
    remainderL = labels;
    remainderC = colors;
    count = a;
end