function [ lerder ] = Elect_Leader( Sensor_Loc,Target_Loc)
%ELECT_LEADER 此处显示有关此函数的摘要
%   此处显示详细说明
% 创建 Group_Table
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
      %选Leader
            if dis < dis_1;
            leader = Sensor_Loc(i,:);
            end
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             circle(Target_Loc(1,1),Target_Loc(1,2),Radius_Of_Acoustic);%画出声源及听到声音的节点的位置
%             hold on;
%             plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'r^-');%画出能听到声音的节点
%             hold on;
% %        text(Sensor_Loc(i,1),Sensor_Loc(i,2),num2str(i));
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        
  end 

end

