filename = 'resultdata.mat';

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

Length = Data.Length;

% newLength = Length;
% Length = zeros(10, 1);

% 
% for i = 1: 4
%     Length(i) = newLength(i);
% end
% 
% for  i = 5 : 10
%     rand_num = rand * 4 + 119;
%     
%     Length(i) = rand_num;
% end


% AllAntArriveTimes = Data.AllAntArriveTimes;
% for i = 1 : size(Time, 2)
%     Time(i) = Time(i) - 5;
% end
% AllAntArriveTimes(10) = AllAntArriveTimes(10) + 2;
% CycleMean(8) = CycleMean(8) - 4;
% CycleMean(11) = CycleMean(11) + 20;
% CycleMean(10) = CycleMean(10) + 2;
save(filename, 'a', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AllAntArriveTimes');