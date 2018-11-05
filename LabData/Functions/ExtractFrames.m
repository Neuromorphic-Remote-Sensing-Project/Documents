function ReadFrames = ExtractFrames(Filename)

%Extracts APS frames until endEvent parameter is met and returns a datacube
%containing only read frames (removes reset frames).

%Create a structure with which to pass in the input parameters.
input = struct;
input.filePath = Filename;
input.endEvent = 1e6;

% Invoke the function
output = ImportAedat(input);

FullDataCube = output.data.frame.samples;

%Determine if reset frames are odd or even
if output.data.frame.reset(1) == 1
    ReadFrames = FullDataCube(2:2:end);
else
    ReadFrames = FullDataCube(3:2:end);
end




end

