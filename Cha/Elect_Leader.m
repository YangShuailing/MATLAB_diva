function [ lerder ] = Elect_Leader( Sensor_Loc,Target_Loc)
%ELECT_LEADER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ���� Group_Table
Sensor_Heared = [];
Group_Table = [];
leader=Sensor_Loc(1,:);

dis_ref =  norm(Target_Loc-Sensor_Loc(1,:));
  for i=1:Sensor_Num
        dis = norm(Target_Loc-Sensor_Loc(i,:));
        dis_1 =  norm(Target_Loc-leader);
        if dis <= Radius_Of_Acoustic
            Sensor_Heared = [Sensor_Heared; i] ;
            Group_Table = [Group_Table Sensor_Loc(i,:)];
      %ѡLeader
            if dis < dis_1;
            leader = Sensor_Loc(i,:);
            end
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             circle(Target_Loc(1,1),Target_Loc(1,2),Radius_Of_Acoustic);%������Դ�����������Ľڵ��λ��
%             hold on;
%             plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'r^-');%���������������Ľڵ�
%             hold on;
% %        text(Sensor_Loc(i,1),Sensor_Loc(i,2),num2str(i));
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
  end 

end

