%%
subjectNumber = '126' ; %set for each subject
% import variables
%%
%A C E I M N 
[BlockType,ResponseRq,BlocksthisTrialN,...
trialsthisTrialN,Respcorr,Resprt] = ...
explicitTaskImport(...
'126_Seq_explicitJitter_2017_Aug_14_1736.csv'...
);

%%
blockNumber = BlocksthisTrialN + 1 ; % adding 1 because of python (which starts at 0)
trialN = trialsthisTrialN + 1 ; 
%%
trialRTMat = nan(max(trialN),max(blockNumber)); %creating empty matrix of nan of trials x blocks
accuracyMat = nan(max(trialN),max(blockNumber)); %EmptyMatrix = nan(rows,columns)
%%
% %(Resolves issue where Respcorr = 0 for all)
% respcorr = nan(1152,1)
% for i = 1:1152
%    if Respkeys(i,:) == ResponseRq(i,:)
%       respcorr(i,1) = 1 ;
%    else respcorr(i,1) = 0
%    end
% end
% Respcorr = respcorr
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
minmaxMat = trialRTMat<0.8 & trialRTMat>0.1;
%%
filtRTMat = filterMat(trialRTMat,accuracyMat);
%%
filteredRTMat = filterMat(trialRTMat,minmaxMat);
%%
blockmeanRT = nanmean(trialRTMat);
accuracymean = nanmean(accuracyMat);
filteredMeanRT = nanmean(filteredRTMat);
filteredMedianRT = nanmedian(filteredRTMat);
IQR = iqr(filteredRTMat);

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
%% %Plot Median Block RT Learning Curve
figure
hold on
plot ([filteredMedianRT],'-*');
set(gca,'XTick',1:18,'XTickLabel',BlockType);
xlabel('Block Type')
ylabel('Filtered Median RT')
%%
print(strcat('SRTT Block Median Learning Curve',subjectNumber),'-dpng');
%%
%% %Plot Mean Block RT Learning Curve
figure
hold on
plot ([filteredMeanRT],'-*');
set(gca,'XTick',1:18,'XTickLabel',BlockType);
xlabel('Block Type')
ylabel('Filtered Mean RT')
%%
%Learning metric
%% Last 2 R blocks - Last 2 S blocks
Learning = mean(filteredMedianRT(:,[16 18]))-...
    mean(filteredMedianRT(:,[15 17]))
%% All R blocks - Last 5 S blocks
Learning2 = mean(filteredMedianRT(:,[1 6 11 16 18]))-...
    mean(filteredMedianRT(:,[12:15 17]))
%% Comparison of above
figure
bar([Learning, Learning2])
%% Random Blocks
RandBlocks = filteredMedianRT(:,[1 6 11 16 18]);
figure
plot(RandBlocks,'-*')
set(gca,'XTick',1:5);
%% Sequence Blocks
SeqBlocks = filteredMedianRT(:,[2:5 7:10 12:15 17]);
figure
plot(SeqBlocks,'-*')
set(gca,'XTick',1:13);
%% Exponential fit to sequence
SeqFit = coeffvalues(createFit(SeqBlocks))
xlabel ('Sequence Blocks')
%%
%% %Plot Block Accuracy
figure
plot (accuracymean)
set(gca,'XTick',1:18,'XTickLabel',BlockType);
xlabel('Block Type')
ylabel('Mean Block Accuracy')
%%
print(strcat('SRTT Mean Block Accuracy',subjectNumber),'-dpng');
%% %Blockslope
blockslope = nan(1,18); %create an empty matrix of 1 by 30 (for each block)
for i = 1:18 
    goodInds = isnan(filteredRTMat(:,i)) == 0; 
    X = 1:64;
    newX = X(goodInds); %NaNs now removed
    RTs = filteredRTMat(goodInds,i);
   [p] = polyfit(newX(:),RTs,1); %polyfit(x,y,n)

    blockslope(i) = p(1); %put into matrix, so for i, return p(1)
end
figure
plot (blockslope);
set(gca,'XTick',1:18,'XTickLabel',BlockType);
xlabel('Block Type')
ylabel('BlockSlope')
%%
print(strcat('SRTT Blockslope',subjectNumber),'-dpng');
%%
%CHUNKING
%% Excluding RANDOM blocks
%Sequence matrix composed of the filteredRTMat, but only for the non-random
%blocks (not 1,6,11, 16,18)
%seqmat = filteredRTMat(:,[2:5 7:10 12:15 17]); 

%%
%posRTMat = nan(16,13); %Empty matrix for all 16 positions in the sequence
%for each block
%for i = 1:13 %blocks
%for j = 1:16 %position in sequence
    %posRTMat(j,i)=nanmean(seqmat([j:16:64],i)) ;
    %if isnan(posRTMat(j,i))
        %disp ([i j])
    %end
