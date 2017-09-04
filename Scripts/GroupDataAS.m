%%
groupcell = cell(26,1) %{} index cells
groupcell{1} = load('ASsubj101_workspace') ;
groupcell{2} = load('ASsubj102_workspace') ;
groupcell{3} = load('ASsubj103_workspace') ;
groupcell{4} = load('ASsubj104_workspace') ;
groupcell{5} = load('ASsubj105_workspace') ;
groupcell{6} = load('ASsubj106_workspace') ;
groupcell{7} = load('ASsubj107_workspace') ;
groupcell{8} = load('ASsubj108_workspace') ;
groupcell{9} = load('ASsubj109_workspace') ;
groupcell{10} = load('ASsubj110_workspace') ;
groupcell{11} = load('ASsubj111_workspace') ;
groupcell{12} = load('ASsubj112_workspace') ;
groupcell{13} = load('ASsubj113_workspace') ;
groupcell{14} = load('ASsubj114_workspace') ;
groupcell{15} = load('ASsubj115_workspace') ;
groupcell{16} = load('ASsubj116_workspace') ;
groupcell{17} = load('ASsubj117_workspace') ;
groupcell{18} = load('ASsubj118_workspace') ;
groupcell{19} = load('ASsubj119_workspace') ;
groupcell{20} = load('ASsubj120_workspace') ;
groupcell{21} = load('ASsubj121_workspace') ;
groupcell{22} = load('ASsubj122_workspace') ;
groupcell{23} = load('ASsubj123_workspace') ;
groupcell{24} = load('ASsubj124_workspace') ;
groupcell{25} = load('ASsubj125_workspace') ;
groupcell{26} = load('ASsubj126_workspace') ;
%%
numSubjs = 26
% groupcell = groupcell([1:4 6 8:11]) %removes subjects who didn't learn
% for i = 1:length(groupcell)
%     groupcell{i} = segmat_func(groupcell{i});
% end

%% %REACTION TIMES ;
groupSELECT = nan(26,1);
for i=1:numSubjs
    groupSELECT(i,:) = (groupcell{i}.subjStruct.meanSelect);
end
meangroupSELECT = (groupcell{i}.subjStruct.meanSelect);
%%
groupEXECUTE = nan(26,1);
for i=1:numSubjs
    groupEXECUTE(i,:) = (groupcell{i}.subjStruct.meanExecute);
end
meangroupEXECUTE = mean(groupcell{i}.subjStruct.meanExecute)
%%
figure
medianplot = [meangroupSELECT meangroupEXECUTE];
c = categorical({'Select','Execute'});
bar(c,medianplot);
ylabel('Group Average Median RT (sec)')
%%
%% %ACCURACY
meanSAccuracy = mean(groupcell{i}.subjStruct.SelectAccuracy);
meanEAccuracy = mean(groupcell{i}.subjStruct.ExecuteAccuracy);

SAccuracy = (groupcell{i}.subjStruct.SelectAccuracy);
EAccuracy = (groupcell{i}.subjStruct.ExecuteAccuracy);
%%
figure
Accuracyplot = [meanSAccuracy meanEAccuracy];
c = categorical({'Select','Execute'});
bar(c,Accuracyplot);
ylabel('Group Accuracy')
%%
fileName = strcat('AS_Group','_workspace');
%%
save(fileName);