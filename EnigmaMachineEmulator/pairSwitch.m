function var = pairSwitch(char,pairs)
%This function determines if a letter's start point
%changes to its (possibly) paired value
%   char is the character being compared to the first row of pairs
%   from the pairs vector.
%   var will or will not change based on the values in pairs.
[r, c] = size(pairs);
valid = 0;
if c > 0
    for i = 1:1:2
        for ii = 1:1:length(pairs(i,:))
            if i == 2 && pairs(i,ii)==char
               var = pairs(i-1,ii);
               valid = 1;
            elseif pairs(i,ii)==char && i==1
               var = pairs(i+1,ii);
               valid = 1;
            end
        end
    end
end
 
if valid == 0
    var = char;
end