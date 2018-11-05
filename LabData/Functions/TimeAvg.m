function [Mean,Std] = TimeAvg(DataCube)
%Takes a datacube and outputs the time average and std deviation at each
%pixel

Mean = mean(DataCube,3);
Std = std(DataCube,1,3);


end

