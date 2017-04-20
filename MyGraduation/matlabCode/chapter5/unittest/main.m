run('testACO3');
ss = 'Final_3';
%重新设定一些参数
for pp = 0: 1
    if pp == 0
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
%         OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
%         OptimizeTypes(OPTIMIZE_3) = 1;
%         OptimizeTypes(OPTIMIZE_4) = 1;
%         OptimizeTypes(OPTIMIZE_2) = 1;
        % OptimizeTypes(OPTIMIZE_8) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE3) = 1;
        ant_num = 20;

        Label = sprintf('OP100_TEST_%s', ss)
    elseif pp == 1
        ant_num = 200;
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
%         OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 0;
%         OptimizeTypes(OPTIMIZE_3) = 1;
%         OptimizeTypes(OPTIMIZE_4) = 1;
%         OptimizeTypes(OPTIMIZE_2) = 1;
        % OptimizeTypes(OPTIMIZE_8) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE3) = 1;

        Label = sprintf('OP000_TEST_%s', ss)

    elseif pp == 2
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
%         OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
        OptimizeTypes(OPTIMIZE_3) = 1;
        OptimizeTypes(OPTIMIZE_4) = 1;
        OptimizeTypes(OPTIMIZE_2) = 1;
        OptimizeTypes(OPTIMIZE_9) = 1;
        % OptimizeTypes(OPTIMIZE_8) = 1;
        OptimizeTypes(OPTIMIZE_10) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE3) = 1;

       Label = sprintf('OP2_TEST_%s', ss)
    else
        OptimizeTypes = zeros(1, OPTIMIZE_ALL); % 优化类型
        OptimizeTypes(OPTIMIZE_7) = 1;
        OptimizeTypes(OPTIMIZE_1) = 1;
        OptimizeTypes(OPTIMIZE_3) = 1;
        OptimizeTypes(OPTIMIZE_4) = 1;
        OptimizeTypes(OPTIMIZE_2) = 1;
        OptimizeTypes(OPTIMIZE_8) = 1;
        OptimizeTypes(OPTIMIZE_9) = 1;
        OptimizeTypes(OPTIMIZE_10) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE1) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE2) = 1;
        % OptimizeTypes(OPTIMIZE_FIRE3) = 1;

        Label = sprintf('OP3_TEST_%s', ss)
    end

    
end

    

    