%end
%end
%posRTMat(isnan(posRTMat)) = 0;
%1:16:64 counts from 1 to 64 in intervals of 16
%substitute 1 for j so that a mean RT is calculated for every position in
%sequence, for each block, found in seqmat
%%
%Includes Random blocks
poswRand = nan(16,18);
for i = 1:18
for j = 1:16
    poswRand(j,i)=nanmedian(filteredRTMat([j:16:64],i)) ;
end
end  
poswRand(isnan(poswRand)) = 0;
%%
%figure
%RTcorrMat = corrcoef(posRTMat);
%imagesc (RTcorrMat),colormap jet, colorbar

%corrcoef(A) returns the matrix of correlation coefficients for A, where
%the columns of A (blocks) are random variables and the rows (seq position)
%represent observations
%%
figure
RTcorrMat_wrand = corrcoef(poswRand);
imagesc (RTcorrMat_wrand), colormap hot, colorbar
set(gca,'xtick',1:18,'xticklabel',BlockType)
set(gca,'ytick',1:18,'yticklabel',BlockType)
caxis([0 .75])
ylabel('Chunk Similarity (r)')
%%
print(strcat('SRTT Chunking Matrix',subjectNumber),'-dpng');
%%
%% Each item in sequence RT across each block
figure
plot(poswRand')
%%
%Early Late Random Chunking
%%
%ind = nchoosek([2:5 6:9],2);
%for i = 1
%    temp = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
%    temp = temp(:);
%    ChunkingEarly(i) = mean(temp);
%end
%%
%ind = nchoosek([12:15 17],2);
%for i = 1
%    temp = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
%    temp = temp(:);
%    ChunkingLate(i) = mean(temp);
%end
%%
%ind = nchoosek([1 6 11 16 18],2);
%for i = 1
%    temp = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
%    temp = temp(:);
%    ChunkingRandom(i) = mean(temp);
%end

%%
%Chunking = horzcat(ChunkingEarly,ChunkingLate,ChunkingRandom);
%% %plots early, late and random chunking
%scatJitt(Chunking,[0 0 1; 1 0 0; 0 1 0],{'Middle','Late','Random'},0)
%formatFigAxis(gca,3,1:3,{'Middle','Late','Random'},0,[])
%ylabel('Chunk Similarity (r)')
%%
%Early Middle Late Random Chunking
%% EARLY
ind = nchoosek([2:5],2);
for i = 1
    E = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
    E = E(:);
    Chunkingearly(i) = mean(E);
end
%% MIDDLE
ind = nchoosek([7:10],2);
for i = 1
    M = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
    M = M(:);
    Chunkingmiddle(i) = mean(M);
end
%% LATE
ind = nchoosek([12:15 17],2);
for i = 1
    L = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
    L = L(:);
    Chunkinglate(i) = mean(L);
end
%% RANDOM
ind = nchoosek([1 6 11 16 18],2);
for i = 1
    R = RTcorrMat_wrand(ind(:,1),ind(:,2),i);
    R = R(:);
    Chunkingrandom(i) = mean(R);
end
%%
Chunking2 = horzcat(Chunkingearly,Chunkingmiddle,Chunkinglate,Chunkingrandom);
%%
ee=std(E)
mm=std(M)
ll=std(L)
rr=std(R)
%%
EMLR = horzcat(ee,mm,ll,rr)
%% Plot Average E M L R corrcoef 
Type = cell(1,4)
Type{1} = 'Early';
Type{2} = 'Middle';
Type{3} = 'Late';
Type{4} = 'Random';
figure
x = [1:4]  
y = Chunking2
sz = 50;
c = [0 0 1; 1 0 0; 0 1 0; 1 0 1];
scatter(x,y,sz,c,'filled')
set(gca,'xtick',1:4,'xticklabel',Type)
hold on
errorbar(x,y,EMLR,'.b','linewidth',1.2,'color',[0 0 0])
set(gca,'linewidth',2)
ylabel('Chunk Similarity (r)')
%%
print(strcat('SRTT Chunking Matrix',subjectNumber),'-dpng');
%%
%%Compare the difference of each block with the previous block, and each
%%block with the rest of the blocks excluding the prev block
%% NOT FINISHED
for i= 2:18
    hm = RTcorrMat_wrand(:,i) - RTcorrMat_wrand(:,i-1)
end
%%
%%
subjStruct = struct;
subjStruct.subjNumber = subjectNumber;
subjStruct.blockmeanRT = blockmeanRT;
subjStruct.accuracymean = accuracymean;
subjStruct.filteredMeanRT = filteredMeanRT;
subjStruct.blockslope = blockslope;
subjStruct.RTcorrMat_wrand = RTcorrMat_wrand
%%
fileName = strcat('SRTT','subj',subjectNumber,'_workspace');
fileName2 = strcat('subjStruct_',subjectNumber,'SRTT');
%%
save(fileName);
save(fileName2,'subjStruct');
%%
%%
%%END HERE