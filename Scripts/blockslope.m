figure('position',[0 0 800 400])
hold on
for i = 1:30 %there are 30 blocks of 64 trials. Set i as numbers 1 to 30
    Xstart = [64*(i-1)+2]; %makes a space of 1 along x between the plots of each block
    Xs = Xstart:Xstart+63; %the xs are the 64 RT for each block
%plot(filteredRTMat)
plot([Xs],filteredRTMat(:,i)) %Each block is plotted one after another (30 lines with 64 RTs) (rather than 30 lines with x 1-64)
end

%%
blockslope = nan(1,30); %create an empty matrix of 1 by 30 (for each block)
for i = 1:30 
    goodInds = isnan(filteredRTMat(:,i)) == 0; 
    X = 1:64;
    newX = X(goodInds); %NaNs now removed
    RTs = filteredRTMat(goodInds,i);
   [p] = polyfit(newX(:),RTs,1); %polyfit(x,y,n)

    blockslope(i) = p(1); %put into matrix, so for i, return p(1)
end
%filtered RT has NaN is cells where there is no data
%There is no function for nanpolyfit
%0 = false and 1 = true
%isnan(A) returns array same size as A containing logical 1 (true) where
%the elements of A are NaN and logical 0 (false) where they are not 
%p = [B(slope) intercept) - p = [1 2]
%%
figure
plot (blockslope)
%Shows the slope of RT across blocks