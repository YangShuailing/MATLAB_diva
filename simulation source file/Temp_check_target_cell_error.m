load 'Loc_Error_DiVA_Ep_0.7_Es_4.4e-05_Em_0.0005.mat'

clc

r1 = find(Potential_Node_Num_Record==1);
r2 = find(Potential_Node_Num_Record==2);
r3 = find(Potential_Node_Num_Record==3);
r4 = find(Potential_Node_Num_Record==4);
r5 = find(Potential_Node_Num_Record>4);


result_1 = [0 0 0];%[1 2 3]
for i=1:size(r1,2)
    temp=Err_DiVA_CELL{r1(1,i)};
    result_1(1,temp(1,1)) = result_1(1,temp(1,1))+1;
end
[size(r1,2) result_1]

result_2 = [0 0 0 0 0 0];%[11 12 13 22 23 33]
for i=1:size(r2,2)
    temp=Err_DiVA_CELL{r2(1,i)};
    temp = sort(temp);
    if temp(1,1)==1 && temp(1,2)==1
        result_2(1,1) = result_2(1,1)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2
        result_2(1,2) = result_2(1,2)+1;
    end
    if temp(1,1)==1 && temp(1,2)==3
        result_2(1,3) = result_2(1,3)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2
        result_2(1,4) = result_2(1,4)+1;
    end
    if temp(1,1)==2 && temp(1,2)==3
       result_2(1,5) = result_2(1,5)+1;
    end
    if temp(1,1)==3 && temp(1,2)==3
       result_2(1,6) = result_2(1,6)+1;
    end
end
[size(r2,2) result_2]

result_3 = [0 0 0 0 0 0 0 0 0 0];%[111 112 113 122 123 133 222 223 233 333]
for i=1:size(r3,2)
    temp=Err_DiVA_CELL{r3(1,i)};
    temp = sort(temp);
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==1
        result_3(1,1) = result_3(1,1)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==2
        result_3(1,2) = result_3(1,2)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==3
        result_3(1,3) = result_3(1,3)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2 && temp(1,3)==2
        result_3(1,4) = result_3(1,4)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2 && temp(1,3)==3
        result_3(1,5) = result_3(1,5)+1;
    end
    if temp(1,1)==1 && temp(1,2)==3 && temp(1,3)==3
        result_3(1,6) = result_3(1,6)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2 && temp(1,3)==2
        result_3(1,7) = result_3(1,7)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2 && temp(1,3)==3
        result_3(1,8) = result_3(1,8)+1;
    end
    if temp(1,1)==2 && temp(1,2)==3 && temp(1,3)==3
        result_3(1,9) = result_3(1,9)+1;
    end
    if temp(1,1)==3 && temp(1,2)==3 && temp(1,3)==3
        result_3(1,10) = result_3(1,10)+1;
    end
end
[size(r3,2) result_3]

result_4 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%[1111 1112 1113 1122 1123 1133 1222 1223 1233 1333 2222 2223 2233 2333 3333]
for i=1:size(r4,2)
    temp=Err_DiVA_CELL{r4(1,i)};
    temp = sort(temp);
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==1 && temp(1,4)==1
        result_4(1,1) = result_4(1,1)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==1 && temp(1,4)==2
        result_4(1,2) = result_4(1,2)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==1 && temp(1,4)==3
        result_4(1,3) = result_4(1,3)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==2 && temp(1,4)==2
        result_4(1,4) = result_4(1,4)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==2 && temp(1,4)==3
        result_4(1,5) = result_4(1,5)+1;
    end
    if temp(1,1)==1 && temp(1,2)==1 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,6) = result_4(1,6)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2 && temp(1,3)==2 && temp(1,4)==2
        result_4(1,7) = result_4(1,7)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2 && temp(1,3)==2 && temp(1,4)==3
        result_4(1,8) = result_4(1,8)+1;
    end
    if temp(1,1)==1 && temp(1,2)==2 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,9) = result_4(1,9)+1;
    end
    if temp(1,1)==1 && temp(1,2)==3 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,10) = result_4(1,10)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2 && temp(1,3)==2 && temp(1,4)==2
        result_4(1,11) = result_4(1,11)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2 && temp(1,3)==2 && temp(1,4)==3
        result_4(1,12) = result_4(1,12)+1;
    end
    if temp(1,1)==2 && temp(1,2)==2 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,13) = result_4(1,13)+1;
    end
    if temp(1,1)==2 && temp(1,2)==3 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,14) = result_4(1,14)+1;
    end
    if temp(1,1)==3 && temp(1,2)==3 && temp(1,3)==3 && temp(1,4)==3
        result_4(1,15) = result_4(1,15)+1;
    end
end
[size(r4,2) result_4]

size(r5,2)
for i=1:size(r5,2)
    temp=Err_DiVA_CELL{r5(1,i)};
    temp = sort(temp);
end
size(r5,2)

