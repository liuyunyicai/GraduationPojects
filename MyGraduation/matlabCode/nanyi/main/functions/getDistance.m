%% ==== 求两个位置之间的距离========%%

function [distance] = getDistance(Index1, Index2,Intervals)

distance = ((Index1(1) - Index2(1)) *  Intervals(1))^ 2 +( (Index1(2) - Index2(2)) *  Intervals(2)) ^ 2 +  ((Index1(3) - Index2(3))*  Intervals(3)) ^ 2 ;
distance = distance ^ 0.5;
