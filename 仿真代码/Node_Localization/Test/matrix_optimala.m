function   [a1,segmaX]=matrix_optimala(a,Da,Wa)
%%%�����ظ��Ż��ĺ��ļ������֮һ��a��N��δ֪�ڵ��������Da��δ֪�ڵ�֮��Ĳ�����Wa��δ֪�ڵ�֮�����Ȩ�غ�����
%%%% a1�Ǹ����ظ��Ż���ʽ�����������һ��������δ֪�ڵ�����
%%%����segmaX�ǵ�ǰδ֪�ڵ��������a��Ϊ��λ��������ʵ�ʵĲ����ܵ�ƽ�����ͣ�Ҳ���Ż�������ֵ���˺���ֻ����δ֪�ڵ��������֮��Ĳ��
%%%��Ϣ������������п������������
%%% a(N*K) is the coordinates of the unknown nodes,N:is the number of the
%%% unknown nodes,K: is the dimensional(2 or 3 in fact)
%%% Da(N*N) is the measured distance matrix between the unknown nodes
%%% Wa(N*N) is the weight matrix of the unknown nodes
%%% a1(N*K) is the returned coordinate matrix according to the input a
%%% segmaX is the error value according to the measured distance Da and the
%%% estimated coordinates
%%% Author: Xie Dongfeng
row_a=size(a,1);
%%% row_a=N
 calculated_disa=L2_distance(a',a');
 %%% calculated_disa is the distance between the unknown nodes by
 %%% calculating  the estimated coordinates
 
 B1X=zeros(row_a,row_a);
 for i=1:row_a
     for j=1:row_a
         if(i~=j&&calculated_disa(i,j)~=0)
             B1X(i,j)=-Wa(i,j)*Da(i,j)/calculated_disa(i,j);
         end
     end
 end
 for i=1:row_a
     for j=1:row_a
         if(j~=i)
             B1X(i,i)=B1X(i,i)-B1X(i,j);
         end
     end
 end
 
 V1=zeros(row_a,row_a);
 for i=1:row_a
     for j=1:row_a
         if(i~=j)
             V1(i,j)=-Wa(i,j);
             V1(i,i)=V1(i,i)+Wa(i,j);
         end
     end
 end
 V1a=inv(V1+ones(row_a))-1/(row_a^2)*ones(row_a);
 a1=V1a*B1X*a;
 
 segma=0;
 for i=1:row_a
     for j=i+1:row_a
         segma=segma+Wa(i,j)*Da(i,j)*Da(i,j);
     end
 end
 segmaX=segma+trace(a'*V1*a)-2*trace(a'*B1X*a);
        