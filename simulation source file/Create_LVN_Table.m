function [ LVN_CELL, LVN_P ] = Create_LVN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range)

%找到所有节点的CN，其中CN_CELL{i}表示节点i的所有CN的节点编号
CN_CELL=cell(Sensor_Num,1);
for i=1:Sensor_Num
    CNi = [];
    for j=1:Sensor_Num
        dis = norm(Sensor_Loc_Real(i,:)-Sensor_Loc_Real(j,:)); %计算CN使用的是真实节点位置
            if dis <= Communication_Range && i ~= j
                CNi = [CNi j];
            end
    end
    CN_CELL{i} = CNi;
end

%对于每一个节点，使用其CN构造局部Voronio图，确定其LVN，并用LVN_CELL记录
pbound=Polyhedron([0 0;Room_Size(1,1) 0;Room_Size(1,1) Room_Size(1,2);0 Room_Size(1,2)]);

LVN_CELL=cell(Sensor_Num,1);
LVN_P=cell(Sensor_Num,1);
for i=1:Sensor_Num
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(sprintf('正在计算节点%d的LVN\n',i));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CN = CN_CELL{i};
	CN_Pos = Sensor_Loc(CN,:);
	Cent_Pos = Sensor_Loc(i,:);
	%节点i加上其所有的CN构造局部V图
	[V P] = mpt_voronoi([Cent_Pos; CN_Pos]','bound',pbound);
    %用LVN_P记录每个节点所在的cell的顶点坐标
    LVN_P{i} = P(1).V;
    LVN = [];
    for j=2:size(P,2)
        for k=1:size(P(j).V,1)
            for n=1:size(P(1).V,1)
                if norm(P(j).V(k,:)-P(1).V(n,:)) < 1e-6
                    LVN = [LVN CN(1,j-1)];
                end
            end
        end
    end
    LVN = LVN';
    LVN = unique(LVN,'rows');
    LVN = LVN';
    
    %对LVN排序
    LVN_Loc = Sensor_Loc(LVN,:);
    Cen_Loc = Sensor_Loc(i,:);
    temp_LVN_order1=[];
    temp_LVN_order2=[];
    for t=1:size(LVN,2)
        if (LVN_Loc(t,1)-Cen_Loc(1,1))>=0
            temp_LVN_order1 = [temp_LVN_order1; LVN(1,t) (LVN_Loc(t,2)-Cen_Loc(1,2))/(LVN_Loc(t,1)-Cen_Loc(1,1))];
        else
            temp_LVN_order2 = [temp_LVN_order2; LVN(1,t) (LVN_Loc(t,2)-Cen_Loc(1,2))/(LVN_Loc(t,1)-Cen_Loc(1,1))];
        end
    end
    if ~isempty(temp_LVN_order1)
        temp_LVN_order1 = sortrows(temp_LVN_order1,2);
    end
    if ~isempty(temp_LVN_order2)
        temp_LVN_order2 = sortrows(temp_LVN_order2,2);
    end;

    LVN = [];
    if ~isempty(temp_LVN_order1)
        LVN = temp_LVN_order1(:,1);
    end;
    if ~isempty(temp_LVN_order2)
        LVN=[LVN; temp_LVN_order2(:,1)];
    end;
    LVN = LVN';
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     disp(sprintf('节点%d(%f,%f)的LVN排序后如下：\n',i,Sensor_Loc(i,1),Sensor_Loc(i,2)));
%     plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'b.-');
%     hold on;
%     for m=i:size(LVN,2)
%         disp(sprintf('节点ID:%d,坐标(%f,%f)\n',LVN(1,m),Sensor_Loc(LVN(1,m),1),Sensor_Loc(LVN(1,m),2)));
%         plot(Sensor_Loc(LVN(1,m),1), Sensor_Loc(LVN(1,m),2),'ro-');
%         hold on;
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LVN_CELL{i} = LVN;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算每个节点的平均LVN个数，从而判断Communication_Range给的是否合适
num=0;
for i=1:Sensor_Num
    num = num + size(LVN_CELL{i},2);
end;
avg_LVN_num = num / Sensor_Num;
disp(sprintf('每个节点平均有%f个LVN\n',avg_LVN_num));