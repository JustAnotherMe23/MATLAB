function [ finalData, finalLabels, finalColors ] = large2Small2( data, labels, colors )
    checkData = sum(data');
    orderedData = sort(checkData, 'descend');
    
    len = length(orderedData);
    saveSeat = 0;
    finishedLabels = {};
    finishedDate = [];
    finishedColors = [];
    for look = 1: 1: len
        for position = 1: 1: len
            if checkData(position) == orderedData(look) & position > saveSeat
                finishedLabels(look) = labels(position);
                finishedData(look, :) = data(position, :);
                finishedColors(look, :) = colors(position, :);
                saveSeat = position;
                break;
            end
        end
        
         if length(checkData) - look >= 1
             if orderedData(look) ~= orderedData(look + 1)
                 saveSeat = 0;
             end
         end
    end
    
    
    finalLabels = finishedLabels;
    finalData = finishedData;
    finalColors = finishedColors;
end
