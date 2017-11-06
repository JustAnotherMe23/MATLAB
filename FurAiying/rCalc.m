function [R] = rCalc(data) 
    n = length(data(:, 1));
    P = length(data(1, :));
    P1 = 0;
    result = NaN(P, P);
    
    sample = data(1, :);
    count = 0;
    for point = sample
        count = count + 1;
        if point ~= round(point)
            P1 = count;
            break;
        end
    end
    
    range = 1: 1: P;
    for y = range
        for x = range
            
            if y <= x
                row = y;
                column = x;
            else
                row = x;
                column = y;
            end
            
            sample = [data(:, row), data(:, column)];
            
            point = NaN;
            check1 = row >= P1;
            check2 = column >= P1;
            if ~check1 && ~check2
                point = discrete(sample, n);
            elseif check1 && check2
                point = continuous(sample, n);
            elseif ~check1 && check2
                point = disAndCon(sample, n);
            else
                fprintf('Logic incorrect, row = ' + x + ', column = ' + y + '\n');
                fprintf('Logic incorrect, row = ' + row + ', column = ' + column + '\n');
            end
            
            result(y, x) = point;
        end
    end
    
    R = result;
end

function [value] = discrete(sample, n)
    sum = 0;
  %  count = 0;
    for run = 1: 1: n - 1
        for cycle = run: 1: n
           
            sum = sum + (sample(run, 1) - sample(cycle, 1)) * (sample(run, 2) - sample(cycle, 2));
        end
    end
    
    result = sum * 2 / (n * (n - 1));
    value = result;
end

function [value] = disAndCon(sample, n)
    sum = 0;
 %   count = 0;
    for run = 1: 1: n - 1
        for cycle = run: 1: n
          %  count = count + 1;
            sum = sum + (sample(run, 1) - sample(cycle, 1)) * sign(sample(run, 2) - sample(cycle, 2));
        end
    end
    
    result = sum * 2 / (n * (n - 1));
    value = result;
end

%sorry, here is my mistake, we should calculate covariance instead of
%correlation
%there is also a function cov() you can use 
function [value] = continuous(sample, n)
    sum1 = 0;
 %   sum2 = 0;
  %  sum3 = 0;
    count = 0;
    firstAve = sum(sample(:, 1)) / n;
    secondAve = sum(sample(:, 2)) / n;
    for run = 1: 1: n
        count = count + 1;
        sum1 = sum1 + (sample(run, 1) - firstAve) * (sample(run, 2) - secondAve);
   %     sum2 = sum2 + (sample(run, 1) - firstAve) ^ 2;
   %     sum3 = sum3 + (sample(run, 2) - secondAve) ^ 2;
    end
    
    result = sum1; % / (sum2 ^ (1/2) * sum3 ^ (1/2));
    value = result;
end