function Events = FindEventsPerCycle(FileName,Freq,LEDWindow)
%Imports aedat file, windows down the FOV to ignore events outside the LED
%perimeter and returns the number of events per cycle and events per cycle 
%per pixel within the desired spatial range.  Requires filename, frequency
%of the strobe generating the signal, and Array of Pixels within LED frame.
%PixAddress will correspond to FindLEDWindow('(Bias Setting)_100Hz.aedat')

%Import first 100,000 events from jAER datafile
input.filePath = FileName;
input.endEvent = 1e5;
output = ImportAedat(input);

%Convert AER data into single array with double floating point precision
%except Polarity which is a logical
X = double(output.data.polarity.x);
Y = double(output.data.polarity.y);
t = double(output.data.polarity.timeStamp);
P = output.data.polarity.polarity;
t = (t-t(1))/1e6;


%Initialize arrays for positive, negative and total events
XYPosTot = [zeros(128)];
XYPos1 = [zeros(128)];
XYPos0 = [zeros(128)];

%Count Number of type 1 and type 0 events in first x events and place into
%XY position array
for ii = 1:length(X)
    x = X(ii)+1; y = Y(ii)+1;
    XYPosTot(x,y) = XYPosTot(x,y) + 1;
    if P(ii) == 1
        XYPos1(x,y) = XYPos1(x,y) + 1;
    else
        XYPos0(x,y) = XYPos0(x,y) + 1;
    end
end


XYClean1 = [zeros(128)];
XYClean0 = [zeros(128)];
XYClean = [zeros(128)];


for ii = 1:length(LEDWindow)
    x = LEDWindow(ii,1); y = LEDWindow(ii,2);
    XYClean(x,y) = XYPosTot(x,y);
    XYClean1(x,y) = XYPos1(x,y);
    XYClean0(x,y) = XYPos0(x,y);
end

s=surf(XYClean)
s.EdgeColor = 'none'
title('Total Events')


PosEvents = sum(XYClean1(:));
NegEvents = sum(XYClean0(:));


timeElapsed = t(1e5) - t(1); %sec
NumCycles = Freq*timeElapsed; %No Units
PosEventsPerCycle = PosEvents/NumCycles; 
NegEventsPerCycle = NegEvents/NumCycles;
Pixels = length(LEDWindow);
PosPerPixel = PosEventsPerCycle/Pixels;
NegPerPixel = NegEventsPerCycle/Pixels;


Events = [PosEventsPerCycle,NegEventsPerCycle,PosPerPixel,NegPerPixel];


end

