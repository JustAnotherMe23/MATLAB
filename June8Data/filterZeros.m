function [remainderD, remainderL, remainderC] = filterZeros(data, labels, colors)
    dataSum = sum(data');
    [a, b] = size(data);
    position = 1;
    while position <= a
        if dataSum(position) == 0
            data(position, :) = [];
            dataSum(position) = [];
            labels(position) = [];
            a = a - 1;
            continue;
        end
        position = position + 1;
    end
    
    remainderD = data;
    remainderL = labels;
    remainderC = colors;
end