function XYClean = CheckWindow(FileName,LEDWindow)
%Plots the input data under the window constraint
%   Detailed explanation goes here

%Import first 100,000 events from jAER datafile
input.filePath = FileName;
input.endEvent = 1e5;
output = ImportAedat(input);

%Convert AER data into single array with double floating point precision
%except Polarity which is a logical
X = double(output.data.polarity.x)+1;
Y = double(output.data.polarity.y)+1;
t = double(output.data.polarity.timeStamp);
P = output.data.polarity.polarity;
t = (t-t(1))/1e6;


%Iniitalize 2D data Arrays to store XY position of events
XYPosTot = [zeros(128)];
XYPos1 = [zeros(128)];
XYPos0 = [zeros(128)];


%Count Number of type 1 and type 0 events in first x events and place into
%XY position array
for ii = 1:length(X)
    x = X(ii); y = Y(ii);
    XYPosTot(x,y) = XYPosTot(x,y) + 1;
    if P(ii) == 1
        XYPos1(x,y) = XYPos1(x,y) + 1;
    else
        XYPos1(x,y) = XYPos1(x,y) + 1;
    end
end


XYClean = [zeros(128)];
for ii = 1:length(LEDWindow)
    x = LEDWindow(ii,1); y = LEDWindow(ii,2);
    XYClean(x,y) = XYPosTot(x,y);
end


s=surf(XYClean)
s.EdgeColor = 'none'
title('Total Events')


end

