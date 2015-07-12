function [loc] = TDOA_SolveEquations(P1,P2,P3,Delta_t12,Delta_t13,targetloc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x1=P1(1,1);
y1=P1(1,2);
x2=P2(1,1);
y2=P2(1,2);
x3=P3(1,1);
y3=P3(1,2);

k1 = x1.^2 + y1.^2;
k2 = x2.^2 + y2.^2;
k3 = x3.^2 + y3.^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以12，13构造双曲线求交点
x21 = x2-x1;
y21 = y2-y1;
r21 = Delta_t12 * 340;

x31 = x3-x1;
y31 = y3-y1;
r31 = Delta_t13 * 340;
                
A=(x21*y31-y21*x31);
m1 = (y21*r31-r21*y31)/A;
m2 = (y21*(r31*r31-k3+k1)-y31*(r21*r21-k2+k1))/(2*A);
m3 = (x31*r21-x21*r31)/A;
m4 = (x31*(r21*r21-k2+k1)-x21*(r31*r31-k3+k1))/(2*A);
a = m1*m1+m3*m3-1;
b = 2*(m1*m2+m3*m4-m1*x1-m3*y1);
c = m2*m2+m4*m4+x1*x1+y1*y1-2*m2*x1-2*m4*y1;
r1 = (-b-sqrt(b*b-4*a*c))/(2*a);
r2 = (-b+sqrt(b*b-4*a*c))/(2*a);

loc = [m1*r1+m2 m3*r1+m4; m1*r2+m2 m3*r2+m4];
d1=norm(real(loc(1,:))-targetloc);
d2=norm(real(loc(2,:))-targetloc);
if d1<d2
    loc=real(loc(1,:));
else
    loc=real(loc(2,:));
end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以12，23构造双曲线求交点
% x12 = x1-x2;
% y12 = y1-y2;
% r12 = -1*Delta_t12 * 340;
% 
% x32 = x3-x2;
% y32 = y3-y2;
% r32 = (Delta_t13 - Delta_t12) * 340;
%                 
% A=(x12*y32-y12*x32);
% m1 = (y12*r32-r12*y32)/A;
% m2 = (y12*(r32*r32-k3+k2)-y32*(r12*r12-k1+k2))/(2*A);
% m3 = (x32*r12-x12*r32)/A;
% m4 = (x32*(r12*r12-k1+k2)-x12*(r32*r32-k3+k2))/(2*A);
% a = m1*m1+m3*m3-1;
% b = 2*(m1*m2+m3*m4-m1*x1-m3*y1);
% c = m2*m2+m4*m4+x1*x1+y1*y1-2*m2*x1-2*m4*y1;
% r1 = (-b-sqrt(b*b-4*a*c))/(2*a);
% r2 = (-b+sqrt(b*b-4*a*c))/(2*a);
% result_loc2 = [m1*r1+m2 m3*r1+m4; m1*r2+m2 m3*r2+m4];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%判断离得最近的两个交点作为定位结果
% min_d = inf;
% for i=1:size(result_loc1,1)
%     for j=1:size(result_loc2,1)
%         temp_d = norm(result_loc1(i,:) - result_loc2(j,:));
%         if temp_d < min_d
%             min_d = temp_d;
%             x = (result_loc1(i,1)+result_loc2(j,1))./2;
%             y = (result_loc1(i,2)+result_loc2(j,2))./2;
%             loc = [x y];
%         end
%     end
% end
end

