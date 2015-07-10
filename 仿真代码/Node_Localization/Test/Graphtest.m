clc;
clear;
N=10;M=3;% global N M    %%N��δ֪�ڵ���Ŀ��M����֪�ڵ���Ŀ
radius=5;     %%��ͨ�Ű뾶Ϊ5m
actualunknownnodecoor=8*rand(N,2)+ones(N,2);     %%δ֪�ڵ�ʵ������ֲ���8*8��������
%%actualunknownnodecoor=10*rand(N,2);
%%refnodecoor=10*rand(M,2);
% refnodecoor=[0 0;10 0;10 10;0 10];        %%�ο����ű꣩�ڵ�ֲ����ĸ��߽�
refnodecoor=[0 0;10 0 ;0 10];        %%�ο����ű꣩�ڵ�ֲ��������߽�
undis=L2_distance(actualunknownnodecoor',actualunknownnodecoor');    %%����δ֪�ڵ�����֮���ŷ������
refdis=L2_distance(actualunknownnodecoor',refnodecoor');             %%����δ֪�ڵ�� �ű�ڵ�֮���ŷ�����룻L2_distance���ú��������������������������ĵ���֮��ŷ������
CN=zeros(N);         %%δ֪�ڵ�֮��Ļ�����ϵ��ʼ����Ҳ��Ȩ�غ���
CNM=zeros(N,M);      %%δ֪�ڵ����ű�ڵ�֮��Ļ�����ϵ��ʼ����Ҳ��Ȩ�غ���
for i=1:N
    for j=1:N
        if(i~=j&&undis(i,j)<=radius)    %%���ڵ�֮�������ͨ�Ű뾶�ڣ�������Ч��Ȩ�غ�����Ϊ1
            CN(i,j)=1;
        end
    end
end
for i=1:N
    for j=1:M
        if(refdis(i,j)<=radius)
            CNM(i,j)=1;
        end
    end
end

iterative_time=60;              %%����������Ϊ60
absolute_error_value=0.0001;     %%%������С��ֵ
%% initial_value=10*randn(N,2);
initial_value=zeros(N,2);           %%%��ʼ���������Ϊ0
a0=initial_value;
[a1,segmaX0]=matrix_optimal(a0,refnodecoor,undis,refdis,CN,CNM);
segmaX1=segmaX0;
k=0;
while(k==0|(segmaX0-segmaX1>absolute_error_value&&k<=iterative_time))
    k=k+1;
    segmaX0=segmaX1;
    a0=a1;
    [a1,segmaX1]=matrix_optimal(a0,refnodecoor,undis,refdis,CN,CNM);    %%%��������Ż���������һ������a1�͵�ǰ��СֵsegmaX1
end
calcoor=a1;
rectangle('Position',[0,0,10,10]);       %%%������Щ�ǻ�ͼ����
axis auto;
grid on;
hold on;
plot(actualunknownnodecoor(:,1),actualunknownnodecoor(:,2),'r*');   %%%δ֪�ڵ�ʵ�������ú�ɫ*�ű�ʾ
plot(refnodecoor(:,1),refnodecoor(:,2),'ko');                      %%%�ο��ڵ��ú�ɫԲȦ��ʾ
plot(calcoor(:,1),calcoor(:,2),'bd');                     %%%��λ��������ʯ���ű�ʾ

