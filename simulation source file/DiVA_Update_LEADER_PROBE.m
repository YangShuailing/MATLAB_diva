function [LEADER PROBE UnVisited_LVN Visited_LVN PROBE_index]=DiVA_Update_LEADER_PROBE(LEADER, PROBE, Visited_LVN, LVN_CELL)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Old_LEADER = LEADER;
LEADER = PROBE;
LVN = LVN_CELL{LEADER};
        
UnVisited_LVN = [1:size(LVN,2);LVN]';
if ~isempty(Visited_LVN)
    tmp1 = Visited_LVN(end,2);
    tmp1_index = UnVisited_LVN(find(UnVisited_LVN(:,2) == tmp1),1);
    Visited_LVN = [tmp1_index tmp1];
    UnVisited_LVN(find(UnVisited_LVN(:,1) == tmp1_index),:) = [];
end
Old_LEADER_index = UnVisited_LVN(find(UnVisited_LVN(:,2) == Old_LEADER),1);
Visited_LVN = [Visited_LVN; Old_LEADER_index Old_LEADER];
UnVisited_LVN(find(UnVisited_LVN(:,1) == Old_LEADER_index),:) = [];

[PROBE PROBE_index]= DiVA_Update_PROBE(Old_LEADER, Old_LEADER_index, Visited_LVN, UnVisited_LVN)

end

