filename = 'ResultData_P5_1.mat';
load('a.mat');
load('GridInfo.mat');
load('BestRoutes.mat');
load('CycleLength.mat');
load('CycleMean.mat');
load('Time.mat');
load('Length.mat');
load('PreferedGrids.mat');
load('AntArriveTimes.mat');
save(filename, 'a', 'GridInfo', 'BestRoutes','CycleLength', 'CycleMean', 'Time', 'Length', 'PreferedGrids', 'AntArriveTimes');