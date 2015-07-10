clc;
clear all  %清除 
close all; %关闭之前数据
Microphone_Distance=0.14;
k = 1;%参数
AB=Microphone_Distance;%%一个phone上两个microphone距离
Node_number =10;
Size_Grid =2;
%%%%%%%%%%%%%%%%%%初始化
Speaker_to_speaker = zeros;
rmse_CMDS =zeros(Node_number,1);
Microphone_1_Location=zeros(Node_number,2);
Microphone_2_Location=zeros(Node_number,2);
Microphone_11_Location=zeros(Node_number,2);
Microphone_22_Location=zeros(Node_number,2);
Estimate_TDOA_Location=zeros ;
Estimate_P2P_Location=zeros ;
Rmse_TDOA=zeros(Node_number,1);
Rmse_P2P=zeros(Node_number,1);
Microphone_Center_Location=Size_Grid*abs((rand(Node_number,2))); %中心位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%生成麦克风位置朝向信息

Anchor_number =3;    %%参考（信标）节点个数
refnodecoor=[0 0;0 10 ;10 0];  %%参考（信标）节点分布在三个边角
refangle=[0;90;180];    %%参考（信标）节点朝向 以x轴正方向为参考
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 随机生成麦克风位置朝向信息


%         Microphone_Cita=fix(-90+180*(rand(Anchor_number,1))); %%朝向 [-90  90]    
%         Microphone_Center_Location=fix(Size_Grid*abs((rand(Anchor_number,2)))); % 中心 位置
%        
%         Microphone_1_Location=zeros(Anchor_number,2);
% 		Microphone_2_Location=zeros(Anchor_number,2);
% 		
%         for  i=1:Anchor_number
%         %%(L/2,0)
% 	    Anchor_Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
%       Anchor_Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
% 		 %%(-L/2,0)
%        Anchor_Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
%        Anchor_Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
%         end

for  i=1:Node_number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% node 的speaker坐标
% 
        speaker_x=Microphone_Center_Location(i,1);
        speaker_y=Microphone_Center_Location(i,2);
         
    Estimate_TDOA_Location =[];  %估计的位置坐标
    Estimate_P2P_Location = [];  %估计的位置坐标
  for j =1 :Anchor_number

         AC= (sqrt((speaker_x-(refnodecoor(j,1)-0.07*cos(refangle(j))))^2+(speaker_y-(refnodecoor(j,2)-0.07*sin(refangle(j))))^2));
         BC= (sqrt((speaker_x-(refnodecoor(j,1)+0.07*cos(refangle(j))))^2+(speaker_y-(refnodecoor(j,2)+0.07*sin(refangle(j))))^2));
         OC=sqrt((speaker_x-refnodecoor(j,1))^2+(speaker_y-refnodecoor(j,2))^2);   

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sab1代表node为声源到anchor的麦克风的距离
%          AC=sqrt((speaker_x-Microphone3_1)^2+(speaker_y-Microphone3_2)^2);
%          BC=sqrt((speaker_x-Microphone4_1)^2+(speaker_y-Microphone4_2)^2);
%          OC=sqrt((speaker_x-refnodecoor(2,1))^2+(speaker_y-refnodecoor(2,2))^2);            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%两个声源A-B真实距离      
speaker_to_speaker = sqrt((speaker_x-refnodecoor(j,1))^2+(speaker_y-refnodecoor(j,2))^2);     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算  
    Theta_Tdoa = acos(abs(AC-BC) /Microphone_Distance);  %Phone to Phone 计算角度
    Theta_P2P = acos((abs(AC-BC)*(BC+AC))/(AB*(2*OC)));  %直接用TDOA计算角度

    Estimate_TDOA_Location = [Estimate_TDOA_Location;estimate( speaker_to_speaker, Theta_Tdoa,refangle(j))];
    Estimate_P2P_Location  = [Estimate_P2P_Location;estimate( speaker_to_speaker, Theta_P2P,refangle(j))];  
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画出定位结果
plot(speaker_x,speaker_y,'r*')
hold on
    if j==1

plot(Estimate_TDOA_Location(j,1),Estimate_TDOA_Location(j,2),'rv');
hold on ;
plot(Estimate_P2P_Location(j,1),Estimate_P2P_Location(j,2),'ro');
hold on ;
%     elseif j==2
% plot(Estimate_TDOA_Location(j,1),Estimate_TDOA_Location(j,2),'kv');
% hold on ;
% plot(Estimate_P2P_Location(j,1),Estimate_P2P_Location(j,2),'ko');
% hold on ; 
%     elseif j==3
% plot(Estimate_TDOA_Location(j,1),Estimate_TDOA_Location(j,2),'bv');
% hold on ;
% plot(Estimate_P2P_Location(j,1),Estimate_P2P_Location(j,2),'bo');
% hold on ; 
    end
