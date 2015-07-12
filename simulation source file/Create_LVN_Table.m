function [ LVN_CELL, LVN_P ] = Create_LVN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range)

%�ҵ����нڵ��CN������CN_CELL{i}��ʾ�ڵ�i������CN�Ľڵ���
CN_CELL=cell(Sensor_Num,1);
for i=1:Sensor_Num
    CNi = [];
    for j=1:Sensor_Num
        dis = norm(Sensor_Loc_Real(i,:)-Sensor_Loc_Real(j,:)); %����CNʹ�õ�����ʵ�ڵ�λ��
            if dis <= Communication_Range && i ~= j
                CNi = [CNi j];
            end
    end
    CN_CELL{i} = CNi;
end

%����ÿһ���ڵ㣬ʹ����CN����ֲ�Voronioͼ��ȷ����LVN������LVN_CELL��¼
pbound=Polyhedron([0 0;Room_Size(1,1) 0;Room_Size(1,1) Room_Size(1,2);0 Room_Size(1,2)]);

LVN_CELL=cell(Sensor_Num,1);
LVN_P=cell(Sensor_Num,1);
for i=1:Sensor_Num
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(sprintf('���ڼ���ڵ�%d��LVN\n',i));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CN = CN_CELL{i};
	CN_Pos = Sensor_Loc(CN,:);
	Cent_Pos = Sensor_Loc(i,:);
	%�ڵ�i���������е�CN����ֲ�Vͼ
	[V P] = mpt_voronoi([Cent_Pos; CN_Pos]','bound',pbound);
    %��LVN_P��¼ÿ���ڵ����ڵ�cell�Ķ�������
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
    
    %��LVN����
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
%     disp(sprintf('�ڵ�%d(%f,%f)��LVN��������£�\n',i,Sensor_Loc(i,1),Sensor_Loc(i,2)));
%     plot(Sensor_Loc(i,1), Sensor_Loc(i,2),'b.-');
%     hold on;
%     for m=i:size(LVN,2)
%         disp(sprintf('�ڵ�ID:%d,����(%f,%f)\n',LVN(1,m),Sensor_Loc(LVN(1,m),1),Sensor_Loc(LVN(1,m),2)));
%         plot(Sensor_Loc(LVN(1,m),1), Sensor_Loc(LVN(1,m),2),'ro-');
%         hold on;
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LVN_CELL{i} = LVN;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����ÿ���ڵ��ƽ��LVN�������Ӷ��ж�Communication_Range�����Ƿ����
num=0;
for i=1:Sensor_Num
    num = num + size(LVN_CELL{i},2);
end;
avg_LVN_num = num / Sensor_Num;
disp(sprintf('ÿ���ڵ�ƽ����%f��LVN\n',avg_LVN_num));