%%
subjectNumber = '103' ; %set for each subject
% import variables
%%
%A C E I M N 
[BlockType,ResponseRq,BlocksthisTrialN,...
trialsthisTrialN,Respcorr,Resprt] = ...
explicitTaskImport(...
'103_Seq_explicitJitter_2017_Jul_20_1812.csv'...
);

%%
blockNumber = BlocksthisTrialN + 1 ; % adding 1 because of python (which starts at 0)
trialN = trialsthisTrialN + 1 ; 
%%
trialRTMat = nan(max(trialN),max(blockNumber)); %creating empty matrix of nan of trials x blocks
accuracyMat = nan(max(trialN),max(blockNumber)); %EmptyMatrix = nan(rows,columns)
%%
%(Resolves issue where Respcorr = 0 for all)
%respcorr = nan(1152,1)
%for i = 1:1152
    %if Respkeys(i,:) == ResponseRq(i,:)
    %respcorr(i,1) = 1 ;
    %else respcorr(i,1) = 0
    %end
%end
%Respcorr = respcorr
%%

for i = 1:max(blockNumber) %sets i to equal numbers 1 through 15
    disp(i) % displays i
    ind = blockNumber == i; % finds where block number=i
    temp = Resprt(ind); %puts this into temp variable
    trialRTMat(:,i) = temp; %RT for each block now in 15 x 30matrix
    accuracyMat(:,i) = Respcorr(blockNumber == i); %Creates accuracy matrix using above 
    respRqMat(:,i) = ResponseRq(ind);
end
%%
filteredRTMat = filterMat(trialRTMat,accuracyMat);
%%
blockmeanRT = nanmean(trialRTMat);
accuracymean = nanmean(accuracyMat);
filteredMeanRT = nanmean(filteredRTMat);
filteredMedianRT = nanmedian(filteredRTMat);
%%
BlockType = cell(1,18)
BlockType{1} = 'R';
BlockType{2} = 'S';
BlockType{3} = 'S';
BlockType{4} = 'S';
BlockType{5} = 'S';
BlockType{6} = 'R';
BlockType{7} = 'S';
BlockType{8} = 'S';
BlockType{9} = 'S';
BlockType{10} = 'S';
BlockType{11} = 'R';
BlockType{12} = 'S';
BlockType{13} = 'S';
BlockType{14} = 'S';
BlockType{15} = 'S';
BlockType{16} = 'R';
BlockType{17} = 'S';
BlockType{18} = 'R';
%%
figure
hold on
plot ([filteredMeanRT],'-*');
set(gca,'XTick',1:18,'XTickLabel',BlockType);
xlabel('Block Type')
ylabel('Filtered Mean RT')
%%
%%
blockslope = nan(1,18); %create an empty matrix of 1 by 30 (for each block)
for i = 1:18 
    goodInds = isnan(filteredRTMat(:,i)) == 0; 
    X = 1:64;
    newX = X(goodInds); %NaNs now removed
    RTs = filteredRTMat(goodInds,i);
   [p] = polyfit(newX(:),RTs,1); %polyfit(x,y,n)

    blockslope(i) = p(1); %put into matrix, so for i, return p(1)
end
%%
%Sequence matrix composed of the filteredRTMat, but only for the non-random
%blocks (not 1, 15, 28)
seqmat = filteredRTMat(:,[2:5 7:10 12:15 17]); 

%%
posRTMat = nan(16,13); %Empty matrix for all 16 positions in the sequence
%for each block
for i = 1:13 %blocks
for j = 1:16 %position in sequence
    posRTMat(j,i)=nanmean(seqmat([j:16:64],i)) ;
    if isnan(posRTMat(j,i))
        disp ([i j])
    end
end
end
posRTMat(isnan(posRTMat)) = 0;
%1:16:64 counts from 1 to 64 in intervals of 16
%substitute 1 for j so that a mean RT is calculated for every position in
%sequence, for each block, found in seqmat
%%
%Same but includes the random blocks also
poswRand = nan(16,18);
for i = 1:18
for j = 1:16
    poswRand(j,i)=nanmean(filteredRTMat([j:16:64],i)) ;
end
end  
poswRand(isnan(poswRand)) = 0;
%%
figure
RTcorrMat = corrcoef(posRTMat);
imagesc (RTcorrMat),colormap jet, colorbar
%corrcoef(A) returns the matrix of correlation coefficients for A, where
%the columns of A (blocks) are random variables and the rows (seq position)
%represent observations
%%
figure
RTcorrMat_wrand = corrcoef(poswRand);
imagesc (RTcorrMat_wrand), colorbar
set(gca,'xtick',1:18,'xticklabel',BlockType)
set(gca,'ytick',1:18,'yticklabel',BlockType)
caxis([0 0.75])
ylabel('Chunk Similarity (r)')
%%
subjStruct = struct;
subjStruct.subjNumber = subjectNumber;
subjStruct.blockmeanRT = blockmeanRT;
subjStruct.accuracymean = accuracymean;
subjStruct.filteredMeanRT = filteredMeanRT;
subjStruct.blockslope = blockslope;
subjStruct.RTcorrMat = RTcorrMat
subjStruct.RTcorrMat_wrand = RTcorrMat_wrand
%%
fileName = strcat('subj',subjectNumber,'_workspace');
fileName2 = strcat('subjStruct_',subjectNumber);
%%
save(fileName);
save(fileName2,'subjStruct');
%%
%%
%%END HERE
