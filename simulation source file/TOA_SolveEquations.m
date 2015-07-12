function [loc] = TOA_SolveEquations(Sensor_Loc1,Sensor_Loc2,Sensor_Loc3,Sensor_TOA1,Sensor_TOA2,Sensor_TOA3)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x0=Sensor_Loc1(1,1);
y0=Sensor_Loc1(1,2);
x1=Sensor_Loc2(1,1);
y1=Sensor_Loc2(1,2);
x2=Sensor_Loc3(1,1);
y2=Sensor_Loc3(1,2);
t0 = Sensor_TOA1;
t1 = Sensor_TOA2;
t2 = Sensor_TOA3;

%计算实际测量的三个距离值
r0=t0*340;
r1=t1*340;
r2=t2*340;
    

d01=norm([x0 y0]-[x1 y1]);
d02=norm([x0 y0]-[x2 y2]);
d12=norm([x1 y1]-[x2 y2]);

loc = NaN;

maxr01 = max(r0,r1);
maxr02 = max(r0,r2);
maxr12 = max(r2,r1);
minr01 = min(r0,r1);
minr02 = min(r0,r2);
minr12 = min(r2,r1);

if ((r0+r1>d01&&maxr01<d01)||(maxr01>d01&&maxr01-minr01<d01)) && ((r0+r2>d02&&maxr02<d02)||(maxr02>d02&&maxr02-minr02<d02)) && ((r1+r2>d12&&maxr12<d12)||(maxr12>d12&&maxr12-minr12<d12)) 
%     disp(sprintf('三个圆两两相交\n'));
     p01 = TOA_circleCross(x0,y0,r0,x1,y1,r1);
     p02 = TOA_circleCross(x0,y0,r0,x2,y2,r2);
     p12 = TOA_circleCross(x1,y1,r1,x2,y2,r2);
     dis_p = [norm(p01(1,:)-p01(2,:)) norm(p02(1,:)-p02(2,:)) norm(p12(1,:)-p12(2,:))];
     [dis_min dis_pos ] = min(dis_p);
     if dis_pos == 1 
          unit_v1 = (p01(1,:)-[x2 y2])/norm(p01(1,:)-[x2 y2]);
          temp1 = [x2 y2] + unit_v1*r2;
          unit_v2 = (p01(2,:)-[x2 y2])/norm(p01(2,:)-[x2 y2]);
          temp2 = [x2 y2] + unit_v2*r2;
          if norm(p01(1,:)-temp1) < norm(p01(2,:)-temp2)
              loc = (p01(1,:)+temp1)./2;
          else
              loc = (p01(2,:)+temp2)./2;
          end
     end
  	 if dis_pos == 2
          unit_v1 = (p02(1,:)-[x1 y1])/norm(p02(1,:)-[x1 y1]);
          temp1 = [x1 y1] + unit_v1*r1;
          unit_v2 = (p02(2,:)-[x1 y1])/norm(p02(2,:)-[x1 y1]);
          temp2 = [x1 y1] + unit_v2*r1;
          if norm(p02(1,:)-temp1) < norm(p02(2,:)-temp2)
              loc = (p02(1,:)+temp1)./2;
          else
              loc = (p02(2,:)+temp2)./2;
          end   
     end
     if dis_pos == 3
          unit_v1 = (p12(1,:)-[x0 y0])/norm(p12(1,:)-[x0 y0]);
          temp1 = [x0 y0] + unit_v1*r0;
          unit_v2 = (p12(2,:)-[x0 y0])/norm(p12(2,:)-[x0 y0]);
          temp2 = [x0 y0] + unit_v2*r0;
          if norm(p12(1,:)-temp1) < norm(p12(2,:)-temp2)
              loc = (p12(1,:)+temp1)./2;
          else
              loc = (p12(2,:)+temp2)./2;
          end      
     end
end
if ((r0+r1>d01&&maxr01<d01)||(maxr01>d01&&maxr01-minr01<d01))  && ((r0+r2>d02&&maxr02<d02)||(maxr02>d02&&maxr02-minr02<d02))  && ((r1+r2<d12)||(maxr12-minr12>d12)) 
%     disp(sprintf('01 02相交，12不相交\n'));
    p01 = TOA_circleCross(x0,y0,r0,x1,y1,r1);
    p02 = TOA_circleCross(x0,y0,r0,x2,y2,r2);
    min_dis = inf;
    p01_choose = 0;
    p02_choose = 0;
    for i=1:size(p01,1)
        for j=1:size(p02,1)
            if min_dis > norm(p01(i,:)-p02(j,:))
                min_dis = norm(p01(i,:)-p02(j,:));
                p01_choose = i;
                p02_choose = j;
            end
        end
    end
    loc = (p01(p01_choose,:) + p02(p02_choose,:))./2;
end

if ((r0+r1>d01&&maxr01<d01)||(maxr01>d01&&maxr01-minr01<d01)) && ((r1+r2>d12&&maxr12<d12)||(maxr12>d12&&maxr12-minr12<d12)) && ((r0+r2<d02)||(maxr02-minr02>d02))
%     disp(sprintf('01 12相交，02不相交\n'));
    p01 = TOA_circleCross(x0,y0,r0,x1,y1,r1);
    p12 = TOA_circleCross(x1,y1,r1,x2,y2,r2);
    min_dis = inf;
    p01_choose = 0;
    p12_choose = 0;
    for i=1:size(p01,1)
        for j=1:size(p12,1)
            if min_dis > norm(p01(i,:)-p12(j,:))
                min_dis = norm(p01(i,:)-p12(j,:));
                p01_choose = i;
                p12_choose = j;
            end
        end
    end
    loc = (p01(p01_choose,:) + p12(p12_choose,:))./2;
