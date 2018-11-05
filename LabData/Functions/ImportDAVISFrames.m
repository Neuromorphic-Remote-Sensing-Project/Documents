% Example script for how to invoke the importAedat function

clearvars
dbstop if error

% Create a structure with which to pass in the input parameters.
input = struct;
input.filePath = 'LED1.3V.aedat';
input.fileFormat = 3;
input.endEvent = 2e6;


% Invoke the function
output = ImportAedat(input);

%Compile Frames with LED on
% F1 = output.data.frame.samples{45,1};
% F2 = output.data.frame.samples{47,1};
% F3 = output.data.frame.samples{49,1};
% F4 = output.data.frame.samples{51,1};
% F5 = output.data.frame.samples{53,1};
% F6 = output.data.frame.samples{55,1};
% F7 = output.data.frame.samples{57,1};
% F8 = output.data.frame.samples{59,1};


%Extract LED spot
%[x,y] = find(F1 < 60);
    



