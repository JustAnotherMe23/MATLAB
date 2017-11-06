function [ choice ] = menu(dailyKey, rotors, pairs)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    a = 1;
    
    while a == 1
        fprintf('Rotor Choices:\n');
        fprintf('%i\t', rotors);
        fprintf('\n\n')

        fprintf('Daily Key Settings:\n');
        fprintf('%i\t', dailyKey);
        fprintf('\n\n');

        [r, c] = size(pairs);
        
        if c > 0
            [r, c] = size(pairs);
            
            fprintf('Matched Pairs:\n');
            for look = 1: 2: r * c
                fprintf('%s and %s\n', pairs(look), pairs(look + 1));
            end
            fprintf('\n\n');
        end
        

        fprintf('To translate a message enter 0\n');
        fprintf('To change the rotor settings enter 1\n');
        fprintf('To change the daily key setting enter 2\n');
        fprintf('To change the letter pairs enter 3\n');
        fprintf('To translate a text file enter 4\n');
        fprintf('To end the program enter 5\n');

        choice = input('');
        
        if choice ~= round(choice) | choice > 5 | choice < 0
            fprintf('ERROR! invalid input');
            continue;
        end
        a = 0;
end