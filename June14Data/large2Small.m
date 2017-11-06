function [ finalData, finalLabels, finalColors ] = large2Small( data, labels, colors )
    finalData = sort(data, 'descend');
    
    len = length(finalData);
    saveSeat = 0;
    finishedLabels = {};
    finishedColors = [];
    for look = 1: 1: len
        for position = 1: 1: len
            if data(position) == finalData(look) & position > saveSeat
                finishedLabels(look) = labels(position);
                finishedColors(look, :) = colors(position, :);
                saveSeat = position;
                break;
            end
        end
        
        if length(data) - look >= 1
             if finalData(look) ~= finalData(look + 1)
                 saveSeat = 0;
             end
         end
    end
    
    finalColors = finishedColors;
    finalLabels = finishedLabels;
end
