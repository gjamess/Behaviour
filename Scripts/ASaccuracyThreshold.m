AccuracyThreshMat = accuracymean>0.8
%%
accuracymean = filterMat(accuracymean, AccuracyThreshMat)
%%
filteredMedianRT = filterMat(filteredMedianRT, AccuracyThreshMat)
%%
%%
SELECT = nanmean(filteredMedianRT(blkInd == 1))
EXECUTE = nanmean(filteredMedianRT(blkInd == 0))
%%
%Average median RT across block types
figure
medianplot = [SELECT EXECUTE];
c = categorical({'Select','Execute'});
bar(c,medianplot);
ylabel('Average Median RT (sec)')
%%
print(strcat('AS Mean Block Median plot',subjectNumber),'-dpng');
%%
%Action selection proficiency 
AS = (SELECT-EXECUTE)/(EXECUTE)
%%
SelectBlocksAccuracy = accuracymean(blkInd == 1);
ExecuteBlocksAccuracy = accuracymean(blkInd == 0);
%% 
SAccuracy = nanmean(accuracymean(blkInd == 1));
EAccuracy = nanmean(accuracymean(blkInd == 0));

figure
Accuracyplot = [SAccuracy EAccuracy];
c = categorical({'Select','Execute'});
bar(c,Accuracyplot);
ylabel('Accuracy')
%%
print(strcat('AS Accuracy plot',subjectNumber),'-dpng');
%%
%%
disp('++++');
disp(min(accuracymean))
disp('++++');
%%
subjStruct = struct;
subjStruct.subjNumber = subjectNumber;
subjStruct.BlockType = BlockType;
subjStruct.filteredMedianRT = filteredMedianRT;
subjStruct.meanExecute = EXECUTE;
subjStruct.meanSelect = SELECT;
subjStruct.SelectAccuracy = SAccuracy;
subjStruct.ExecuteAccuracy = EAccuracy;
subjStruct.AS = AS;
%%
fileName = strcat('AS','subj',subjectNumber,'_workspace');
fileName2 = strcat('subjStruct_',subjectNumber,'AS');
%%
save(fileName);
save(fileName2,'subjStruct');
%%