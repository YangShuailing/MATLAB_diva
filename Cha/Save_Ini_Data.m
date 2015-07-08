clc;
clear all;
Sensor_Num = 100;%传感器个数
Room_Size = [10 10];%空间大小，单位（米）
Radius_Of_Acoustic = 2;%节点通信距离
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = 0; %节点位置误差（R）
Err_S = 0; %测量误差(s)
Err_M= 0; %时间同步误差（s）
Run_Times=1;%仿真定位次数
Grid_Size = [8 8];%栅格的大小
Grid_Num = Grid_Size(1,1);%栅格的个数
Sensor_Heared = [];%侦听到声音的节点
Group_Table = [];% group表
Point_Step=0.1;%可变参数，单位栅格大小
TOA_Real = inf*ones(Sensor_Num,1);%真实TOA的值
TOA = inf*ones(Sensor_Num,1);%加误差的TOA
Err=[];%定位误差
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = R * 0.8; %节点位置误差（R）


%随机生成麦克风位置,Sensor_Loc_Real表示麦克风的真实位置
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];

%加入节点位置误差，Sensor_Loc表示计算中使用的节点位置，与真实节点位置Sensor_Loc_Real不一样
Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%对每个节点，求LVN table
[ LVN_CELL, LVN_P ] = Create_LVN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range);

Ini_Data_File = strcat('Ini_Data_Ep_',num2str(Err_P/R),'.mat');
save(Ini_Data_File,'Sensor_Num','Sensor_Loc','Sensor_Loc_Real','Room_Size','R','Err_P','LVN_CELL','LVN_P');

disp(sprintf('Data saved!\n'));