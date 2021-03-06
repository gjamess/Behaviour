subjectNumber = '126'
%%
%Import data (H J K L M, column vectors, L = Text, gen func)
%filename = strcat(subjectNumber,'1*_2.csv');
filename = '1261_2017_Aug_14_1754_2_trialout.csv'
%%
%Importing file
%[driver_offset,order,rt,FootPress,correct] = TOJImport(filename)
%%
%Importing file 2 
%Column vectors, acc --> text, drop down headers)
[trailNum,stimOffset,rt,acc,correct] = TOJImport2(filename)
%%
%Importing file 2
order=trailNum 
driver_offset=stimOffset
FootPress=acc
%% %for subj101 since footpedals were reversed
%driver_offset = driver_offset*-1
%%
[C, ~,indC]  = unique(driver_offset);
%C = unique driver offsets
%IndC = what driver offset each trial was
%%
%Proportion of R first presses for eac h unique(1:14) driver offset
%(FootPress = acc)
propRFoot = nan(size(C)); 
for j = 1:length(C)
 
    temp = FootPress(indC== j); %temp = the footpress for where indC == j(so for each unique offset)

    out = nan(size(temp));

%%
   for i = 1:length(temp)
    out(i) = strcmp(temp{i},'r'); % When r its 1
   end

    propRFoot(j) = sum(out)/length(out);
end
%%
figure
plot(propRFoot,'o')
%%
sigfunc = @(A, x)( 1 ./ (1 + exp(-1.*(x-A(1))./A(2))));
A0 = [1 1];
%%
C
%x2 = linspace(C,C,14);
A_fit = fitnlm(C,propRFoot, sigfunc, A0);
%%
xs = linspace(min(C),max(C),1000);
predY =sigfunc(A_fit.Coefficients.Estimate,xs);
%%
figure
hold on
plot(C,propRFoot,'o','linewidth',2)
plot(xs,predY,'linewidth',2)
set(gca,'linewidth',2)
xlabel('Interval');
ylabel('Proportion of R first responses');
%%
print(strcat('TOJ',subjectNumber),'-dpng');
%%
%%
subjModFitParams = struct
subjModFitParams.Rsquared = A_fit.Rsquared;
subjModFitParams.Coefs = A_fit.Coefficients.Estimate;
try 
    
subjModFitParams.Threshold = [interp1(predY,xs,.25) interp1(predY,xs,.75)];
catch
    [vs,inds] = unique(predY,'stable');
    xsS = xs(inds);
subjModFitParams.Threshold = [interp1(vs,xsS,.25) interp1(vs,xsS,.75)];
end
subjModFitParams.Slope = subjModFitParams.Coefs(2);
subjModFitParams.JND = sum(abs(subjModFitParams.Threshold))/2;
subjModFitParams.propRFootResponses = propRFoot;
%%
fileName = strcat('TOJ','subj',subjectNumber,'_workspace');
save (fileName);
%% !!!!!
fileName2 = strcat('subjModFitParams',subjectNumber,'TOJ');
save(fileName2,'subjModFitParams');
%%