clc;
load 'Ini_Data_Ep_0.1.mat';

Err_S = 44e-6; %测量误差(s)
Err_M= 0; %时间同步误差（s）
Radius_Of_Acoustic = 20;%可以听到声音的圆形范围半径
Point_Step=0.05; %空间划分粒度
Run_Times=10;%仿真定位次数

Err_TOA_CELL = cell(Run_Times,1);
Err_TDOA_CELL = cell(Run_Times,1);
Err_DiVA_CELL = cell(Run_Times,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %画节点的真实位置
% plot(Sensor_Loc_Real(:,1), Sensor_Loc_Real(:,2),'r.');
% hold on;
% %画节点的计算位置
% plot(Sensor_Loc(:,1), Sensor_Loc(:,2),'b.');
% hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for runs=1:Run_Times   
    %随机生成待定位位置
    Target_Loc = [Room_Size(1,1)*abs(rand()) Room_Size(1,2)*abs(rand())];

    %画出声源位置
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     plot(Target_Loc(1,1), Target_Loc(1,2),'ro','Markerfacecolor','r');
%     hold on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
    %筛选出可以听到声音的节点，用Sensor_Heared记录，记录的是节点标号
    Sensor_Heared = [];
    for i=1:Sensor_Num
        dis = norm(Target_Loc-Sensor_Loc_Real(i,:));
        if dis <= Radius_Of_Acoustic
            Sensor_Heared = [Sensor_Heared; i];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'r*-');%画出能听到声音的节点
%             hold on;
%             text(Sensor_Loc(i,1),Sensor_Loc(i,2),num2str(i));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
    Sensor_Heared_Num = size(Sensor_Heared,1);
    
    disp(sprintf('第%d次定位，声源位置为(%f,%f),共有%d个节点听到本次发声，这些节点将参与定位',runs,Target_Loc(1,1), Target_Loc(1,2),Sensor_Heared_Num));
    
    %计算这些听到声音的节点的时间戳，假定外围不能听到声音的节点的TOA为无穷大
    TOA_Real = inf*ones(Sensor_Num,1);
    TOA = inf*ones(Sensor_Num,1);
    for i=1:Sensor_Heared_Num
        Dis = norm(Sensor_Loc_Real(Sensor_Heared(i,1),:)-Target_Loc); %计算每个节点到声源的距离
        TOA_Real(Sensor_Heared(i,1),:) = Dis./340; %计算无误差情况下的TOA
        TOA = TOA_Real + (rand(size(TOA_Real))-0.5)*2*Err_M + (rand(size(TOA_Real))-0.5)*2 * Err_S;%加上时间同步误差和测量误差
    end
    
%     %使用TOA定位，记录定位误差情况
%     TOA_estimated_loc = TOA_Localization( Sensor_Heared_Num, Sensor_Loc(Sensor_Heared,:), TOA(Sensor_Heared,:));
%     D_Err_TOA = [];
% 	for i=1:size(TOA_estimated_loc,1)
%         D_Err_TOA = [D_Err_TOA norm(TOA_estimated_loc(i,:) - Target_Loc)];
%     end
%     Err_TOA_CELL{runs} = D_Err_TOA;
%     disp(sprintf('第%d次定位,TOA定位平均误差为%f',runs,mean(D_Err_TOA(find(~isnan(D_Err_TOA))))));
% 
%     
%     %使用TDOA定位，记录定位误差情况
%     TDOA_estimated_loc = TDOA_Localization(Sensor_Heared_Num, Sensor_Loc(Sensor_Heared,:), TOA(Sensor_Heared,:), Target_Loc);
%     D_Err_TDOA = [];
% 	for i=1:size(TDOA_estimated_loc,1)
%         D_Err_TDOA = [D_Err_TDOA norm(TDOA_estimated_loc(i,:) - Target_Loc)];
%     end
%     Err_TDOA_CELL{runs} = D_Err_TDOA;
%     disp(sprintf('第%d次定位,TDOA定位平均误差为%f',runs,mean(D_Err_TDOA)));

%使用DiVA定位，记录定位误差情况
    [Estimated_Location]= DiVA_Localization( Sensor_Num, Sensor_Loc, Sensor_Heared_Num, Sensor_Heared, TOA, Point_Step, LVN_CELL, LVN_P, Radius_Of_Acoustic, Room_Size, Target_Loc);
  	Err_DiVA_CELL{runs} = norm(Estimated_Location - Target_Loc);
%     
    
%     Estimated_Location = DiVA_Localization_no_phaseIV( Sensor_Num, Sensor_Loc, Sensor_Heared_Num, Sensor_Heared, TOA, Point_Step, LVN_CELL, LVN_P, Radius_Of_Acoustic, Room_Size, Target_Loc);
%     Estimated_Location = [mean(Estimated_Location(:,1)) mean(Estimated_Location(:,2))];
%     Err_DiVA_CELL{runs} = norm(Estimated_Location - Target_Loc);

 	%disp(sprintf('第%d次定位，DiVA定位误差为%f\n',runs, norm(Estimated_Location - Target_Loc)));
end

% 
% Err_TOA_File = strcat('Loc_Error_TOA_Ep_',num2str(Err_P/R),'_Es_',num2str(Err_S),'_Em_',num2str(Err_M),'.mat');
% save(Err_TOA_File,'Err_TOA_CELL');
% 
% Err_TDOA_File = strcat('Loc_Error_TDOA_Ep_',num2str(Err_P/R),'_Es_',num2str(Err_S),'_Em_',num2str(Err_M),'.mat');
% save(Err_TDOA_File,'Err_TDOA_CELL');

Err_DiVA_File = strcat('Loc_Error_DiVA_Ep_',num2str(Err_P/R),'_Es_',num2str(Err_S),'_Em_',num2str(Err_M),'.mat');
save(Err_DiVA_File,'Err_DiVA_CELL');

% Err_DiVA_File = strcat('Loc_Error_DiVA_no_phase_IV_Ep_',num2str(Err_P/R),'_Es_',num2str(Err_S),'_Em_',num2str(Err_M),'.mat');
% save(Err_DiVA_File,'Err_DiVA_CELL');

disp(sprintf('Loc_Result saved!\n'));