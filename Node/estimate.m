function return_value = estimate(d , angle,refangle )
%ESTIMATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if refangle <90
x =d*cos(angle);
y = d*sin(angle);
elseif refangle >=90   && refangle <180
y = d*sin(angle);
x =  d*cos(angle);
elseif  refangle >=180
x =  d*sin(angle);
y = d*cos(angle);
end 
 


return_value=[x, y];
end

