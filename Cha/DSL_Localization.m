function [ output_args ] = DSL_Localization(Sensor_Num, Sensor_Loc,Target_Loc ,  TOA, Radius_Of_Acoustic,Room_Size)
%DSL_LOCALIZATION 此处显示有关此函数的摘要
%   此处显示详细说明

%筛选出可以听到声音的节点，用Sensor_Heared记录，记录的是节点标号
    Sensor_Heared = [];
    Communication_Count = ones(Sensor_Heared_Num,1);
    for i=1:Sensor_Num
        dis = norm(Target_Loc-Sensor_Loc(i,:));
        if dis <= Radius_Of_Acoustic
            Sensor_Heared = [Sensor_Heared; i];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %           %画出能听到声音的节点
%             plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'r*-');
%             hold on;
%             text(Sensor_Loc(i,1),Sensor_Loc(i,2),num2str(i));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
    

Sensor_Heared_Num = size(Sensor_Heared,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %竞选Leader,每个节点都会向其他节点问询
 %计算这些听到声音的节点的时间戳，假定外围不能听到声音的节点的TOA为无穷大
%     TOA_Real = inf*ones(Sensor_Heared_Num,1);
    TOA = inf*ones(Sensor_Heared_Num,1);
    Leader = Sensor_Loc(Sensor_Heared(1,1),:);
    Leader_Flag = ones(Sensor_Heared_Num,1);%统计被竞选成Leader的个数
    Dis = norm( Leader-Target_Loc); %计算leader节点到声源的距离
    TOA_Real = Dis./340; %计算无误差情况下的TOA
    TOA = TOA_Real + (rand(size(TOA_Real))-0.5)*2*Err_M + (rand(size(TOA_Real))-0.5)*2 * Err_S;%加上时间同步误差和测量误差
    for i=1:Sensor_Heared_Num
        for j = i :Sensor_Heared_Num
        Dis_Each = norm(Sensor_Loc(Sensor_Heared(j,1),:)-Target_Loc); %计算第j个节点到声源的距离
        TOA_Real__Each  = Dis_Each ./340; %计算无误差情况下的TOA
        TOA_Each  = TOA_Real_Each  + (rand(size(TOA_Real_Each ))-0.5)*2*Err_M + (rand(size(TOA_Real_Each ))-0.5)*2 * Err_S;%加上时间同步误差和测量误差 
       
        if TOA_Each  <= TOA
            Leader_Flag(i)=Leader_Flag(j)+1;
        else 
             Leader_Flag(i)=Leader_Flag(i)+1;
        end
      end
 
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %             %画出Leader节点
%             plot(Leader(1,1), Leader(1,2),'ko-');
%             hold on;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Voting Grid
tmp0 =0;
tmp1 =0; 
flag=zeros((Grid_Size(1,1)+1)*(Grid_Size(1,2)+1),1);%标记 
for i=1:Sensor_Heared_Num 
     for j=i+1:Sensor_Heared_Num 
           	%声源到两个Sensor之间距离的差记为DeltaDis,包含位置误差
            Dis_SpeakerToI=sqrt(((Target_Loc(1,1)-Sensor_Loc(Sensor_Heared(i),1)).^2)+((Target_Loc(1,2)-Sensor_Loc(Sensor_Heared(i),2)).^2));
            Dis_SpeakerToJ=sqrt(((Target_Loc(1,1)-Sensor_Loc(Sensor_Heared(j),1)).^2)+((Target_Loc(1,2)-Sensor_Loc(Sensor_Heared(j),2)).^2)); 
            % % %%%%%%%%%
            %%手机中心位置Microphone_Center_Location
            Microphone_Center_Location=(Sensor_Loc(Sensor_Heared(i),:)+Sensor_Loc(Sensor_Heared(j),:))/2;
            %方向矢量Mic_vector
            Mic_vector=Sensor_Loc(Sensor_Heared(i),:)-Sensor_Loc(Sensor_Heared(j),:);

            %%%已知方向矢量Direct_vector=[a,b]与中心位置(x0,y0)Microphone_Center_Location，
            %%%计算垂直平分线a(x-x0)+b(y-y0)=0  
            a=Mic_vector(1:end,1);
            b=Mic_vector(1:end,2);
            x0=Microphone_Center_Location(1:end,1);
            y0=Microphone_Center_Location(1:end,2);
%            % 画中垂线
%             aa=-a./b; %%%% 中垂线斜率
%             bb=(a.*Microphone_Center_Location(:,1)+b.*Microphone_Center_Location(:,2))./b;  %%%截距
%                     xx=0:100;
%                     yy=aa*xx+bb;
%                     plot(xx,yy,'color','blue','Linewidth',1);
%                     hold on;
% 
%                axis([0 10 0 10]);
            
%%%%%%%%%
            Grid_Point = []; %栅格点
            DeltaDis=Dis_SpeakerToI-Dis_SpeakerToJ;
            count = 0;%记录第几个栅格
            for Voting_Grid_x =Leader(1,1)-Grid_Num/2*Point_Step:Point_Step:Leader(1,1)+Grid_Num/2*Point_Step
                for Voting_Grid_y=Leader(1,2)-Grid_Num/2*Point_Step:Point_Step:Leader(1,2)+Grid_Num/2*Point_Step
                    Grid_Point = [Grid_Point;Voting_Grid_x,Voting_Grid_y] ;         
                    count = count+1;
                    %计算[Voting_Grid_x Voting_Grid_y]到节点i,j距离
                    Dis_TempToI=sqrt(((Voting_Grid_x -Sensor_Loc(Sensor_Heared(i),1)).^2)+((Voting_Grid_y -Sensor_Loc(Sensor_Heared(i),2)).^2));
                    Dis_TempToJ=sqrt(((Voting_Grid_x -Sensor_Loc(Sensor_Heared(j),1)).^2)+((Voting_Grid_y -Sensor_Loc(Sensor_Heared(j),2)).^2));
%                  %画出所有栅格点的位置和听到声音的节点位置
%                  plot(Voting_Grid_x,Voting_Grid_y,'yo')  
%                  hold on;  
% %                  plot( Sensor_Loc(Sensor_Heared(i),1),  Sensor_Loc(Sensor_Heared(i),2),'k.-',Sensor_Loc(Sensor_Heared(j),1), Sensor_Loc(Sensor_Heared(j),2),'k.-');%画出能听到声音的节点
% %                  hold on;   
%                   	%计算差值
                   	DeltaDis_TempToSensor=Dis_TempToI-Dis_TempToJ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %栅格
                    plot(Voting_Grid_x,Voting_Grid_y,'b.');
                     hold on;
%                     %标注
                        if DeltaDis_TempToSensor*DeltaDis>0 %[Voting_Grid_x Voting_Grid_y]与Target_Loc在i,j中垂线同一侧 
                             flag(count)=flag(count)+1;
                        end
                    end
            end
     end
   
end 
    %竞选处理
    Result_Point = [];
    max_flag = max(flag);
    
    I=find(max_flag - flag < 1e-5 );
    [Nub_Max t]= size(I);% 最大点的个数 
    ES_Loc =[0  0];
for i = 1 : size(I) 
    Result_Point =[Result_Point;Grid_Point(I(i),:) ];
   
end
 size(Result_Point)

   %%定位结果
    ES_Loc(1,1)=sum(Result_Point(:,1)) /Nub_Max;
    ES_Loc(1,2)=sum(Result_Point(:,2))/Nub_Max;

end

