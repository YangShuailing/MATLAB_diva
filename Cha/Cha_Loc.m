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
for runs=1:Run_Times   
% ���������˷�λ��,Sensor_Loc��ʾ��˷����ʵλ��
Sensor_Loc_Real = [Room_Size(1,1)*abs(rand(Sensor_Num,1)) Room_Size(1,2)*abs(rand(Sensor_Num,1))];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ڵ�λ��
for i = 1 : Sensor_Num
    plot(Sensor_Loc_Real(i,1), Sensor_Loc_Real(i,2),'r.');
    hold on
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ����ڵ�λ����Sensor_Loc��ʾ������ʹ�õĽڵ�λ�ã�����ʵ�ڵ�λ��Sensor_Loc_Real��һ��
Sensor_Loc = Sensor_Loc_Real+(rand(size(Sensor_Loc_Real))-0.5)*2*Err_P;

%������ɴ���λλ��
Target_Loc = [Room_Size(1,1)*abs(rand()) Room_Size(1,2)*abs(rand())] ;


%  Sensor_Heared =ones((Grid_Size(1,1)+1)*(Grid_Size(1,2)+1),1);%ͶƱ

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  %������Դλ�ú�ͨ�Ű뾶
%     circle(Target_Loc(1,1),Target_Loc(1,2),Radius_Of_Acoustic)
%     plot(Target_Loc(1,1), Target_Loc(1,2),'ro','Markerfacecolor','r');
%     hold on

    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%ɸѡ���������������Ľڵ㣬��Sensor_Heared��¼����¼���ǽڵ���
    Sensor_Heared = [];
    for i=1:Sensor_Num
        dis = norm(Target_Loc-Sensor_Loc(i,:));
        if dis <= Radius_Of_Acoustic
            Sensor_Heared = [Sensor_Heared; i];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %           %���������������Ľڵ�
