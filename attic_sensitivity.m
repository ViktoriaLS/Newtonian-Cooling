clc
clear all
in=68;
out=-40;
s=0.009;
r=0.018
%r=0.02;
% Let to be initial value of t
t0=0;
% Let t_fin be the final value of t (t is in the inteval [t0, t_fin])
t_fin=200.0;
% define a vector valued function f(t,y). 
%It is a vector of right hand sides of our system of differential equations
f=@(t,y) [-(r+s)*y(1)+r*in+s*out;-(r+s)*y(2)-y(1)+in;-(r+s)*y(3)-y(1)+out];
%Now we are redy to solve the system, we just need to define its initial
%conditions. Let y0 be thevector of initial conditions
y0=[60.0;0.0;0.0];
% ode45 is a build-in MATLAB function. It uses Runge-Kutta4 method to solve
% diff equations. In this example, ode45 returns a vector ts of t values
% and an array Ys: each row of Ys contains the values for Y(1) and Y(2)
[ts,ys]=ode45(f,[t0,t_fin],y0);

n=length(ys(:,1))

disp([ts,ys]);
z1=0.0;
z2=0.0;
for i=1:n
    s1(i)=r*ys(i,2)/ys(i,1);
    s2(i)=s*ys(i,3)/ys(i,1);
    z1=z1+s1(i)^2;
    z2=z2+s2(i)^2;
end

s1_norm=sqrt(z1)
s2_norn=sqrt(z2)

figure(1);
%ys(:,1) gives y(t) for all t; ys(:,2) gives y(1) as a funtion of t for all t
% PLOT the function y(1) vs t
plot(ts,ys(:,1),'b','LineWidth',2)
hold on
grid on
yline(32)
xlabel('t, min','FontSize',14)
ylabel('T,^{o}F','FontSize',14)
legend('T','T_{eq}=-32^{o}F')

%n=length(y(:,1))


figure(2);clf
% PLOT the function y(2) vs t
plot(ts,s1,'k','Linewidth',2)
hold on
grid on
plot(ts,s2,'k--','Linewidth',2)
hold off
xlabel('t, min','FontSize',14)
legend('$\frac{\partial T}{\partial r} \frac{r}{T}$','$\frac{\partial T}{\partial s} \frac{s}{T}$','Interpreter','latex')