% pass_1 = [0:1;0 0;0 0]';
% pass_2 = [0:2;0 0 0;0 0 0]';
% pass_3 = [0:3;0 0 0 0; 0 0 0 0]';
% pass_4 = [0:4;0 0 0 0 0; 0 0 0 0 0]';
% pass_5 = [0:5;0 0 0 0 0 0; 0 0 0 0 0 0]';
% for i=1:size(Err_DiVA_CELL,1)
%     temp=Err_DiVA_CELL{i};
%     if ~isempty(find(r1==i))
%         if isempty(temp)
%             pass_1(1,2) = pass_1(1,2)+1;
%         else
%             pass_1(size(temp,2)+1,2) = pass_1(size(temp,2)+1,2)+1;
%             pass_1(size(temp,2)+1,3) = pass_1(size(temp,2)+1,3)+temp;
%         end
%     end
%     if ~isempty(find(r2==i))
%         if isempty(temp)
%             pass_2(1,2) = pass_2(1,2)+1;
%         else
%            pass_2(size(temp,2)+1,2) = pass_2(size(temp,2)+1,2)+1;
%            for j=1:size(temp,2)
%                 pass_2(size(temp,2)+1,3) = pass_2(size(temp,2)+1,3)+temp(1,j);
%            end
%         end
%     end
%     if ~isempty(find(r3==i))
%         if isempty(temp)
%             pass_3(1,2) = pass_3(1,2)+1;
%         else
%             pass_3(size(temp,2)+1,2) = pass_3(size(temp,2)+1,2)+1;
%             for j=1:size(temp,2)
%                 pass_3(size(temp,2)+1,3) = pass_3(size(temp,2)+1,3)+temp(1,j);
%             end
%         end
%     end
%     if ~isempty(find(r4==i))
%         if isempty(temp)
%             pass_4(1,2) = pass_3(1,2)+1;
%         else
%             pass_4(size(temp,2)+1,2) = pass_4(size(temp,2)+1,2)+1;
%             for j=1:size(temp,2)
%                 pass_4(size(temp,2)+1,3) = pass_4(size(temp,2)+1,3)+temp(1,j);
%             end
%         end
%     end
%     if ~isempty(find(r5==i))
% %         if isempty(temp)
% %             pass_5(1,2) = pass_5(1,2)+1;
% %         else
% %             pass_5(size(temp,2)+1,2) = pass_5(size(temp,2)+1,2)+1;
% %             for j=1:size(temp,2)
% %                 pass_5(size(temp,2)+1,3) = pass_5(size(temp,2)+1,3)+temp(1,j);
% %             end
% %         end
%     end
% end
% disp(sprintf('收敛于1个节点的次数%d',size(r1,2)));
% disp(sprintf('收敛于1个节点：\n0个验证通过出现了%d次\n1个验证通过出现了%d次,平均误差%f\n',pass_1(1,2),pass_1(2,2),pass_1(2,3)./pass_1(2,2)));
% disp(sprintf('收敛于2个节点的次数%d',size(r2,2)));
% disp(sprintf('收敛于2个节点：\n0个验证通过出现了%d次\n1个验证通过出现了%d次,平均误差%f\n2个验证通过出现了%d次,平均误差%f\n',pass_2(1,2),pass_2(2,2),pass_2(2,3)./pass_2(2,2),pass_2(3,2),pass_2(3,3)./pass_2(3,2)./2));
% disp(sprintf('收敛于3个节点的次数%d',size(r3,2)));
% disp(sprintf('收敛于3个节点：\n0个验证通过出现了%d次\n1个验证通过出现了%d次,平均误差%f\n2个验证通过出现了%d次,平均误差%f\n3个验证通过出现了%d次,平均误差%f\n',pass_3(1,2),pass_3(2,2),pass_3(2,3)./pass_3(2,2),pass_3(3,2),pass_3(3,3)./pass_3(3,2)./2,pass_3(4,2),pass_3(4,3)./pass_3(4,2)./3));
% disp(sprintf('收敛于4个节点的次数%d',size(r4,2)));
% disp(sprintf('收敛于4个节点：\n0个验证通过出现了%d次\n1个验证通过出现了%d次,平均误差%f\n2个验证通过出现了%d次,平均误差%f\n3个验证通过出现了%d次,平均误差%f\n4个验证通过出现了%d次,平均误差%f\n',pass_4(1,2),pass_4(2,2),pass_4(2,3)./pass_4(2,2),pass_4(3,2),pass_4(3,3)./pass_4(3,2)./2,pass_4(4,2),pass_4(4,3)./pass_4(4,2)./3,pass_4(5,2),pass_4(5,3)./pass_4(5,2)./4));
% %disp(sprintf('收敛于5个节点：\n0个验证通过出现了%d次\n1个验证通过出现了%d次,平均误差%f\n2个验证通过出现了%d次,平均误差%f\n3个验证通过出现了%d次,平均误差%f\n4个验证通过出现了%d次,平均误差%f\n5个验证通过出现了%d次,平均误差%f\n',pass_5(1,2),pass_5(2,2),pass_5(2,3)./pass_5(2,2),pass_5(3,2),pass_5(3,3)./pass_5(3,2)./2,pass_5(4,2),pass_5(4,3)./pass_5(4,2)./3,pass_5(5,2),pass_5(5,3)./pass_5(5,2)./4,pass_5(6,2),pass_5(6,3)./pass_5(6,2)./5));
% 