%  arrow([x2 y2],[speaker_x speaker_y]);
%  arrow([x1 y1],[speaker_x speaker_y]);
%  hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sab1代表node为声源到anchor的麦克风的距离
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Microphone坐标
%          Microphone1_1=refnodecoor(1,1)-0.07;
%          Microphone1_2=refnodecoor(1,2)  ;
%          Microphone2_1=refnodecoor(1,1)+0.07;
%          Microphone2_2=refnodecoor(1,2) ;%%%A1;       
%          Microphone3_1=refnodecoor(2,1)-0.07 ;
%          Microphone3_2=refnodecoor(2,2);
%          Microphone4_1=refnodecoor(2,1)+0.07;
%          Microphone4_2=refnodecoor(2,2) ;%%%B1;    
%          Microphone5_1=refnodecoor(3,1);
%          Microphone5_2=refnodecoor(3,2)-0.07  ;
%          Microphone6_1=refnodecoor(3,1);
%          Microphone6_2=refnodecoor(3,2)+0.07 ;%%%C1;    
         
%          AC=sqrt((speaker_x-Microphone5_1)^2+(speaker_y-Microphone5_2)^2);
%          BC=sqrt((speaker_x-Microphone6_1)^2+(speaker_y-Microphone6_2)^2);
%          OC=sqrt((speaker_x-refnodecoor(3,1))^2+(speaker_y-refnodecoor(3,2))^2);            
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%两个声源A-B真实距离      
% speaker_to_speaker = sqrt((speaker_x-refnodecoor(3,1))^2+(speaker_y-refnodecoor(3,2))^2);     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算  
%     Theta_Tdoa = acos((AC-BC) /Microphone_Distance);  %Phone to Phone 计算角度
% 
%     Theta_P2P = acos(((AC-BC)*(BC+AC))/(AB*(2*OC)));  %直接用TDOA计算角度
%     Estimate_TDOA_Location =[];  %估计的位置坐标
%     Estimate_P2P_Location = [];  %估计的位置坐标
%     Estimate_TDOA_Location = [Estimate_TDOA_Location;estimate( speaker_to_speaker, Theta_Tdoa,180)];
%     Estimate_P2P_Location  = [Estimate_P2P_Location;estimate( speaker_to_speaker, Theta_P2P,180 )];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画出定位结果
% plot(speaker_x,speaker_y,'r*')
% hold on
% plot(Estimate_TDOA_Location(1,1),Estimate_TDOA_Location(1,2),'kv');
% hold on ;
% plot(Estimate_P2P_Location(1,1),Estimate_P2P_Location(1,2),'bo');
% hold on ;
% %  arrow([x2 y2],[speaker_x speaker_y]);
% %  arrow([x1 y1],[speaker_x speaker_y]);
% %  hold on;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 求误差
rmse_TDOA = norm(sqrt((speaker_x-Estimate_TDOA_Location(1,1))^2+(speaker_y-Estimate_TDOA_Location(1,1))^2));
rmse_P2P = norm(sqrt((speaker_x-Estimate_P2P_Location(1,1))^2+(speaker_y-Estimate_P2P_Location(1,2))^2));
Rmse_TDOA (k) = rmse_TDOA ;
Rmse_P2P (k)= rmse_P2P  ;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k=k+1;
end


% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 误差的CDF图像
% Rmse_TDOA =  mean (Rmse_TDOA )
% Rmse_P2P = mean (Rmse_P2P )
% figure(2)
% totalNum=size(Rmse_TDOA,1);
% yymin=min(Rmse_TDOA); 
% yymax=max(Rmse_TDOA);
% xx=linspace(yymin,yymax,30);
% yy=hist(Rmse_TDOA,xx); %计算各个区间的个数 
% yy=yy/totalNum;%计算各个区间的概率
% for i=2:size(xx,2)
%     yy(1,i)=yy(1,i-1)+yy(1,i);
% end
% plot(xx, yy, 'k*-', 'LineWidth', 1, 'MarkerFaceColor', 'b');
%  axis([0 yymax 0 1]); 
%   xlabel('Positioning error(m)');
% ylabel('CDF');
% legend( 'Rmse-TDOA' );
figure(3)
totalNum=size(Rmse_P2P,1);
ymin=min(Rmse_P2P); 
ymax=max(Rmse_P2P);
x11=linspace(ymin,ymax,20); 
y11=hist(Rmse_P2P,x11); %计算各个区间的个数 
y11=y11/totalNum;%计算各个区间的概率
for i=2:size(x11,2)
    y11(1,i)=y11(1,i-1)+y11(1,i);
end
plot(x11, y11, 'bo-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
  axis([0 ymax 0 1]); 
 xlabel('Positioning error(m)');
ylabel('CDF');
legend(  'Rmse-P2P');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%