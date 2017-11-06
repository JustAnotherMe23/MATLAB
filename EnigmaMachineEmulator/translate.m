function [ text, dailyKey ] = translate(dailyKey, rotors, pairs, reflect, messageIn)
%translate takes a string and converts it given the Enigma settings and a
%single line string
%   gets passed the rotor settings, the reflector pairs, and the message
%   After converting the string 1 character at a time, it outputs, the
%   translated string


    global R_0;% recalls the setup of all posible rotors
    global R_1;
    global R_2;
    global R_3;
    global R_4;
    global R_5;
    
    [r, c] = size(messageIn); % collects size data for the number of times that
    message = [];               % the function needs to loop
    settings = []; % creates empty vector to store the order and values of the rotors requires by the settings
    for set = 1: 1: 3% loops for all 3 positions of the rotor
        if rotors(set) == 1 % searches for the rotor required at position "set"
            settings(set, :) = R_1;
        elseif rotors(set) == 2
            settings(set, :) = R_2;% creates the ordered rotor values at position "set"
        elseif rotors(set) == 3
            settings(set, :) = R_3;
        elseif rotors(set) == 4
            settings(set, :) = R_4;
        elseif rotors(set) == 5
            settings(set, :) = R_5;
        end
    end
    
    for spot = 1: 1: c % Loops as many times as there are characters in the message
        charc = upper(messageIn(spot)); % converts the currents character to uppercase
        
        valid = 0;
        for check = 1: 1: 26 % checks to see if the character is in the alphabet. If yes, valid allows transformation
            if charc == R_0(check) % if not from alphabet, character will remain unchanged
                valid = 1;
            end
        end
        
        if valid == 1 % If character is in the alphabet, this will occur
            result = pairSwitch(charc, pairs); % first iteration of reciprocating in the plugboard
            result = mix(result, dailyKey, reflect, settings); % simulates the rotors and reflector
            result = pairSwitch(result, pairs);% second time through plugboard
            
            dailyKey(3) = dailyKey(3) + 1; % adds 1 to daily count to simulate upwards ticking
            if dailyKey(3) > 26% if 27 is reached, key at position 1 is reset
                dailyKey(3) = 1;
                dailyKey(2) = dailyKey(2) + 1;% adds 1 at next significant key number
            end
            if dailyKey(2) > 26 % same as above but for position 2
                dailyKey(2) = 1;
                dailyKey(1) = dailyKey(1) + 1;% Adds 1 to most significant key
            end
            if dailyKey(1) > 26 % Resets most significant number if necessary
                dailyKey(1) = 1;
            end
        else
            result = charc; % If not in alphabet, character is almost untouched
            if strcmp(result, '€') % Deletes extra letters resulting from appostrophes and quotes
                result = [];
            elseif strcmp(result, 'Â') % Same as above
                result = [];
            
            end
        end
        message = [message, result]; % Puts the new message together one character at a time
    end
    text = message; % returns the message
        
    
end

