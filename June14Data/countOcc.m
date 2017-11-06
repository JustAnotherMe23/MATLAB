function [ counts ] = countOcc( data )

[rows, columns] = size(data);
finishedCounts = zeros(1, 8);

for error = 1: 1: 8
    for a = 1: 1: 9
        for b = 1: 1: rows
            if data(b, (error - 1) * 9 + a) ~= 0
                finishedCounts(error) = finishedCounts(error) + 1;
            end
        end
    end
end

counts = finishedCounts;

end