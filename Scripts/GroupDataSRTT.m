%%
groupcell = cell(26,1) %{} index cells
groupcell{1} = load('SRTTsubj101_workspace') ;
groupcell{2} = load('SRTTsubj102_workspace') ;
groupcell{3} = load('SRTTsubj103_workspace') ;
groupcell{4} = load('SRTTsubj104_workspace') ;
groupcell{5} = load('SRTTsubj105_workspace') ;
groupcell{6} = load('SRTTsubj106_workspace') ;
groupcell{7} = load('SRTTsubj107_workspace') ;
groupcell{8} = load('SRTTsubj108_workspace') ;
groupcell{9} = load('SRTTsubj109_workspace') ;
groupcell{10} = load('SRTTsubj110_workspace') ;
groupcell{11} = load('SRTTsubj111_workspace') ;
groupcell{12} = load('SRTTsubj112_workspace') ;
groupcell{13} = load('SRTTsubj113_workspace') ;
groupcell{14} = load('SRTTsubj114_workspace') ;
groupcell{15} = load('SRTTsubj115_workspace') ;
groupcell{16} = load('SRTTsubj116_workspace') ;
groupcell{17} = load('SRTTsubj117_workspace') ;
groupcell{18} = load('SRTTsubj118_workspace') ;
groupcell{19} = load('SRTTsubj119_workspace') ;
groupcell{20} = load('SRTTsubj120_workspace') ;
groupcell{21} = load('SRTTsubj121_workspace') ;
groupcell{22} = load('SRTTsubj122_workspace') ;
groupcell{23} = load('SRTTsubj123_workspace') ;
groupcell{24} = load('SRTTsubj124_workspace') ;
groupcell{25} = load('SRTTsubj125_workspace') ;
groupcell{26} = load('SRTTsubj126_workspace') ;
%%
numSubjs = 26
% groupcell = groupcell([1:4 6 8:11]) %removes subjects who didn't learn
% for i = 1:length(groupcell)
%     groupcell{i} = segmat_func(groupcell{i});
% end

%% %REACTION TIMES
%each subj median block RT
groupRTmat = nan(numSubjs,18) ;
for i=1:numSubjs
    groupRTmat(i,:) = groupcell{i}.filteredMedianRT ;
end
%% %Group seq and rand block averages
groupRandRT = mean(groupRTmat(:,[1 6 11 16 18]))
groupSeqRT = mean(groupRTmat(:,[2:5 7:10 12:15 17]))
%% %Each subj's average random RT
RAND = nan(26,5)
RAND = groupRTmat(:,[1 6 11 16 18])
RandMean = mean(RAND,2)
%%
SEQ = nan(26,13)
SEQ = groupRTmat(:,[2:5 7:10 12:15 17])

