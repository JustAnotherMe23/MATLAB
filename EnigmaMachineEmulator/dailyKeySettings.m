function [ X ] = dailyKeySettings( dailyKeySettings )
%This uses the daily key settings to set the rotor to the correct position
% 
% dailyKeySettings=[a,b,c];
if sum(dailyKeySettings)==0  
    dailyKeySettings=input('Please input starting positions for the three rotors in the form of a vector: ');
end
while length(dailyKeySettings)~=3
    dailyKeySettings=input('ERROR there can only be three rotor settings: ');
end
A=dailyKeySettings(1); 
B=dailyKeySettings(2); 
C=dailyKeySettings(3);
while A<=0 || rem(A,1)~=0 || A>=27 || B<=0 || rem(B,1)~=0 || B>=27 || C<=0 || rem(C,1)~=0 || C>=27
   dailyKeySettings=input('ERROR the starting positions must be in the form of a posiitive interger less than 26: ');
   while length(dailyKeySettings)~=3
    dailyKeySettings=input('ERROR there can only be three rotor settings: ');
    end
   A=dailyKeySettings(1);
   B=dailyKeySettings(2);
   C=dailyKeySettings(3);
  
end
X=[A,B,C];
end