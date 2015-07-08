clc;
clear all;

X_scape=20;%标记点的个数
Sensor_Num = 100;%传感器个数
load 'ES_Loc_Result.mat';
totalNum=size(Err,2);
Err=Err(~isnan(Err));%去除没有定位结果的情况
ymax=max(Err);
x=linspace(0,ymax,X_scape); 
yy=hist(Err,x); %计算各个区间的个数 
yy=yy/totalNum; %计算各个区间的概率
for i=2:size(x,2)
    yy(1,i)=yy(1,i-1)+yy(1,i);
end
plot(x, yy, 'k>-', 'LineWidth', 1, 'MarkerFaceColor', 'k');
 hold on;
xlabel('Positioning accuracy')
ylabel('CDF')
figure (2)
for x_i = 1:Sensor_Num 
    y_i = x_i*(x_i-1)+(x_i-1)+(x_i-1);%     每个节点会发n个数据包，收到n-1个数据包，Leader节点会收到n-1个数据包
plot(x_i,y_i,'k.') 

hold on
end
% legend('DSL');
xlabel('The number of nodes')
ylabel('The number of transmission data ')