%%
figure
plot(mean(groupRTmat))
hold on; plot(groupRTmat','color',[0.75 0.75 1])
xlabel('Blocks')
ylabel('Mean RT')
%plots mean group RT darker, with individual's RT lighter behind 
%%
BlockType = cell(1,30)
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
figure('position',[0 0 1000 600]);
plot(mean(groupRTmat))
errorbar(1:18,mean(groupRTmat),std(groupRTmat)./sqrt(numSubjs),'b','linewidth',2)
hold on
plot(mean(groupRTmat),...
    'o','markerfacecolor','b','markeredgecolor','b','markersize',5,'linewidth',2) ;
formatFigAxis(gca,5,1:18,BlockType,0,[])
xlabel('Block Type')
ylabel('Mean RT (sec)')
%plots group RT with error bars
%Underfined BlockType
%%
earlyLearning = groupRTmat(:,1)-mean(groupRTmat(:,2:5),2) ;
middleLearning = groupRTmat(:,6)-mean(groupRTmat(:,[7:10]),2) ;
lateLearning = groupRTmat(:,11) -mean(groupRTmat(:,[12:15 17]),2) ;
%Takes random-seq to get measure of learning
%%
scatJitt(horzcat(earlyLearning,middleLearning,lateLearning),...
    [0 0 1; 1 0 0; 0 1 0],{'Early','Middle','Late'},0)
formatFigAxis(gca,3,1:3,{'Early','Middle','Late',},0,[])
ylabel('R-S (sec)')
%plots amount of learning (difference between R and S) at each stage of task
%%
% %% Chunking individual 
% figure; hold on
% chunk = groupcell{10}.poswRand
% plot(chunk)
% plot(median(chunk,2),'k-','linewidth',2)
%%
%% %ACCURACY
groupAccuracymat = nan(numSubjs,18) ;
for i=1:numSubjs
    groupAccuracymat(i,:) = groupcell{i}.subjStruct.accuracymean ;
end
%%
%%
figure
errorbar(1:18,mean(groupAccuracymat),std(groupAccuracymat)./sqrt(numSubjs))
hold on
plot(mean(groupAccuracymat),...
    'o','markerfacecolor','b','markeredgecolor','b','markersize',4) ;
ylabel('Accuracy')
xlabel('group block mean')
%%
%%

%% %Chunking %Spearman co
groupCorrMat = nan(18,18,numSubjs) ;
for i=1:numSubjs
    groupCorrMat(:,:,i) = groupcell{i}.subjStruct.RTcorrMat_wrand ;
end
%%
AvCorrMat = nan(18,18) ;
AvCorrMat = mean(groupCorrMat,3) ;
%% %corrcoef for group
figure
imagesc (AvCorrMat),colormap hot, colorbar
caxis([0 0.75])
ylabel('Chunk Similarity (r)')
% %% %for single person
%  figure
%  imagesc (groupcell{2}.subjStruct.RTcorrMat_wrand),colormap hot, colorbar
%  caxis([0 0.7])
%  ylabel('Chunk Similarity (r)')
%%
% %%  %Chunking 2 %ignore
% zgroupCorrMat = nan(30,30,numSubjs) ;
% for i=1:numSubjs
%     zgroupCorrMat(:,:,i) = groupcell{i}.subjStruct.RTcorrMat_wrandz ;
% end
% %%
% zAvCorrMat = nan(30,30) ;
% zAvCorrMat = mean(atanh(zgroupCorrMat),3) ;
% %%
% figure
% imagesc (zAvCorrMat),colormap hot, colorbar
% caxis([0 0.7])
% %Using Z values and incl Random
% %% %for single person
%  figure
%  imagesc (groupcell{1}.RTcorrMat_wrandz),colormap hot, colorbar
%  caxis([0 0.7])
%  ylabel('Chunk Similarity (r)')
%%
%CHUNKING AT EACH STAGE
%%
%EARLY LATE RANDOM (scatjit plot)
%%
ind = nchoosek([2:5 7:10],2);
groupChunkingEarly = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingEarly(i) = mean(temp);
end
%indexing the early seq blocks for each subject and calc mean
%%
ind = nchoosek([12:15 16],2);
groupChunkingLate = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingLate(i) = mean(temp);
end
%indexing the late seq trials for each subject and calc mean
%%
ind = nchoosek([1 6 11 16 18],2);
groupChunkingRandom = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingRandom(i) = mean(temp);
end
%% cannot get to work (how random was indexed for pilot data)
% clear ind
% ind(:,1) = repmat(15,29,1);
% ind(:,2) = [1:14 16:30];
% temp = repmat(28,29,1);
% temp(:,2) = [1:27 29:30];
% ind = vertcat(ind,temp);
% %Selecting the random blocks (15 and 28)
% %%
% groupChunkingRandom = zeros(numSubjs,1);
% for i = 1:numSubjs
%     temp = zgroupCorrMat(ind(:,1),ind(:,2),i);
%     temp = temp(:);
%     groupChunkingRandom(i) = mean(temp);
% end
% %Random mean for group
%%
groupChunking = horzcat(groupChunkingEarly,groupChunkingLate,groupChunkingRandom);
%%
scatJitt(groupChunking,[0 0 1; 1 0 0; 0 1 0],{'Early','Late','Random'},0)
formatFigAxis(gca,3,1:3,{'Early','Late','Random'},0,[])
ylabel('Chunk Similarity (r)')
%plots early, late and random chunking 
%%
%EARLY MIDDLE LATE RANDOM
ind = nchoosek(2:5,2);
groupChunkingEarly = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingEarly(i) = mean(temp);
end
%indexing the early seq blocks for each subject and calc mean
%%
ind = nchoosek(7:10,2);
groupChunkingMiddle = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingMiddle(i) = mean(temp);
end
%%
ind = nchoosek(12:15,2);
groupChunkingLate = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingLate(i) = mean(temp);
end
%indexing the late seq trials for each subject and calc mean
%%
ind = nchoosek([1 6 11 16 18],2);
groupChunkingRandom = zeros(numSubjs,1);
for i = 1:numSubjs
    temp = groupCorrMat(ind(:,1),ind(:,2),i);
    temp = temp(:);
    groupChunkingRandom(i) = mean(temp);
end
%Random mean for group
%%
groupChunking2 = horzcat(groupChunkingEarly,groupChunkingMiddle,groupChunkingLate,groupChunkingRandom);
%%
ee=std(groupChunkingEarly)
mm=std(groupChunkingMiddle)
ll=std(groupChunkingLate)
rr=std(groupChunkingRandom)
%%
EMLR = horzcat(ee,mm,ll,rr)
%% Plot Average E M L R corrcoef (Cannot get scatjit to work)
Type = cell(1,4)
Type{1} = 'Early';
Type{2} = 'Middle';
Type{3} = 'Late';
Type{4} = 'Random';
figure
x = [1:4]  
y = mean(groupChunking2)
sz = 50;
c = [0 0 1; 1 0 0; 0 1 0; 1 0 1];
scatter(x,y,sz,c,'filled')
set(gca,'xtick',1:4,'xticklabel',Type)
hold on
errorbar(x,y,EMLR,'.b','linewidth',1.2,'color',[0 0 0])
set(gca,'linewidth',2)
ylabel('Chunk Similarity (r)')
%%
%%
fileName = strcat('SRTT_Group','_workspace');
%%
save(fileName);