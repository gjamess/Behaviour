%%
%Importing Data
%A C H J K L
%A Categorical -->String
%Output as Column Vectors
%%
subjectNumber = '126';
%%
filename = '126_ActionSelection_2017_Aug_14_1722.csv';
%%
%Importing file
[blocktype,blockloopthisTrialN,trialsthisN,trialRespkeys,trialRespcorr,trialResprt] = AS_Import(filename);
%%
blockNumber = blockloopthisTrialN + 1 ; % adding 1 because of python (which starts at 0)
trialN = trialsthisN + 1 ; 
%%
trialRTMat = nan(max(trialN),max(blockNumber)); %creating empty matrix of nan of trials x blocks
accuracyMat = nan(max(trialN),max(blockNumber)); %EmptyMatrix = nan(rows,columns)
 
%%

for i = 1:6 %sets i to equal numbers 1 through 6 (no. blocks)
    disp(i) % displays i
    ind = blockNumber == i; % finds where block number=i
    temp = trialResprt(ind); %puts this into temp variable
    trialRTMat(:,i) = temp; %RT for each block now in 6 x 48 matrix
    accuracyMat(:,i) = trialRespcorr(blockNumber == i); %Creates accuracy matrix using above 
end
%%
minmaxMat = trialRTMat< 0.8; %filter extreme values
%%
filtRTMat = filterMat(trialRTMat,accuracyMat);
filteredRTMat = filterMat(filtRTMat,minmaxMat);
%%
%%
blockmeanRT = nanmean(trialRTMat);
accuracymean = nanmean(accuracyMat);
filteredMeanRT = nanmean(filteredRTMat); 
filteredMedianRT = nanmedian(filteredRTMat);
std = nanstd(filteredRTMat);
%%
BlockType = nan(6,1);
blkInd = nan(6,1);
for i = blocktype([1:48:288]); %Counts in 48 (no. trials) 
   BlockType=(i); %Finds if blocktype is E or S for each block
end
   %%
for i = 1:6
    blkInd(i) = strcmp(BlockType{i},'S'); %compares strings, 1 if true
end
%%
SELECT = mean(filteredMedianRT(blkInd == 1));
EXECUTE = mean(filteredMedianRT(blkInd == 0));
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
figure
plot(filteredMedianRT)
%errorbar(filteredMedianRT,stdev)
%ylim([0 1.5])
set(gca,'XTick',1:6,'XTickLabel',BlockType) ;
ylabel('Median RT (sec)')
xlabel('Block Type')
%%
print(strcat('AS Block Median RTs',subjectNumber),'-dpng');
%%
%MEAN
figure
plot(filteredMeanRT)
set(gca,'XTick',1:6,'XTickLabel',BlockType) ;
ylabel('Mean RT (sec)')
xlabel('Block Type')
%%
print(strcat('AS Block Mean RTs',subjectNumber),'-dpng');
%%
%Action selection proficiency 
AS = (SELECT-EXECUTE)/(EXECUTE)
%% %Accuracy Plot
figure
plot([accuracymean],'-*','linewidth',2) ;
set(gca,'XTick',1:6,'XTickLabel',BlockType) ;
set(gca,'linewidth',2) ;
ylabel('Block Accuracy') ;
xlabel('Block Type') ;
%%
SAccuracy = mean(accuracymean(blkInd == 1));
EAccuracy = mean(accuracymean(blkInd == 0));

figure
Accuracyplot = [SAccuracy EAccuracy];
c = categorical({'Select','Execute'});
bar(c,Accuracyplot);
ylabel('Accuracy')
%%
print(strcat('AS Accuracy plot',subjectNumber),'-dpng');
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