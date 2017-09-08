%%
groupcell = cell(23,1) %{} index cells
groupcell{1} = load('TOJsubj101_workspace') ;
groupcell{2} = load('TOJsubj102_workspace') ;
groupcell{3} = load('TOJsubj103_workspace') ;
groupcell{4} = load('TOJsubj104_workspace') ;
groupcell{5} = load('TOJsubj105_workspace') ;
groupcell{6} = load('TOJsubj106_workspace') ;
groupcell{7} = load('TOJsubj107_workspace') ;
groupcell{8} = load('TOJsubj108_workspace') ;
groupcell{9} = load('TOJsubj109_workspace') ;
groupcell{10} = load('TOJsubj110_workspace') ;
groupcell{11} = load('TOJsubj111_workspace') ;
groupcell{12} = load('TOJsubj112_workspace') ;
groupcell{13} = load('TOJsubj113_workspace') ;
groupcell{14} = load('TOJsubj114_workspace') ;
groupcell{15} = load('TOJsubj115_workspace') ;
groupcell{16} = load('TOJsubj116_workspace') ;
groupcell{17} = load('TOJsubj117_workspace') ;
groupcell{18} = load('TOJsubj118_workspace') ;
groupcell{19} = load('TOJsubj119_workspace') ;
groupcell{20} = load('TOJsubj120_workspace') ;
groupcell{21} = load('TOJsubj121_workspace') ;
groupcell{22} = load('TOJsubj122_workspace') ;
groupcell{23} = load('TOJsubj123_workspace') ;
groupcell{24} = load('TOJsubj124_workspace') ;
groupcell{25} = load('TOJsubj125_workspace') ;
groupcell{26} = load('TOJsubj126_workspace') ;
%%
numSubjs = 26
%%
groupJND = nan(numSubjs,1) ;
for i=1:numSubjs ;
    groupJND(i,:) = groupcell{i}.subjModFitParams.JND;
end
%%
%%
groupThreshold = nan(numSubjs,2) ;
for i=1:numSubjs ;
    groupThreshold(i,:) = groupcell{i}.subjModFitParams.Threshold;
end
%%
groupr2 = nan(numSubjs,1)
for i=1:numSubjs ;
    groupr2(i,:) = groupcell{i}.A_fit.Rsquared.Adjusted
end
%%
fileName = strcat('TOJ_Group','_workspace');
%%
save(fileName);