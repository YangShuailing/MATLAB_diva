function [Finally_Area_Point Point_In_Final_Area_Num] = DiVA_Calcul_Final_Area( Target_Cell_Point, Point_In_Cell_Num, Related_Node_Pos, Related_Node_TOA)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%计算细分用的直线（这里包括了target cell的边界所用的线）,判断在线的哪一边
K=[];
B=[];
Closer=[];
for i=1:size(Related_Node_Pos,1)-1
	for j=i+1:size(Related_Node_Pos,1)
     	L_Midpoint = [(Related_Node_Pos(i,1) + Related_Node_Pos(j,1))./2 (Related_Node_Pos(i,2) + Related_Node_Pos(j,2))./2];
        Temp_K=(Related_Node_Pos(i,2) - Related_Node_Pos(j,2))./(Related_Node_Pos(i,1) -Related_Node_Pos(j,1));
    	K=[K; (-1)/Temp_K];
        B=[B; L_Midpoint(1,2)-K(end,1) * L_Midpoint(1,1)];
        if Related_Node_TOA(i,1) > Related_Node_TOA(j,1)
          	Closer=[Closer; Related_Node_Pos(j,:)];%表示距离node j比i要近
        else
          	Closer=[Closer; Related_Node_Pos(i,:)];%表示距离node i比j要近
      	end
    end
end

%画出细分用的直线%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xx=min(Related_Node_Pos(:,1)):0.1:max(Related_Node_Pos(:,1));
% for i=1:size(K,1)
%     yy=K(i,1)*xx+B(i,1);
%     plot(xx,yy);
%     axis([min(Related_Node_Pos(:,1)) max(Related_Node_Pos(:,1)) min(Related_Node_Pos(:,2)) max(Related_Node_Pos(:,2))]);
%     hold on;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%利用闭环周围最临近的一圈sensor二分进一步划分闭环区域
Target_Cell_Point_Weight=zeros(1,Point_In_Cell_Num);
for i=1:size(K,1)
    for j=1:Point_In_Cell_Num
        if(K(i,1)*Target_Cell_Point(j,1)-Target_Cell_Point(j,2)+B(i,1)) * (K(i,1)*Closer(i,1)-Closer(i,2)+B(i,1))>0
            Target_Cell_Point_Weight(1,j) = Target_Cell_Point_Weight(1,j)+1;
        end
    end
end

OverlopTimes=max(Target_Cell_Point_Weight);
t = find(Target_Cell_Point_Weight == OverlopTimes);
Point_In_Final_Area_Num = size(t,2);
Finally_Area_Point = Target_Cell_Point(t,:);
end

