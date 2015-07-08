clc;
clear all;
Sensor_Num = 100;%����������
Room_Size = [10 10];%�ռ��С����λ���ף�
Radius_Of_Acoustic = 2;%�ڵ�ͨ�ž���
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = 0; %�ڵ�λ����R��
Err_S = 0; %�������(s)
Err_M= 0; %ʱ��ͬ����s��
Run_Times=1;%���涨λ����
Grid_Size = [8 8];%դ��Ĵ�С
Grid_Num = Grid_Size(1,1);%դ��ĸ���
Sensor_Heared = [];%�����������Ľڵ�
Group_Table = [];% group��
Point_Step=0.1;%�ɱ��������λդ���С
TOA_Real = inf*ones(Sensor_Num,1);%��ʵTOA��ֵ
TOA = inf*ones(Sensor_Num,1);%������TOA
Err=[];%��λ���
R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = R * 0.8; %�ڵ�λ����R��


%���������˷�λ��,Sensor_Loc_Real��ʾ��˷����ʵλ��
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];

%����ڵ�λ����Sensor_Loc��ʾ������ʹ�õĽڵ�λ�ã�����ʵ�ڵ�λ��Sensor_Loc_Real��һ��
Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%��ÿ���ڵ㣬��LVN table
[ LVN_CELL, LVN_P ] = Create_LVN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range);

Ini_Data_File = strcat('Ini_Data_Ep_',num2str(Err_P/R),'.mat');
save(Ini_Data_File,'Sensor_Num','Sensor_Loc','Sensor_Loc_Real','Room_Size','R','Err_P','LVN_CELL','LVN_P');

disp(sprintf('Data saved!\n'));