function [ TOA_estimated_loc ] = TOA_Localization( Sensor_Num, Sensor_Loc, Sensor_TOA)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

TOA_estimated_loc = [];
for i = 1:Sensor_Num-2;
	for j = i+1:Sensor_Num-1
        for k = j+1:Sensor_Num
            %%调用函数求解位置坐标
            loc = TOA_SolveEquations(Sensor_Loc(i,:),Sensor_Loc(j,:),Sensor_Loc(k,:),Sensor_TOA(i,1),Sensor_TOA(j,1),Sensor_TOA(k,1));
            TOA_estimated_loc = [TOA_estimated_loc; loc];
        end
	end
end
end