end
if ((r0+r2>d02&&maxr02<d02)||(maxr02>d02&&maxr02-minr02<d02)) && ((r1+r2>d12&&maxr12<d12)||(maxr12>d12&&maxr12-minr12<d12)) && ((r0+r1<d01)||(maxr01-minr01>d01))
    %      disp(sprintf('02 12相交，01不相交\n'));
    p02 = TOA_circleCross(x0,y0,r0,x2,y2,r2);
    p12 = TOA_circleCross(x1,y1,r1,x2,y2,r2);
    min_dis = inf;
    p02_choose = 0;
    p12_choose = 0;
    for i=1:size(p02,1)
        for j=1:size(p12,1)
            if min_dis > norm(p02(i,:)-p12(j,:))
                min_dis = norm(p02(i,:)-p12(j,:));
                p02_choose = i;
                p12_choose = j;
            end
        end
    end
    loc = (p02(p02_choose,:) + p12(p12_choose,:))./2;
end

if ((r0+r1>d01&&maxr01<d01)||(maxr01>d01&&maxr01-minr01<d01)) && ((r0+r2<d02)||(maxr02-minr02>d02)) && ((r1+r2<d12)||(maxr12-minr12>d12)) 
   %     disp(sprintf('01相交，02 12不相交\n'));
    p01 = TOA_circleCross(x0,y0,r0,x1,y1,r1);
    unit_v1 = (p01(1,:)-[x2 y2])/norm(p01(1,:)-[x2 y2]);
   	temp1 = [x2 y2] + unit_v1*r2;
	unit_v2 = (p01(2,:)-[x2 y2])/norm(p01(2,:)-[x2 y2]);
	temp2 = [x2 y2] + unit_v2*r2;
	if norm(p01(1,:)-temp1) < norm(p01(2,:)-temp2)
        loc = (p01(1,:)+temp1)./2;
    else
        loc = (p01(2,:)+temp2)./2;
    end
end

if ((r0+r2>d02&&maxr02<d02)||(maxr02>d02&&maxr02-minr02<d02)) && ((r0+r1<d01)||(maxr01-minr01>d01)) && ((r1+r2<d12)||(maxr12-minr12>d12))
    %disp(sprintf('02相交，01 12不相交\n'));
    p02 = TOA_circleCross(x0,y0,r0,x2,y2,r2);
    unit_v1 = (p02(1,:)-[x1 y1])/norm(p02(1,:)-[x1 y1]);
   	temp1 = [x1 y1] + unit_v1*r1;
 	unit_v2 = (p02(2,:)-[x1 y1])/norm(p02(2,:)-[x1 y1]);
	temp2 = [x1 y1] + unit_v2*r1;
	if norm(p02(1,:)-temp1) < norm(p02(2,:)-temp2)
     	loc = (p02(1,:)+temp1)./2;
    else
        loc = (p02(2,:)+temp2)./2;
    end   
end
if ((r1+r2>d12&&maxr12<d12)||(maxr12>d12&&maxr12-minr12<d12)) && ((r0+r1<d01)||(maxr01-minr01>d01)) && ((r0+r2<d02)||(maxr02-minr02>d02))
    %disp(sprintf('12相交，01 02不相交\n'));
    p12 = TOA_circleCross(x1,y1,r1,x2,y2,r2);
    unit_v1 = (p12(1,:)-[x0 y0])/norm(p12(1,:)-[x0 y0]);
	temp1 = [x0 y0] + unit_v1*r0;
	unit_v2 = (p12(2,:)-[x1 y1])/norm(p12(2,:)-[x0 y0]);
	temp2 = [x0 y0] + unit_v2*r0;
	if norm(p12(1,:)-temp1) < norm(p12(2,:)-temp2)
        loc = (p12(1,:)+temp1)./2;
    else
        loc = (p12(2,:)+temp2)./2;
	end
end
if ((r0+r1<d01)||(maxr01-minr01>d01)) && ((r0+r2<d02)||(maxr02-minr02>d02)) && ((r1+r2<d12)||(maxr12-minr12>d12)) 
    %disp(sprintf('三圆互不相交\n'));
    p01 = [x0 y0]+ [x1-x0 y1-y0]./d01 *(r0 + (d01-r0-r1)*r0./(r0+r1));
    p02 = [x0 y0]+ [x2-x0 y2-y0]./d02 *(r0 + (d02-r0-r2)*r0./(r0+r2));
    p12 = [x1 y1]+ [x2-x1 y2-y1]./d12 *(r1 + (d12-r1-r2)*r1./(r1+r2));
    temp_x = [p01(1,1) p02(1,1) p12(1,1)];  
    temp_y = [p01(1,2) p02(1,2) p12(1,2)];  
    loc = [mean(temp_x) mean(temp_y)]; 
end
if isinf(r0) || (isinf(r1)) || (isinf(r2))
    loc = [];
end
end

