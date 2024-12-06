clc
clear all 
% time, min
t=[1346;1357;1368;1379;1391;1402;1413;1424;1436;1447;1458;1469;1481;1492;
    1503;1514;1526;1537;1548;1559;1571;1582;1593;1604];
% exterior temperature
y=[54.5;54.3;54.1;54;54;53.8;53.8;53.8;53.6;53.4;53.4;53.2;53.2;53.1;53.1;
   52.9;52.9;52.9;52.9;52.7;52.7;52.7;52.7;52.5];

for n=1:length(t)
    tt(n)=t(n)-t(1);
end
% linear fitting 
p=polyfit(tt,y,1)

% p(1) is the slope "a" and p(2) is the intercept "b" in y=at+b
y1=polyval(p,tt);

plot(t,y,'o','LineWidth',2)
hold on
plot(t,y1,'LineWidth',2)
xlabel('t,min')
ylabel('Exterior Temperature,^{o}F')
legend('measured y(t)','approximated y(t)=a_1t+b_1')

