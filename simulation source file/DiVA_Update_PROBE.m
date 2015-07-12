function [ PROBE PROBE_index ] = DiVA_Update_PROBE(PROBE, PROBE_index, Visited_LVN, UnVisited_LVN)
%DIVA_UPDATE_PROBE Summary of this function goes here
%   Detailed explanation goes here

if isempty(UnVisited_LVN) %�������LVN��probe��ɣ�ֱ�ӱ�ǽ���
    PROBE = -1;
    PROBE_index = -1;
else
    if size(Visited_LVN,1)>1 %����Ѿ�probe������������LVN�����Ծݴ��ƶ���һ��probe�����LVN
        Pre_PROBE_index = Visited_LVN(end-1,1);
        if Pre_PROBE_index == PROBE_index - 1
            if PROBE_index < (size(Visited_LVN,1)+size(UnVisited_LVN,1))
                PROBE_index = PROBE_index+1;
                np = find(UnVisited_LVN(:,1) == PROBE_index);
                PROBE = UnVisited_LVN(np,2);
            else
                PROBE_index = 1;
                np = find(UnVisited_LVN(:,1) == PROBE_index);
                PROBE = UnVisited_LVN(np,2);
            end
        else if Pre_PROBE_index == PROBE_index + 1
           	if PROBE_index > 1
               	PROBE_index = PROBE_index-1;
             	np = find(UnVisited_LVN(:,1) == PROBE_index);
             	PROBE = UnVisited_LVN(np,2);
            else
                PROBE_index = size(Visited_LVN,1)+size(UnVisited_LVN,1);
             	np = find(UnVisited_LVN(:,1) == PROBE_index);
             	PROBE = UnVisited_LVN(np,2);
            end
        else if abs(Pre_PROBE_index - PROBE_index) >1
            if PROBE_index == 1
            	PROBE_index = 2;
              	np = find(UnVisited_LVN(:,1) == PROBE_index);
             	PROBE = UnVisited_LVN(np,2);
            else
             	PROBE_index = PROBE_index-1;
              	np = find(UnVisited_LVN(:,1) == PROBE_index);
              	PROBE = UnVisited_LVN(np,2);
            end
        end
    end
end
else if Visited_LVN(1,1)>1 %���ֻprobe��һ��LVN��ѡ����һ��probe��LVN��ֻҪ��һ��PROBE_indexѡ�Ĳ���1���ڶ�����ѡPROBE_index-1
        np = find(UnVisited_LVN(:,1) == PROBE_index-1);
        PROBE = UnVisited_LVN(np,2);
        PROBE_index = np;
    else
       	PROBE = UnVisited_LVN(end,2);
        PROBE_index = size(UnVisited_LVN,1)+size(Visited_LVN,1);
    end
end

end

