function [Mean,Std,Voltage] = ReadFrames(Filename)

%Extracts APS frames until endEvent parameter is met and returns a datacube
%containing only read frames (removes reset frames).

%Create a structure with which to pass in the input parameters.
input = struct;
input.filePath = Filename;
input.endEvent = 1e7;

% Invoke the function
output = ImportAedat(input);

FullDataSet = output.data.frame.samples;

%Remove reset frames 
Frames =[];
for idx = 1:length(FullDataSet)
    if output.data.frame.reset(idx) == 0
        Frames = [Frames,FullDataSet(idx)];
    end
end


%Put cells into data cube
DataCube = uint16.empty([180,240,0]);
for idx = 1:length(Frames)
    if size(Frames{1,idx}) == [180,240]
        DataCube = cat(3,DataCube,Frames{1,idx});
    end
end


%Convert to double and calculate time averaged Mean, Std and Voltage of
%measurement
DataCube = double(DataCube);
Mean = mean(DataCube,3);
Std = std(DataCube,1,3);
Voltage = 0.01*str2num(Filename(1:end-6));

save(Filename(1:end-6),'Mean','Std','Voltage');

end


