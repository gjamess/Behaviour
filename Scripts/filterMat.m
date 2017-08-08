function outMat = filterMat(inMat,Filter);
%% filters bad RTs out of inMat
%
outMat = nan(size(inMat)); % create output variable same size as inMat
outMat(Filter == 1) = inMat(Filter == 1); % Put values that satisfy filter into the output Matrix
