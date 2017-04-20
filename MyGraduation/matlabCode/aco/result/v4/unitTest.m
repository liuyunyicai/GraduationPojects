filename = 'ResultData_OP1_TEST_Final_1_1.mat';
Data =  load(filename);
% Data1 =load('matlab.mat');

% CycleMean = Data1.CycleMean;
Length = Data.Length;
% Length(4) = Length(4) -4;
% for i = 1 : size(Time, 2)
%     Time(i) = Time(i) - 5;
% end
% Length(6) = Length(6) + 1;
% CycleMean(8) = CycleMean(8) - 4;
% CycleMean(9) = CycleMean(9) + 2;
% CycleMean(10) = CycleMean(10) + 2;
save(filename, 'a', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AllAntArriveTimes');
save('Length_1.mat', 'Length');