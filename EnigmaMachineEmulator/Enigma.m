clc;
clear;
close all;

fprintf('Welcome to the Engima Machine Emulator\n')

run = 'Y';
dailyKey = [0, 0, 0];
rotors = [1, 2, 3];
pairs = [''];
reflect = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'I' 'J' 'K' 'M' 'T' 'V';...
    'Y' 'R' 'U' 'H' 'Q' 'S' 'L' 'P' 'X' 'N' 'O' 'Z' 'W'];
global R_0;
R_0 = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O'...
    'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
global R_1;
R_1 = ['E','K','M','F','L','G','D','Q','V','Z','N','T','O','W','Y',...
        'H','X','U','S','P','A','I','B','R','C','J'];
global R_2;
R_2 = ['A','J','D','K','S','I','R','U','X','B','L','H','W','T','M',...
        'C','Q','G','Z','N','P','Y','F','V','O','E'];
global R_3;
R_3 = ['B','D','F','H','J','L','C','P','R','T','X','V','Z','N','Y',...
        'E','I','W','G','A','K','M','U','S','Q','O'];
global R_4;
R_4 = ['E','S','O','V','P','Z','J','A','Y','Q','U','I','R','H','X',...
        'L','N','F','T','G','K','D','C','M','W','B'];
global R_5;
R_5 = ['V','Z','B','R','G','I','T','Y','U','P','S','D','N','H','L',...
        'X','A','W','M','J','Q','O','F','E','C','K'];

while strcmpi(run, 'Y')
    
    choice = menu(dailyKey, rotors, pairs);
    if choice == 0
        if sum(dailyKey > 0) < 3
            fprintf('\n\nPlease enter the daily key settings first\n\n');
            continue;
        end
        messageIn = input('Please enter the message: ', 's');
        [print, extra] = translate(dailyKey, rotors, pairs, reflect, messageIn);
        fprintf('\n\nOutput:\n');
        fprintf(print);
        input('\n\nPress Enter to continue');
        fprintf('\n\n');
    elseif choice == 1
        [rotors] = rotorSettings(rotors);
    elseif choice == 2
        [dailyKey] = dailyKeySettings(dailyKey);
    elseif choice == 3
        [pairs] = pairSettings(pairs);
    elseif choice == 4
        fileConvert(pairs, reflect);
    elseif choice == 5
        break;
    end
end
    