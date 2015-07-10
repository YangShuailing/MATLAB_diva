% main function
clc;
clear all  %��� 
close all; %�ر�֮ǰ����

Size_Grid=14;  %�����С����λ��m 
Room_Length=Size_Grid; %���䳤��
Room_Width=Size_Grid;  %������
Microphone_Distance=0.2; %�ֻ�������mic֮�����
scale=1;
KNN=4;  %% Basic Hamming parameter ��Hamming������С��KNN����ȡƽ��
Node_number=10;  %%%%%%%%%%%%%%%%%%%%%%%%%%�ɱ������ʵ����ʹ�õĽ�����
Microphone_1_Location=zeros(Node_number,2);
Microphone_2_Location=zeros(Node_number,2);
Microphone_Cita=zeros(Node_number,1);
Microphone_Center_Location=zeros(Node_number,2);
%���Ե��0��1��
 
 
%%%%%%%������˷�λ�ó�����Ϣ
        Microphone_Cita=fix(-90+180*(rand(Node_number,1))); %%���� [-90  90]    
        Microphone_Center_Location=fix(Size_Grid*abs((rand(Node_number,2)))); % ���� λ��
       
        Microphone_1_Location=zeros(Node_number,2);
		Microphone_2_Location=zeros(Node_number,2);
		
        for  i=1:Node_number
        %%(L/2,0)
	    Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
		 %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
        end
 
% disp('Microphone1: ');
% disp(Microphone_1_Location);
% disp('**********************************************');
% disp('Microphone2: ');
% disp(Microphone_2_Location);
% disp('**********************************************');
figure('Position',[1 1 900 900])
plot(Microphone_1_Location(1:3,1),Microphone_1_Location(1:3,2),'b.',Microphone_2_Location(1:3,1),Microphone_2_Location(1:3,2),'b.',Microphone_Center_Location(1:3,1),Microphone_Center_Location(1:3,2),'r*');
hold on;
plot(Microphone_1_Location(4:Node_number,1),Microphone_1_Location(4:Node_number,2),'b.',Microphone_2_Location(4:Node_number,1),Microphone_2_Location(4:Node_number,2),'b.',Microphone_Center_Location(4:Node_number,1),Microphone_Center_Location(4:Node_number,2),'r.');
axis([0 Size_Grid 0 Size_Grid]) ;
return  		 
% 
% figure('Position',[1 1 900 900])
% %plot(estimated_location_hamming(1,1),estimated_location_hamming(1,2),'go');
% 
% plot(estimated_location_advanced(1,1),estimated_location_advanced(1,2),'ro');
% hold on
% plot(6.5,6.5,'*');
% 
% plot(Microphone_1_Location(:,1),Microphone_1_Location(:,2),'b.',Microphone_2_Location(:,1),Microphone_2_Location(:,2),'b.',Microphone_Center_Location(:,1),Microphone_Center_Location(:,2),'y.');
% arrow([estimated_location_advanced(1,1) estimated_location_advanced(1,2)],[6.8 6.5]);
% hold off
% axis([0 Size_Grid 0 Size_Grid]) ;
% 
%  legend('\fontsize{12}\bf Result of Weighting HammingLoc','\fontsize{12}\bf Actual Location','\fontsize{12}\bf Pair of Microphones');
% % 
% %  xlabel('\fontsize{40}\bf Number of Node');
% %  ylabel('\fontsize{40}\bf Localization Error(in units)');
% % title('\fontsize{40}\bf  Localization Error vs. Number of Node');


