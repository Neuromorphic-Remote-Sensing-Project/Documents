function [EventsArrayPos,EventsArrayNeg,ValArray] = SpotEvents(Filename,NumCycles,EventsArrayPos,EventsArrayNeg,ValArray,Freq)
%Reads in a .mat file created by the function ReadEvents and extracts all
%the events that were recorded within the stimulus area defined by XY over a
%specified number of stimulus cycles.  Freq will be specified for a bandwidth
%measurement (i.e. filename contains XXXXHz.  For a threshold calculation 
%assume 1 Hz.

%Load file
load(Filename);

%If frequency not given, assume measurement is for a threshold calculations and set Freq to 1 Hz
if ~exist('Freq','var')
    Freq = 1;  %Hz
end

%Define EndTime as a function of the number of stimulus cycles desired
EndTime = NumCycles/Freq;
EndIdx = min(find(Events(:,3) > EndTime));

%Remove events beyond the desired number of cycles
Events = Events(1:EndIdx,:);        

%% Count events only within the desired stimulus area (XY)

%Iniitalize 2D data Arrays to store XY position of events
XYPos = zeros(240,180);
XYNeg = zeros(240,180);


%Count Number of type 1 and type 0 events at each pixel and place into XY
%positive and negative count arrays
for idx = 1:length(Events)
    x = Events(idx,1); y = Events(idx,2);
    if Events(idx,4) == 1
        XYPos(x,y) = XYPos(x,y) + 1;
    else
        XYNeg(x,y) = XYNeg(x,y) + 1;
    end
end


%% Extract number of positive and negative events that correspond to each pixel in stimulus area

%Initialize arrays for positive and negative events within stimulus area
%(spot)
SpotEventsPos = [];
SpotEventsNeg = [];

%Load array containing x and y addresses of pixels within stimulus area 
load('PixelCalibrationMatrix','XY')

%Place total events per pixel into array position corresponding to the 
%address contained in the XY array
for idx = 1:length(XY)
    SpotEventsPos = [SpotEventsPos;XYPos(XY(idx,2),XY(idx,1))];
    SpotEventsNeg = [SpotEventsNeg;XYNeg(XY(idx,2),XY(idx,1))];
end
 
%Normalize to events per stimulus cycle by dividing by number of cycles
SpotEventsPos = SpotEventsPos/NumCycles;
SpotEventsNeg = SpotEventsNeg/NumCycles;

%Build Events Arrays to pass as function output
EventsArrayPos = [EventsArrayPos,SpotEventsPos];
EventsArrayNeg = [EventsArrayNeg,SpotEventsNeg];

%% Update Value array with the value of Voltage or Frequency associated with the filename provided
if length(Filename) == 22
    Value = 0.001*str2double(Filename(15:17));
else
    Value = str2double(Filename(17:20));
end

%Update Value array
ValArray = [ValArray,Value]; 



