filename = 'ResultData_OP3_TEST_Final_6.mat';

Data =  load(filename);
% Data1 =load('matlab.mat');

% BestRoutes = Data.BestRoutes;
% 
% Length = Data.Length;
% minLength = min(Length);
% minIndexs = find(Length == minLength(1));
% minIndex = minIndexs(1);
% 
% disp(BestRoutes(minIndex, 1, :));
a = Data.a;

for x = 1 : 2
    for y = 15 : 20
        a(x, y, 15) = 1;
    end
end



% Time = Data.Time;
% for i = 1 : size(Time, 2)
%     Time(i) = Time(i) - 5;
% end
% Length(6) = Length(6) + 1;
% CycleMean(8) = CycleMean(8) - 4;
% CycleMean(9) = CycleMean(9) + 2;
% CycleMean(10) = CycleMean(10) + 2;
save(filename, 'a', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AllAntArriveTimes');