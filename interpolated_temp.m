clear all
clc

% warm temperature x (chose time interval when it was fixed)
x = 65.8;
% cold temperature y
y = [53.2;53.1;53.1;52.9;52.9;52.9;52.9;52.7;52.7;52.7;52.7;52.5;52.5;52.5;52.5;52.5;52.3;52];
% times of measurements of x and y    
t = [1481;1492;1503;1514;1526;1537;1548;1559;1571;1582;1593;1604;1616;1627;1638; 1649;1661;1672];
N = length(t);

% times of measurements of cavity temperatures te
te = [1489.27; 1503.73;1518.25;1532.75;1547.23;1561.73;1576.20; 1590.70; 1605.20;1619.67;1634.15;1648.65;1663.15];
% measured cavity temperatures
Te = [63.8;63.8;63.8;63.7;63.7;63.7;63.6;63.5;63.5; 63.4; 63.4; 63.3; 63.3];
% times less than te
t_l = [1481;1503;1514;1526;1537;1559;1571;1582;1604;1616;1627;1638;1661];
% times greater than te
t_g = [1492;1514;1526;1537;1548;1571;1582;1593;1616;1627;1638;1649;1672];
% cold temperatures at times t_l
y_l = [53.2;53.1;52.9;52.9;52.9;52.7;52.7;52.7;52.5;52.5;52.5;52.5;52.3];
% cold temperatures at times t_g
y_g = [53.1;52.9;52.9;52.9;52.9;52.7;52.7;52.7;52.5;52.5;52.5;52.5;52];
M = length(Te);
K = length(y_g);

% compute y1 (cold temperatures at times te)
for k = 1:K
    % use y1=y_l+m*(te-t_l); 
    %slope m=(y_g-y_l)/(t_g-t_l) for each of the times te and t_l
    m(k) = (y_g(k) - y_l(k)) / (t_g(k) - t_l(k));
    y1(k) = y_l(k) + m(k) * (te(k) - t_l(k));
end

figure(1)
plot(t, y, 'o', 'LineWidth', 2)
hold on
plot(te, y1, '*', 'LineWidth', 2)
xlabel('time,min')
ylabel('Exterior temperature,^{o}F')
legend('measured', 'interpolated')

