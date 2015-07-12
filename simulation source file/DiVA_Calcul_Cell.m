function [Cell_Point Point_In_Cell_Num Loop_Around] = DiVA_Calcul_Cell( Loop_Around, Center_Node_Pos, Point_Step, Radius_Of_Acoustic, Room_Size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%��Loop_Around����
ty=Loop_Around(:,2)';
tx=Loop_Around(:,1)';
DeltaY=ty-Center_Node_Pos(1,2);
DeltaX=tx-Center_Node_Pos(1,1);
tanalpha=zeros(1,size(Loop_Around,1));
for j=1:size(Loop_Around,1)
     tanalpha(1,j)=DeltaY(1,j)/DeltaX(1,j);
end
temp1=[];%�ڽڵ�i�ұ�
temp1_tanalpha=[];%�ڽڵ�i�ұߵĽڵ�ĽǶ�����
temp2=[];%�ڽڵ�i���
temp2_tanalpha=[];%�ڽڵ�i��ߵĽڵ�ĽǶ�����
for j=1:size(Loop_Around,1)
    if DeltaX(1,j)>=0  %�ڽڵ�i�ұ�
        temp1=[temp1; Loop_Around(j,1) Loop_Around(j,2)];
        temp1_tanalpha=[temp1_tanalpha tanalpha(1,j)];
    else %�ڽڵ�i���
        temp2=[temp2; Loop_Around(j,1) Loop_Around(j,2)];
        temp2_tanalpha=[temp2_tanalpha tanalpha(1,j)];
    end
end
count=1;
for j=1:size(temp1,1)
    [m,n]=find(temp1_tanalpha==max(temp1_tanalpha));
   	Loop_Around(count,1)=temp1(n,1);
 	Loop_Around(count,2)=temp1(n,2);
   	temp1(n,:)=[];
	temp1_tanalpha(:,n)=[];
	count=count+1;
end
for j=1:size(temp2,1)
	[m,n]=find(temp2_tanalpha==max(temp2_tanalpha));
	Loop_Around(count,1)=temp2(n,1);
	Loop_Around(count,2)=temp2(n,2);
	temp2(n,:)=[];
	temp2_tanalpha(:,n)=[];
	count=count+1;
end

%����ջ��������(����������������)
xv=Loop_Around(:,1);
yv=Loop_Around(:,2);
for i=1:size(xv,1)
    if xv(i,1)<Center_Node_Pos(1,1)-Radius_Of_Acoustic
        xv(i,1)=max(Center_Node_Pos(1,1)-Radius_Of_Acoustic, 0);
    end
    if xv(i,1)>Center_Node_Pos(1,1)+Radius_Of_Acoustic
        xv(i,1)=min(Center_Node_Pos(1,1)+Radius_Of_Acoustic,Room_Size(1,1));
    end
    if yv(i,1)<Center_Node_Pos(1,2)-Radius_Of_Acoustic
        yv(i,1)=max(Center_Node_Pos(1,2)-Radius_Of_Acoustic,0);
    end
    if yv(i,1)>Center_Node_Pos(1,2)+Radius_Of_Acoustic
        yv(i,1)=min(Center_Node_Pos(1,2)+Radius_Of_Acoustic,Room_Size(1,2));
    end
end

x_Range=max(xv)-min(xv);
y_Range=max(yv)-min(yv);
x=zeros(1,ceil((x_Range/Point_Step+1)*(y_Range/Point_Step+1)));
y=zeros(1,ceil((x_Range/Point_Step+1)*(y_Range/Point_Step+1)));
k=1;
for i=ceil(min(xv)/Point_Step):ceil(max(xv)/Point_Step+1)
    for j=ceil(min(yv)/Point_Step):ceil(max(yv)/Point_Step+1)
        x(1,k)=Point_Step*(i);
        y(1,k)=Point_Step*(j);
        k=k+1;
    end
end
in = inpolygon(x,y,xv,yv);

In_Cell = find(in==1);
Point_In_Cell_Num = size(In_Cell,2);
cell_x = x(1,In_Cell)';
cell_y = y(1,In_Cell)';
Cell_Point = [cell_x cell_y];

% %��ע�ջ��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:size(xv,1)-1
%     plot([xv(i,1); xv(i+1,1)],[yv(i,1); yv(i+1,1)]);
%     hold on;
% end
% plot([xv(size(xv,1),1); xv(1,1)], [yv(size(xv,1),1); yv(1,1)]);
% hold on;
% plot(Cell_Point(:,1),Cell_Point(:,2),'y.');
% hold on;
% plot(Center_Node_Pos(1,1),Center_Node_Pos(1,2),'k.');
% hold on;

end

