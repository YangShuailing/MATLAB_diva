clc;
clear all;

X_scape=20;%��ǵ�ĸ���
Sensor_Num = 100;%����������
load 'ES_Loc_Result.mat';
totalNum=size(Err,2);
Err=Err(~isnan(Err));%ȥ��û�ж�λ��������
ymax=max(Err);
x=linspace(0,ymax,X_scape); 
yy=hist(Err,x); %�����������ĸ��� 
yy=yy/totalNum; %�����������ĸ���
for i=2:size(x,2)
    yy(1,i)=yy(1,i-1)+yy(1,i);
end
plot(x, yy, 'k>-', 'LineWidth', 1, 'MarkerFaceColor', 'k');
 hold on;
xlabel('Positioning accuracy')
ylabel('CDF')
figure (2)
for x_i = 1:Sensor_Num 
    y_i = x_i*(x_i-1)+(x_i-1)+(x_i-1);%     ÿ���ڵ�ᷢn�����ݰ����յ�n-1�����ݰ���Leader�ڵ���յ�n-1�����ݰ�
plot(x_i,y_i,'k.') 

hold on
end
% legend('DSL');
xlabel('The number of nodes')
ylabel('The number of transmission data ')


