Sensor_Num = 1000;%����������
Room_Size = [100 100];%�ռ��С����λ���ף�
Communication_Range = 8;%�ڵ�ͨ�ž���
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
                            