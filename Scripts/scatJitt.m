function f = scatJitt(inMat,clrVec,Labels,F);
%%
sz = size(inMat);
if F ~= 2
        ms = 40;
    else
        ms = 70;
end
if isfloat(inMat) == 1
    [mMat(1,:),mMat(2,:)] = getGroupMeanSEM(inMat,1);
    scatClr = rgb2hsv(clrVec);
    scatClr(:,2) = scatClr(:,2)./5;
    scatClr = hsv2rgb(scatClr);
    
    if F == 0
        f = figure('position',[500 500 110*sz(2) 500]);
    end
    hold on

    for i = 1:sz(2)
        scatter(repmat(i,[sz(1) 1])+0.1-randi(100,[sz(1),1])./700,...
            inMat(:,i),ms,scatClr(i,:),'o','linewidth',2)
        
        line([i-0.1 i+0.1],[mMat(1,i)+mMat(2,i) mMat(1,i)+mMat(2,i)],'linewidth',3,'color',clrVec(i,:))
        line([i-0.1 i+0.1],[mMat(1,i)-mMat(2,i) mMat(1,i)-mMat(2,i)],'linewidth',3,'color',clrVec(i,:))
        line([i-0.15, i+0.15],[mMat(1,i) mMat(1,i)],'linewidth',3','color',clrVec(i,:))
        line([i i],[mMat(1,i)-mMat(2,i) mMat(1,i)+mMat(2,i)],'linewidth',3','color',clrVec(i,:))
    end
    if isempty(Labels) == 0

        xx = get(gca,'xlim');
        set(gca,'xtick',1:sz(2),'xticklabels',Labels,'xlim',[0.5 xx(2)],...
            'fontsize',16)

    end
else
    for i = 1:sz(2)
        [mMat(1,i),mMat(2,i)] = getGroupMeanSEM(inMat{i},1);
    end
    
    scatClr = rgb2hsv(clrVec);
    scatClr(:,2) = scatClr(:,2)./5;
    scatClr = hsv2rgb(scatClr);
    
    if F == 0
        f = figure('position',[500 500 110*sz(2) 500]);
    end
    hold on

    for i = 1:sz(2)
        scatter(repmat(i,[size(inMat{i},1) 1])+0.1-randi(100,[size(inMat{i},1),1])./700,...
            inMat{i}(:),ms,scatClr(i,:),'o','linewidth',2)
        
       
        line([i-0.1 i+0.1],[mMat(1,i)+mMat(2,i) mMat(1,i)+mMat(2,i)],'linewidth',3,'color',clrVec(i,:))
        line([i-0.1 i+0.1],[mMat(1,i)-mMat(2,i) mMat(1,i)-mMat(2,i)],'linewidth',3,'color',clrVec(i,:))
        line([i-0.15, i+0.15],[mMat(1,i) mMat(1,i)],'linewidth',3','color',clrVec(i,:))
        line([i i],[mMat(1,i)-mMat(2,i) mMat(1,i)+mMat(2,i)],'linewidth',3','color',clrVec(i,:))
    end
    if isempty(Labels) == 0

        xx = get(gca,'xlim');
        set(gca,'xtick',1:sz(2),'xticklabels',Labels,'xlim',[0.5 xx(2)],...
            'fontsize',16)

    end
    
end
