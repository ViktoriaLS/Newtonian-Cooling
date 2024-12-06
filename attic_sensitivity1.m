clc
clear all
b2=68;
b1=-40;
r=0.02;
s=0.009;
params=[r, s];
Num_samples=200;
QoI=zeros(1,Num_samples);
parameters=lhsdesign(Num_samples,length(params));
l_bounds = .85*params
u_bounds = 1.15*params
parameters_scaled=zeros(size(parameters));
for i=1:Num_samples
 parameters_scaled(i,:)=(u_bounds-l_bounds).*parameters(i,:)+l_bounds;
end

for i =1:Num_samples
    params_i=parameters_scaled(i,:);
    disp(i);
    disp(params_i(1));
    eta(i)=params_i(1)/params_i(2);
   QoI(i)=(eta(i)*b2+b1)/(eta(i)+1);
   if QoI(i)<=32 
       disp(QoI(i))
      disp(params_i)
   end
end

cc=zeros(1,2);
for j = 1:length(params)
  CC=corrcoef(parameters_scaled(:,j), QoI)
   cc(j)=CC(1,end)
end


figure(1)
bar_width=.1;
p_names=['$r$', '$s$'];
hold on
%bar(cc)
%bar([1:length(params)]-1*bar_width,cc,bar_width ,'b')
%bar([1:length(params)]-0*bar_width,cc_100, bar_width,'c')
bar([1:length(params)]+1*bar_width,cc, bar_width,'b')
%bar([1:length(params)]+1*bar_width,cc_200, bar_width,'r')
xticks(1:length(params))
xticklabels({'$r$', '$s$'})
title('correlation coefficients')
%legend('50 Samples', '100 Samples','150 Sampes','200 Samples')



% =============================================================================
figure(2)
% number here is the parameter number changing from 1 to 2
scatter(parameters_scaled(:,1),QoI)
% 1 is for r
xlabel('$r, min^{-1}$', 'Interpreter','Latex',fontsize=16)
% 2 is for s
%xlabel('$s, min^{-1}$', 'Interpreter','Latex',fontsize=16)
ylabel('$T_{\infty}, ^{o}F$','Interpreter','latex', fontsize=16)

figure(3)
rr = 0.015:0.0001:0.022;%
ss=0.004:0.001:0.011;
[rr,ss] = meshgrid(rr,ss)
Z=(b2*rr+b1*ss)./(rr+ss);
v=[32 32]
%surf(rr,ss,Z)
[M,c]=contour(rr,ss,Z,11,'ShowText','on')
xlabel('r, min^{-1}','FontSize',16)
ylabel('s, min^{-1}','FontSize',16)
title('Countour plot for T_e','FontSize',16)
