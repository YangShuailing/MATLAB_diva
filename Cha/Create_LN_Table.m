function [CN_CELL ] = Create_LN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range)

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算每个节点的平均LN个数，从而判断Communication_Range给的是否合适
num=0;
for i=1:Sensor_Num
    num = num + size(LN_CELL{i},2);
end;
avg_LN_num = num / Sensor_Num;
disp(sprintf('每个节点平均有%f个LN\n',avg_LN_num));