clear all
clc

te=[1793.57;1808.08;1865.47;1879.95;1894.43;1908.92;1923.42;1937.90;1952.37;1966.87];
Te=[62.9;62.9;62.7;62.7;62.7;62.7;62.6;62.6;62.6;62.5];

N=length(te)

M=length(Te)

fun=@(l,te)(l(1)*exp(-l(2)*te)+l(3)*te+l(4))

l0=[0.3, 0.02,-0.0022,65];

%l=lsqcurvefit(fun,l0,te,Te)

[l,resnorm,~,exitflag,output] = lsqcurvefit(fun,l0,te,Te)


t=linspace(te(1),te(end));


tt0=[1818;1829;1841;1852;1863;1874;1886];
% cold temp
y=[52.9;53.1;53.1;53.2;53.2;53.2;53.2];
% warm temp
x=[65.3;65.3;65.1;65.1;65.1;65.1;64.9];


for n=1:length(tt0)
    tt(n)=tt0(n)-tt0(1)
end




p1=polyfit(tt,y,1)
p2=polyfit(tt,x,1)

% p(1) is a and p(2) is b in y=at+b
y1=polyval(p1,tt)
x1=polyval(p2,tt);





%start




figure(1)
plot(te,Te,'*')
hold on
plot(t,fun(l,t),'k');
%plot(te,y2,'g')
xlabel('t,min')
ylabel('Temperature,^{o}F')
legend('observed temp T_e(t)','approx: T_{e_{app}}(t)=Ce^{-kt}+A*t+B')

figure(2)
plot(tt,y,'o')
hold on
plot(tt,y1)
xlabel('t,min')
ylabel('Temperature,^{o}F')
legend('cold temp measured y(t)','cold temp (lin approx) y_{app}(t)=a_1 t+b_1')

figure(3)
plot(tt,x,'o')
hold on
plot(tt,x1)
xlabel('t,min')
ylabel('Temperature,^{o}F')
legend('cold temp measured y(t)','cold temp (lin approx) x_{app}(t)=a_2 t+b_2')


l1=0.3;
l2=0.02;
l3=-0.0022;
l4=66.7704;
a1=0.0040;
b1=45.6221;
a2=-0.0049;
b2=71.1185;
ttt=linspace(1800,2000,100)
yy1=a1*t+b1;
xx1=-0.0051*t+74.6011;
T=l1*exp(-l2*t)+l3*t+l4;
figure(4)
plot(tt0,x,'ro')
hold on
plot(ttt,xx1,'r');
plot(tt0,y,'bo')
plot(ttt,yy1,'b')
plot(te,Te,'k*')
plot(ttt,T, 'k')


%plot(tt,y1)

xlim([1800 2000])
xlabel('t,min')
ylabel('Temperature,^{o}F')
legend('x(t)','x(t)_{model}','y(t)','y(t)_{model}','T(t)', 'T(t)_{model}')








