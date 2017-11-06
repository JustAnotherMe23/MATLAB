%% Enigma Machine - Rotors
%Asks for what rotors are needed
%-input is only a string with no numbers
function [rotors] = rotorSettings(rotors);
    fprintf('Listed below are 5 different rotors')
    %Tru = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',...
    %    'P','Q','R','S','T','U','V','W','X','Y','Z'];
    R_1 = ['E','K','M','F','L','G','D','Q','V','Z','N','T','O','W','Y',...
        'H','X','U','S','P','A','I','B','R','C','J']
    R_2 = ['A','J','D','K','S','I','R','U','X','B','L','H','W','T','M',...
        'C','Q','G','Z','N','P','Y','F','V','O','E']
    R_3 = ['B','D','F','H','J','L','C','P','R','T','X','V','Z','N','Y',...
        'E','I','W','G','A','K','M','U','S','Q','O']
    R_4 = ['E','S','O','V','P','Z','J','A','Y','Q','U','I','R','H','X',...
        'L','N','F','T','G','K','D','C','M','W','B']
    R_5 = ['V','Z','B','R','G','I','T','Y','U','P','S','D','N','H','L',...
        'X','A','W','M','J','Q','O','F','E','C','K']
    valid = 0;
    while valid == 0
        fprintf(['Please choose 3 out of the 5 different rotors',...
            '\nyou''d like to use for today''s cipher, i.e. [3 4 5]:\n'])
        rotors = input('');
        if length(rotors)>=4||length(rotors)<=2||sum((rotors<=0))>0||sum((rotors>=6))>0
            fprintf('\nERROR: Make sure there are only 3 postive integers between 1-5:\n');
            continue;
        end
        if rotors(1)==rotors(2)||rotors(1)==rotors(3) || rotors(2)==rotors(3)
            fprintf('\nERROR: Please re-enter the rotors you''d like.');
            fprintf('\nPlease DO NOT enter duplicates or triplets of the same value.\n')
            continue;
        end
        valid = 1;
    end
   
end