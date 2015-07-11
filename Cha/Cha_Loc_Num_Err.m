clc;
clear all;
% Sensor_Num = 1000;%����������
Room_Size = [100 100];%�ռ��С����λ���ף�
Radius_Of_Acoustic = 20;%�ڵ�ͨ�ž���
% R = 1/(2*sqrt(Sensor_Num/(Room_Size(1,1)*Room_Size(1,2))));
Err_P = 0; %�ڵ�λ����R��
Err_S = 0; %�������(s)
Err_M= 0; %ʱ��ͬ����s��
Run_Times=10;%���涨λ����
Grid_Num =8;%դ��ĸ���
Err=[];%��λ���
Ep = [];
Err_Num_Loc =[];
Sensor_Num_Count_Err = [];

for Sensor_Num = 200:200:1200
    Sensor_Num_Count_Err = [Sensor_Num_Count_Err Sensor_Num];
for runs=1:Run_Times   
% ���������˷�λ��,Sensor_Loc��ʾ��˷����ʵλ��
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % �����ڵ�λ��
% for i = 1 : Sensor_Num
%     plot(Sensor_Loc_Real(i,1), Sensor_Loc_Real(i,2),'r.');
%     hold on
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ����ڵ�λ����Sensor_Loc��ʾ������ʹ�õĽڵ�λ�ã�����ʵ�ڵ�λ��Sensor_Loc_Real��һ��
Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%������ɴ���λλ��
Target_Loc = [Room_Size(1,1)*abs(rand()) Room_Size(1,2)*abs(rand())] ;


%  Sensor_Heared =ones((Grid_Size(1,1)+1)*(Grid_Size(1,2)+1),1);%ͶƱ

% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  %������Դλ�ú�ͨ�Ű뾶
%     circle(Target_Loc(1,1),Target_Loc(1,2),Radius_Of_Acoustic)
%     plot(Target_Loc(1,1), Target_Loc(1,2),'ro','Markerfacecolor','r');
%     hold on
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [DSL_Communication_Overhead,  DSL_Estimated_Location,Sensor_Heared_Num]= DSL_Localization(Sensor_Num, Sensor_Loc_Real,Sensor_Loc,Target_Loc , Radius_Of_Acoustic,Err_S ,Err_M,Grid_Num-1 );

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % %  ������λ���
% plot(DSL_Estimated_Location(1,1),DSL_Estimated_Location(1,2),'k^');
% hold on;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

D_Error = sqrt((DSL_Estimated_Location(1,1)-Target_Loc(1,1)).^2+(DSL_Estimated_Location(1,2)-Target_Loc(1,2)).^2);
Err=[Err D_Error];

end    
Err_Num_Loc= [Err_Num_Loc mean(Err)];

end

DSL_Loc_Data_File = strcat('DSL_Loc_Data_Num_Err','.mat');
save(DSL_Loc_Data_File ,'Sensor_Num_Count_Err','Err_Num_Loc' );
disp( sprintf( DSL_Loc_Data_File,'Data saved!\n'));                            