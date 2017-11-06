function [ x ] = fileConvert(pairs, reflect)

    fidRead = -1;
    
    while fidRead < 0
    fileName = input('Please input the file name: ', 's');
    
    fidRead = fopen(fileName, 'r');
    
        if fidRead < 0
            fprintf('ERROR! Please make sure the file entered exists in this directory\n');
            fprintf('and that the name entered contains the extension .txt\n');
        end
    end
    
    [rotors, dailyKey] = readFile();
    
    newFile = strcat('converted', fileName);
    fidWrite = fopen(newFile, 'w');
    text = fgetl(fidRead);
    while ~(sum(ischar(text)) & sum(text == -1))
        
        [print, dailyKey] = translate(dailyKey, rotors, pairs, reflect, text);
        
        if length(print) == 0
            fprintf(fidWrite, '\n');
        else
            count = 0;
            for charc = print
                count = count + 1;
                if strcmp(charc, 'î')
                    print(1, count) = 'î';
                end
            end
            fprintf(fidWrite, print);
            fprintf(fidWrite, '\n');
        end
        text = fgetl(fidRead);
        
        if text == -1
            break;
        end
    end

    fprintf('Complete\n');

    fclose(fidWrite);
    fclose(fidRead);
    
    x = 1;
end

