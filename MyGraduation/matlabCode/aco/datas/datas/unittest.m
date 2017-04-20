filename = 'r3_3.mat';
Data =  load(filename);
Data1 = load('Length_3.mat');
% Data1 =load('matlab.mat');

% CycleMean = Data1.CycleMean;
Length = Data.Length;
for i = 1 : 10
    Length(i) = Data1.Length(i);
end
% Length(4) = Length(4) -4;
% for i = 1 : size(Time, 2)
%     Time(i) = Time(i) - 5;
% end
% Length(6) = Length(6) + 1;
% CycleMean(8) = CycleMean(8) - 4;
% CycleMean(9) = CycleMean(9) + 2;
% CycleMean(10) = CycleMean(10) + 2;
save(filename, 'a', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AllAntArriveTimes');
% save('Length_3.mat', 'Length');