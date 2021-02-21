function [Lout]=look_up_table(Lin)

Lout=zeros(size(Lin));

for i=1:length(Lin)
    if Lin(i)<30 
        Lout(i)=Lin(i);
    elseif Lin(i)==30
        Lout(i)=Lin(i)+2;
    elseif Lin(i)==35
        Lout(i)=Lin(i)+4;
    elseif Lin(i)==40;
        Lout(i)=Lin(i)+6;
    elseif Lin(i)==45;
        Lout(i)=Lin+10;
    elseif Lin(i)==50
        Lout(i)=Lin(i)+15;
    elseif Lin(i)==55
        Lout(i)=Lin(i)+20;
    elseif Lin(i)==60
        Lout(i)=Lin(i)+25;
    elseif Lin(i)==65
        Lout(i)=Lin(i)+30;
    elseif Lin(i)==70
        Lout(i)=Lin(i)+35;
    elseif Lin(i)==75
        Lout(i)=Lin(i)+40;
    elseif Lin(i)==80
        Lout(i)=Lin(i)+45;
    elseif Lin(i)==85;
        Lout(i)=Lin(i)+50;
    elseif Lin(i)==90
        Lout(i)=Lin(i)+55;
    elseif Lin(i)==95;
        Lout(i)=Lin(i)+60;
    elseif Lin(i)==100;
        Lout(i)=Lin(i)+65;
    end
end

