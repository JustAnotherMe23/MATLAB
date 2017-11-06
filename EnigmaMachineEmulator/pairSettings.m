function [ M ] = pairSettings( pairs )
%Ask user for the number of pairs and then tells them to input said pairs
%   Detailed explanation goes here
 pairs=input('How many pairs would you like to have on the plug board: ');
 while pairs<0 || pairs>=14 || rem(pairs,1)~=0
     pairs=input('ERROR! The number of pairs must be an interger between 0 and 13: ');
 end
 Tru = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',...
       'P','Q','R','S','T','U','V','W','X','Y','Z'];
 if pairs==0
     M=[];
 else
    bank = [];
    for ii=1:pairs
        M(1,ii)=input('Input the first letter of the pair: ','s');
        while sum(bank==M(1,ii))>0 || sum(Tru==M(1,ii))==0
            M(1,ii)=input(['ERROR! this letter is already in a pair',...
                '\nLetter must be uppercase. No numbers. Please reenter: '],'s');
        end
          bank(end+1)= M(1,ii);
        M(2,ii)=input('Input the second letter of the pair: ','s');
        while sum(bank==M(2,ii))>0 || sum(Tru==M(2,ii))==0
            M(2,ii)=input(['ERROR! this letter is already in a pair',...
                '\nLetter must be uppercase. No numbers. Please reenter: '],'s');
        end
          bank(end+1)= M(2,ii);
        
    end
 end
 
end