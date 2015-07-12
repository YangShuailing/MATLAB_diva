clc;
clear all;
Sensor_Num = 1000;%传感器个数
Room_Size = [100 100];%空间大小，单位（米）
Radius_Of_Acoustic = 20;%节点通信距离
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_S = 0; %测量误差(s)
Err_M= 0; %时间同步误差（s）
Run_Times=5;%仿真定位次数
Grid_Num =8;%栅格的个数
Err=[];%定位误差
Ep = [];
Err_Loc =[];
Sensor_Num_Count = [];
Err_DSL_CELL = cell(Run_Times,1);
for E = 0:0.05:0.75
    Err_P = R * E; %节点位置误差（R）
    Ep = [Ep Err_P];
for runs=1:Run_Times   
% 随机生成麦克风位置,Sensor_Loc表示麦克风的真实位置
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 画出节点位置
% for i = 1 : Sensor_Num
%     plot(Sensor_Loc_Real(i,1), Sensor_Loc_Real(i,2),'r.');
%     hold on
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 加入节点位置误差，Sensor_Loc表示计算中使用的节点位置，与真实节点位置Sensor_Loc_Real不一样
Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%随机生成待定位位置
Target_Loc = [Room_Size(1,1)*abs(rand()) Room_Size(1,2)*abs(rand())] ;


%  Sensor_Heared =ones((Grid_Size(1,1)+1)*(Grid_Size(1,2)+1),1);%投票

% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  %画出声源位置和通信半径
%     circle(Target_Loc(1,1),Target_Loc(1,2),Radius_Of_Acoustic)
%     plot(Target_Loc(1,1), Target_Loc(1,2),'ro','Markerfacecolor','r');
%     hold on
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [DSL_Communication_Overhead,  DSL_Estimated_Location,Sensor_Heared_Num]= DSL_Localization(Sensor_Num, Sensor_Loc_Real,Sensor_Loc,Target_Loc , Radius_Of_Acoustic,Err_S ,Err_M,Grid_Num-1 );

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % %  画出定位结果
% plot(DSL_Estimated_Location(1,1),DSL_Estimated_Location(1,2),'k^');
% hold on;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
D_Error = norm(DSL_Estimated_Location - Target_Loc);
 
Err=[Err D_Error];

end    
Err_Loc = [Err_Loc mean(Err)];


end

DSL_Loc_Data_File = strcat('DSL_Loc_Data_Ep','.mat');
save(DSL_Loc_Data_File ,'Err_Loc','Ep');
disp( sprintf( DSL_Loc_Data_File,'Data saved!\n'));                            