function [CN_CELL ] = Create_LN_Table( Room_Size, Sensor_Loc_Real, Sensor_Loc, Sensor_Num, Communication_Range)

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����ÿ���ڵ��ƽ��LN�������Ӷ��ж�Communication_Range�����Ƿ����
num=0;
for i=1:Sensor_Num
    num = num + size(LN_CELL{i},2);
end;
avg_LN_num = num / Sensor_Num;
disp(sprintf('ÿ���ڵ�ƽ����%f��LN\n',avg_LN_num));