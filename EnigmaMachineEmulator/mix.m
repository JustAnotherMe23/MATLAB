function [ result ] = mix(char, dailyKey, reflect, settings);
%Mix simulates the passing of a letter though the rotors of an Enigma
%machine
%   letter must go through rotors, then pass through reflector, then back
%   through rotors. The resulting character is returned


    global R_0; % Recalls the original matrix for alphabetic

    after1 = settings(1, scale(reduce(char) + dailyKey(3) - 65)); % Simulates 1st rotor. Uses Ascii value to find position of letter in alphabet, then adds daily key setting of the rotor
    % The number given is the position that of the letter that is assined
    % to "after1"
    after2 = settings(2, scale(reduce(after1) + dailyKey(2) - 65)); % rotor 2
    after3 = settings(3, scale(reduce(after2) + dailyKey(1) - 65)); % rotor 3
    afterR = pairSwitch(after3, reflect); % Same function used for the plugboard is used for the reflector
    % Letter passed is switched with it's reciprocal in the reflect matrix
    count = 66 - dailyKey(1); % Adjust the count to the Ascii value of the alphabet, subtracting the daily key to adjust
    for comp = settings(3, :) % Searches rotor 3 for the postion of the current letter
        if afterR == comp % the Ascii value is the letter output by rotor three
            back1 = count;
            break;
        end
        count = count + 1;
    end
    back1 = reduce(back1); % this variable holds the resulting output Ascii value
    
    count = 66 - dailyKey(2); % Same as above, but for rotor 2
    for comp = settings(2, :)
        if back1 == comp
            back2 = count;
            break;
        end
        count = count + 1;
    end
    back2 = reduce(back2);
    
    count = 66 - dailyKey(3); % for rotor 1
    for comp = settings(1, :)
        if back2 == comp
            back3 = count;
            break;
        end
        count = count + 1;
    end
    back3 = reduce(back3);
    
    for stop = R_0 % Returns the final output value into an actual letter
        if back3 == stop - 0
            result = stop;
        end
    end
    

end

function [red] = reduce(num) % Adjustment function to account for reaching outside of matrix limits
    while num > 'Z' % If number is too high, say 27, will become 1 to cycle through rotor again
        num = num - 26;
    end
    while num < 'A' % Same, but accounts for too low numbers
        num = num + 26;
    end
    red = num;
end

function [scl] = scale(num) % Same as above function, but for Ascii values rather than rotor position
    while num > 'Z' - 64
        num = num - 26;
    end
    while num < 'A' - 64
        num = num + 26;
    end
    scl = num;
end
