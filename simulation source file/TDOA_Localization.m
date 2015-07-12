function [ Estimated_Location ] = TDOA_Localization(Sensor_Num, Sensor_Loc, Sensor_TOA, Target_Loc)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    Estimated_Location=[];
    for i = 1:Sensor_Num
        for j = 1:Sensor_Num-1    
            for k = j+1:Sensor_Num
                if i~=j &&i~=k
                    Delta_t12 = Sensor_TOA(j,1)-Sensor_TOA(i,1);
                    Delta_t13 = Sensor_TOA(k,1)-Sensor_TOA(i,1);
                    Estimated_Location = [Estimated_Location; TDOA_SolveEquations(Sensor_Loc(i,:),Sensor_Loc(j,:),Sensor_Loc(k,:),Delta_t12,Delta_t13, Target_Loc)];
                end
            end      
        end
    end
end

