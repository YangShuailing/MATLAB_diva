clc;
clear all;
 
 
load 'DSL_Loc_Data_Ep.mat';
load 'DSL_Loc_Data_CO.mat';
load 'DSL_Loc_Data_Num_Err.mat';
[m n]=size(Ep);
[p q]=size(Sensor_Num_Count);
[w z]=size(Sensor_Num_Count_Err);
 for i = 1:n
   x_i(i) = Ep(i);
   y_i(i) =Err_Loc(i);%     每个节点会发n个数据包，收到n-1个数据包，Leader节点会收到n-1个数据包

 end
plot(x_i,y_i,'k-*') 
 
xlabel('Loc error ErrP/R')
ylabel('Average output error (Accuracy)')
figure (2)
for j = 1:q
   x_j(j) = Sensor_Num_Count(j);
   y_j(j)=DSL_CO(j);
 
end
plot(x_j,y_j,'k-.') 
 
% legend('DSL');
xlabel('The number of nodes')
ylabel('The number of transmission data ')

figure (3)
for k = 1:z
   x_k(k) = Sensor_Num_Count_Err(k);
   y_k(k) = Err_Num_Loc(k);
 
end
plot(x_k,y_k,'k-.') 
 
% legend('DSL');
xlabel('The number of nodes')
ylabel('TAverage output error normalized to R ')
