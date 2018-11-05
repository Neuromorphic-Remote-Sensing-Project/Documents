function [DN,St_Dev] = SpotDN(Filename,XY,Cutoff,ZeroMean,MaxDN)
%Takes a filename and XY array defining the pixels within the stimulus area
%and returns the an array containing the DN readout at the specified level
%for each pixel in the area.
%Filename must correspond to a .mat file which is the output of the function 
%readframes and contains Mean, Std, and Val.    

load(Filename,'Mean','Std','Val');     %Contains Mean, Std, and Val

%find max and min values  
xmax = max(XY(:,1));
xmin = min(XY(:,1));
ymax = max(XY(:,2));
ymin = min(XY(:,2));

%Convert Mean to DN
MeanDN = abs(Mean - ZeroMean);

%Compile 1 dimensional array containing DN (counts) and St Dev for each
%pixel in the defined area.
St_Dev = [];
DN = [];
for xidx = xmin:xmax
    for yidx = ymin:ymax
        if MaxDN(xidx,yidx) > Cutoff
            DN = [DN;MeanDN(xidx,yidx)];
            St_Dev = [St_Dev;Std(xidx,yidx)];
        end
    end 
end




end

