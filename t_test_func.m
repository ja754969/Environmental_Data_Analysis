function [test_statistic,t_095] = t_test_func(data1,data2)

    [h,p,ci,stats] = ttest2(data1,data2,'Alpha',0.05,'Tail','both','Vartype','equal','Dim',1);
    test_statistic = stats.tstat;
%     if test_statistic>0
%         t_095 = ci(1);
%     elseif test_statistic<0
%         t_095 = ci(2);
%     end
    t_095 = ci
end