function a = formatFigAxis(a,NumTicks,xt,XTL,rot,ylimit)
xlimit = get(a,'XLim');

if isempty(xt) == 1 && isfloat(XTL) && length(XTL) < 2
    XL = get(a,'XLim');
    XT = linspace(XL(1),XL(end),XTL);
elseif isfloat(XTL) == 1 && isempty(xt) == 1
    XT = XTL;
elseif isfloat(xt) && isempty(XTL)
    XT = (linspace(xt(1),xt(2),NumTicks));
else
    XT = xt;
end
if isempty(ylimit)
YL = get(a,'YLim');
else
    YL = ylimit;
    set(a,'ylim',ylimit);
end

YT = linspace(YL(1),YL(2),NumTicks);
% if iscell(XTL) ~= 1
%     XTL = num2str(XT','%.2f');
% end

YTL = num2str(YT','%.2f');

if isempty(xt) ~= 1 && iscell(XTL) ~= 1 

%     set(a,'XTick',XT,'xticklabel',XTL,...
%     'YTick',YT,'yticklabel',YTL,...
%     'linewidth',3,'fontsize',18)
    XTL = num2str(XT','%.2f');
    set(a,'xlim',xt,'XTick',XT,'xticklabel',XTL,...
    'YTick',YT,'yticklabel',YTL,...
    'linewidth',3,'fontsize',18)
elseif isempty(xt) == 1 && isempty(XTL)

    set(a,'XTick',[],...
    'YTick',YT,'yticklabel',YTL,...
    'linewidth',3,'fontsize',18)
elseif isempty(xt) == 1 && isfloat(XTL) == 1

    set(a,'XTick',XT,'xticklabel',XT,...
    'YTick',YT,'yticklabel',YTL,...
    'linewidth',3,'fontsize',18)
else

    set(a,...
    'YTick',YT,'yticklabel',YTL,...
    'linewidth',3,'fontsize',18)
    if rot > 1
        xticklabel_rotate(xt,45,XTL,'fontsize',18)
    else
        set(a,...
            'XTick',xt,'xticklabel',XTL)
    end
    xlim([xlimit])
end
set(a,'box','off')
if rot >= 0
if min(YT) < 0 & max(YT) > 0 
    hold on
    plot(get(gca,'xlim'),[0 0],'-k','linewidth',3);
end
if min(XT) < 0 & max(XT) > 0 
    hold on
    plot([0 0],get(gca,'ylim'),'-k','linewidth',3);
end
end
