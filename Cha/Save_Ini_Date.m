Sensor_Num = 100;%传感器个数
Room_Size = [10 10];%空间大小，单位（米）
Communication_Range = 6;%节点通信距离
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = R * 0.8; %节点位置误差（R）


%随机生成麦克风位置,Sensor_Loc_Real表示麦克风的真实位置
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];

%加入节点位置误差，Sensor_Loc表示计算中使用的节点位置，与真实节点位置Sensor_Loc_Real不一样
% Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%对每个节点，根据传播范围，建立一个Group,建立LN table,
[ LN_CELL, LN_P ] = Create_LN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range);

Ini_Data_File = strcat('Ini_Data_Ep_',num2str(Err_P/R),'.mat');
save(Ini_Data_File,'Sensor_Num','Sensor_Loc','Sensor_Loc_Real','Room_Size','R','Err_P','LN_CELL','LN_P');

disp(sprintf('Data saved!\n'));
                            