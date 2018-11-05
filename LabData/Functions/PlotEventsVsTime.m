function PixelEvents = PlotEventsVsTime(Filename,XPos,YPos,NumCycles,Freq,Bias)
%Plots events vs time for a specific pixel.  

load(Filename,'Events')

%Define EndTime as a function of the number of stimulus cycles desired
EndTime = NumCycles/Freq;
EndIdx = min(find(Events(:,3) > EndTime));

%Remove events beyond the desired number of cycles
Events = Events(1:EndIdx,:);  

%Extract only events that correspond to the specified pixel (XPos,YPos)
X = Events(:,2); Y = Events(:,1); t = Events(:,3); P = Events(:,4);
PixelEvents = [];
for idx = 1:length(X)
    if X(idx) == XPos && Y(idx) == YPos
        PixelEvents = [PixelEvents;X(idx),Y(idx),t(idx),P(idx)];
    end
end

%Plot events
plot(PixelEvents(:,3),PixelEvents(:,4)+Bias,'-*')
% ylim([-0.2,1.2])

end