%             plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'r*-');
%             hold on;
%             text(Sensor_Loc(i,1),Sensor_Loc(i,2),num2str(i));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
flag=zeros((Grid_Size(1,1)+1)*(Grid_Size(1,2)+1),1);%���
Sensor_Heared_Num = size(Sensor_Heared,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %��ѡLeader
 %������Щ���������Ľڵ��ʱ������ٶ���Χ�������������Ľڵ��TOAΪ�����
%     TOA_Real = inf*ones(Sensor_Heared_Num,1);
    TOA = inf*ones(Sensor_Heared_Num,1);
    Leader = Sensor_Loc(Sensor_Heared(1,1),:);
    for i=1:Sensor_Heared_Num
        Dis = norm( Leader-Target_Loc); %����leader�ڵ㵽��Դ�ľ���
        TOA_Real = Dis./340; %�������������µ�TOA
        TOA = TOA_Real + (rand(size(TOA_Real))-0.5)*2*Err_M + (rand(size(TOA_Real))-0.5)*2 * Err_S;%����ʱ��ͬ�����Ͳ������
        Dis_i = norm(Sensor_Loc(Sensor_Heared(i,1),:)-Target_Loc); %�����i���ڵ㵽��Դ�ľ���
%       TOA_Real(Sensor_Heared(i,1),:) = Dis./340; %�������������µ�TOA
        TOA_Real_i = Dis_i./340; %�������������µ�TOA
        TOA_i = TOA_Real_i + (rand(size(TOA_Real_i))-0.5)*2*Err_M + (rand(size(TOA_Real_i))-0.5)*2 * Err_S;%����ʱ��ͬ�����Ͳ������
           
        if TOA_i <= TOA
                Leader = Sensor_Loc(Sensor_Heared(i,1),:);% Leader
            end
 
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             %����Leader�ڵ�
            plot(Leader(1,1), Leader(1,2),'ko-');
            hold on;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Voting Grid
tmp0 =0;
tmp1 =0; 
 
for i=1:Sensor_Heared_Num 
     for j=i+1:Sensor_Heared_Num 
           	%��Դ������Sensor֮�����Ĳ��ΪDeltaDis,����λ�����
            Dis_SpeakerToI=sqrt(((Target_Loc(1,1)-Sensor_Loc(Sensor_Heared(i),1)).^2)+((Target_Loc(1,2)-Sensor_Loc(Sensor_Heared(i),2)).^2));
            Dis_SpeakerToJ=sqrt(((Target_Loc(1,1)-Sensor_Loc(Sensor_Heared(j),1)).^2)+((Target_Loc(1,2)-Sensor_Loc(Sensor_Heared(j),2)).^2)); 
            % % %%%%%%%%%
            %%�ֻ�����λ��Microphone_Center_Location
            Microphone_Center_Location=(Sensor_Loc(Sensor_Heared(i),:)+Sensor_Loc(Sensor_Heared(j),:))/2;
            %����ʸ��Mic_vector
            Mic_vector=Sensor_Loc(Sensor_Heared(i),:)-Sensor_Loc(Sensor_Heared(j),:);

            %%%��֪����ʸ��Direct_vector=[a,b]������λ��(x0,y0)Microphone_Center_Location��
            %%%���㴹ֱƽ����a(x-x0)+b(y-y0)=0  
            a=Mic_vector(1:end,1);
            b=Mic_vector(1:end,2);
            x0=Microphone_Center_Location(1:end,1);
            y0=Microphone_Center_Location(1:end,2);
%            % ���д���
%             aa=-a./b; %%%% �д���б��
%             bb=(a.*Microphone_Center_Location(:,1)+b.*Microphone_Center_Location(:,2))./b;  %%%�ؾ�
%                     xx=0:100;
%                     yy=aa*xx+bb;
%                     plot(xx,yy,'color','blue','Linewidth',1);
%                     hold on;
% 
%                axis([0 10 0 10]);
            
%%%%%%%%%
            Grid_Point = []; %դ���
            DeltaDis=Dis_SpeakerToI-Dis_SpeakerToJ;
            count = 0;%��¼�ڼ���դ��
            for Voting_Grid_x =Leader(1,1)-Grid_Num/2*Point_Step:Point_Step:Leader(1,1)+Grid_Num/2*Point_Step
                for Voting_Grid_y=Leader(1,2)-Grid_Num/2*Point_Step:Point_Step:Leader(1,2)+Grid_Num/2*Point_Step
                    Grid_Point = [Grid_Point;Voting_Grid_x,Voting_Grid_y] ;         
                    count = count+1;
                    %����[Voting_Grid_x Voting_Grid_y]���ڵ�i,j����
                    Dis_TempToI=sqrt(((Voting_Grid_x -Sensor_Loc(Sensor_Heared(i),1)).^2)+((Voting_Grid_y -Sensor_Loc(Sensor_Heared(i),2)).^2));
                    Dis_TempToJ=sqrt(((Voting_Grid_x -Sensor_Loc(Sensor_Heared(j),1)).^2)+((Voting_Grid_y -Sensor_Loc(Sensor_Heared(j),2)).^2));
%                  %��������դ����λ�ú����������Ľڵ�λ��
%                  plot(Voting_Grid_x,Voting_Grid_y,'yo')  
%                  hold on;  
% %                  plot( Sensor_Loc(Sensor_Heared(i),1),  Sensor_Loc(Sensor_Heared(i),2),'k.-',Sensor_Loc(Sensor_Heared(j),1), Sensor_Loc(Sensor_Heared(j),2),'k.-');%���������������Ľڵ�
% %                  hold on;   
%                   	%�����ֵ
                   	DeltaDis_TempToSensor=Dis_TempToI-Dis_TempToJ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %դ��
                    plot(Voting_Grid_x,Voting_Grid_y,'b.');
                     hold on;
%                     %��ע
                        if DeltaDis_TempToSensor*DeltaDis>0 %[Voting_Grid_x Voting_Grid_y]��Target_Loc��i,j�д���ͬһ�� 
                             flag(count)=flag(count)+1;
                        end
                    end
            end
     end
   
end 
    %��ѡ����
    Result_Point = [];
    max_flag = max(flag);
    
    I=find(max_flag - flag < 1e-5 );
    [Nub_Max t]= size(I);% ����ĸ��� 
    ES_Loc =[0  0];
for i = 1 : size(I) 
    Result_Point =[Result_Point;Grid_Point(I(i),:) ];
   
end
 size(Result_Point)

   %%��λ���
    ES_Loc(1,1)=sum(Result_Point(:,1)) /Nub_Max;
    ES_Loc(1,2)=sum(Result_Point(:,2))/Nub_Max;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������λ���
plot(ES_Loc(1,1),ES_Loc(1,2),'k^');
hold on;
% disp(sprintf('��%d�ζ�λ����Դλ��Ϊ(%f,%f),Group�ﹲ��%d���ڵ�,Leader��������(%f,%f),ͶƱ����λ��(%f,%f)',runs,Target_Loc(1,1), Target_Loc(1,2),Sensor_Heared_Num,Leader(1,1),Leader(1,2),ES_Loc(1,1),ES_Loc(1,2))); 
 disp(sprintf('��%d�ζ�λ����Դλ��Ϊ(%f,%f),Group�ﹲ��%d���ڵ�,Leader��������(%f,%f)',runs,Target_Loc(1,1), Target_Loc(1,2),Sensor_Heared_Num,Leader(1,1),Leader(1,2)));
  D_Error = sqrt((ES_Loc(1,1)-Target_Loc(1,1)).^2+(ES_Loc(1,2)-Target_Loc(1,2)).^2);
 Err=[Err D_Error];
 
 
 
end    
save ES_Loc_Result.mat Err Sensor_Num ;
                            