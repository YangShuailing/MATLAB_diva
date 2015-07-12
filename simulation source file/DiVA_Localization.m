function [ Location, DiVA_Communication_Overhead ] = DiVA_Localization( Sensor_Num, Sensor_Loc, Sensor_Heared_Num, Sensor_Heared, TOA, Point_Step, LVN_CELL, LVN_P, Radius_Of_Acoustic,Room_Size, Target_Loc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   DiVA_Communication_Overhead = 0;
    Location = [];
    
    %对所有Sensor_Heared节点的TOA进行排序，按照从小到大的顺序依次启动定位过程
    temp_n = [1:Sensor_Num];
    temp = [temp_n' TOA];
    temp = sortrows(temp,2);
    Sensor_Heared = temp(1:Sensor_Heared_Num,1);
    
    HandledSet = zeros(Sensor_Num,1);%标记已经处理过定位过程的节点，值为1表示已经处理过
    Potential_Node = []; %用Potential_Node记录所有收敛处的节点编号
    
    %计算所有可能的起始点
    for i=1:Sensor_Heared_Num
        LEADER = Sensor_Heared(i); %Leader节点编号
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %disp(sprintf('从%d出发的问询',LEADER));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        LVN = LVN_CELL{LEADER}; %Leader的LVN节点编号
        
        if isempty(LVN) %如果是一个孤立节点
            Potential_Node=[Potential_Node LEADER];
        else
            %没有probe的LVN
            UnVisited_LVN = [1:size(LVN,2);LVN]'; 
            %已经probe的LVN
            Visited_LVN = []; 

            %随机选择起始PROBE
            PROBE_index = randi(size(LVN,2));
            PROBE = LVN(1,PROBE_index);

            %问询PROBE的TOA，然后在节点LEADER处进行比较
            while  ~isempty(UnVisited_LVN)
                DiVA_Communication_Overhead  = DiVA_Communication_Overhead +2; %通信负载
                if TOA(LEADER,1) > TOA(PROBE,1) %转移控制权
                    HandledSet(LEADER,1)=1;
                    if HandledSet(PROBE,1)==0 %模拟probe还没有处理过这次定位
                        %old_L=LEADER;%%%%%%%%%%%%%%画图使用
                        [LEADER PROBE UnVisited_LVN Visited_LVN PROBE_index] = DiVA_Update_LEADER_PROBE(LEADER, PROBE, Visited_LVN, LVN_CELL);
                        %arrow(Sensor_Loc(old_L,:),Sensor_Loc(LEADER,:),8,15,10);%%%%%%%%%%%%%%%
                    else %模拟probe已经处理过这次定位，则网络流量终止
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %disp(sprintf('终止于节点%d',PROBE));
                        %arrow(Sensor_Loc(LEADER,:),Sensor_Loc(PROBE,:),8,15,10);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        break;
                    end
                else %不转移控制权，重新找一个probe继续考察
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %arrow(Sensor_Loc(PROBE,:),Sensor_Loc(LEADER,:),8,15,10);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    a = find(UnVisited_LVN(:,1) == PROBE_index);
                    UnVisited_LVN(a,:) = [];
                    Visited_LVN = [Visited_LVN; PROBE_index PROBE];
                    [PROBE PROBE_index]=DiVA_Update_PROBE(PROBE, PROBE_index, Visited_LVN, UnVisited_LVN);
                end
                if PROBE == -1
                    Potential_Node=[Potential_Node LEADER];
                    HandledSet(LEADER,1)=1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             plot(Sensor_Loc(LEADER,1),Sensor_Loc(LEADER,2),'bo','Markerfacecolor','b');
%             hold on;
%             disp(sprintf('收敛于节点%d(%f,%f)\n',LEADER,Sensor_Loc(LEADER,1),Sensor_Loc(LEADER,2)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
            end
        end
    end

    Estimated_Location = [];
    MSE = [];
    TDOA_Result_Num=[];
    
    for i = 1: size(Potential_Node,2)
        Potential_Node_Pos = Sensor_Loc(Potential_Node(1,i),:);
        Potential_Node_TOA = TOA(Potential_Node(1,i),1);
        Loop_Around = LVN_P{Potential_Node(1,i)};
        LVN_Around_Num = LVN_CELL{Potential_Node(1,i)};
        LVN_Around_Pos = Sensor_Loc(LVN_Around_Num,:);
        LVN_Around_TOA = TOA(LVN_Around_Num,:);
        
        %首先计算target cell
        [Target_Cell_Point Point_In_Target_Cell_Num Target_Cell_Loop_Around] = DiVA_Calcul_Cell( Loop_Around, Potential_Node_Pos, Point_Step, Radius_Of_Acoustic, Room_Size);

        %计算final area
        Related_Node_Pos = [Potential_Node_Pos; LVN_Around_Pos];
        Related_Node_TOA = [Potential_Node_TOA; LVN_Around_TOA];
        Related_Node_Num = size(Related_Node_Pos,1);
        [Finally_Area_Point Point_In_Final_Area_Num] = DiVA_Calcul_Final_Area( Target_Cell_Point, Point_In_Target_Cell_Num, Related_Node_Pos, Related_Node_TOA);
            
        %使用Related_Node进行TDOA定位
        Related_Node_TDOA_estimated_Loc = [];
        for m = 1:Related_Node_Num-2
            for j = m+1:Related_Node_Num-1    
                for k = j+1:Related_Node_Num
                        Delta_t12 = Related_Node_TOA(j,1)-Related_Node_TOA(m,1);
                        Delta_t13 = Related_Node_TOA(k,1)-Related_Node_TOA(m,1);
                        estimated_Loc = TDOA_SolveEquations(Related_Node_Pos(m,:),Related_Node_Pos(j,:),Related_Node_Pos(k,:),Delta_t12,Delta_t13, Target_Loc);
                        Related_Node_TDOA_estimated_Loc = [Related_Node_TDOA_estimated_Loc; real(estimated_Loc)];
                end
            end
        end
        
        if isempty(Related_Node_TDOA_estimated_Loc) %邻居太少导致没有TDOA定位结果
            Estimated_Location = [Estimated_Location; mean(Finally_Area_Point(:,1)) mean(Finally_Area_Point(:,2))];
            MSE = [MSE; inf];
            TDOA_Result_Num=[TDOA_Result_Num; 0];
        else
            temp_MSE = inf;
            temp_loc =[];
            
            %%%%%%%%%%%%%%%%%去噪
%             M_result = mean(Related_Node_TDOA_estimated_Loc);
%             A=[];
%             for kk=1:size(Related_Node_TDOA_estimated_Loc,1)
%                 A=[A norm(Related_Node_TDOA_estimated_Loc(kk,:)-M_result)];
%             end
%             [B,idx,outliers] = deleteoutliers(A, 1);
%             Related_Node_TDOA_estimated_Loc(idx,:)=[];
            %%%%%%%%%%%%%%%%%
            for k=1:size(Finally_Area_Point,1)
                total=0;
                for tt=1:size(Related_Node_TDOA_estimated_Loc,1)
                    a= norm(Related_Node_TDOA_estimated_Loc(tt,:)-Finally_Area_Point(k,:));
                    total = total + a*a;
                end
                if total./size(Related_Node_TDOA_estimated_Loc,1) < temp_MSE
                    temp_MSE = total./size(Related_Node_TDOA_estimated_Loc,1);
                    temp_loc = Finally_Area_Point(k,:);
                end
            end
            Estimated_Location = [Estimated_Location; temp_loc];
            MSE = [MSE; temp_MSE];
            TDOA_Result_Num=[TDOA_Result_Num; size(Related_Node_TDOA_estimated_Loc,1)];
            
%             %画出TDOA定位结果
%             for m=1:size(Related_Node_TDOA_estimated_Loc,1)
%                 plot(Related_Node_TDOA_estimated_Loc(m,1),Related_Node_TDOA_estimated_Loc(m,2),'y.');
%                 hold on;
%             end
        end
    end

    %在多个结果中选择最合适的那一个
    temp_MSE=[];
    temp_Estimated_Location = [];
    more_than_one_TDOA_result = find(TDOA_Result_Num>1);
    if ~isempty(more_than_one_TDOA_result)
        temp_MSE = MSE(more_than_one_TDOA_result,1);
        temp_Estimated_Location = Estimated_Location(more_than_one_TDOA_result,:);%%%%%%%%%%%%
    else
        temp_MSE = MSE;
        temp_Estimated_Location = Estimated_Location;
    end
    min_MSE = min(temp_MSE);
    index = find(temp_MSE==min_MSE);
    if size(index,1)>1
        Estimated_Location = [mean(temp_Estimated_Location(index(:,1),1)) mean(temp_Estimated_Location(index(:,1),2))];
    else
        Estimated_Location = temp_Estimated_Location(index,:);
    end
    
    Location = Estimated_Location;
end
    

