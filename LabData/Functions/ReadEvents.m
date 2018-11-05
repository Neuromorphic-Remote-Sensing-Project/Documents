function Events = ReadEvents(FileName)
%Imports aedat file containing up to 1e7 events and converts to a single
%4xN array with x, y, timestamp, and polarity

%Import NumCycles from jAER datafile
input.filePath = FileName;
EventsToImport = 1e7;
%input.endEvent = EventsToImport;
%input.dataTypes = {'polarity'};

output = ImportAedat(input);


%Convert AER data into single array with double floating point precision
%except Polarity which is a logical
X = double(output.data.polarity.x) + 1;     %Add 1 to correct indexing
Y = double(output.data.polarity.y) + 1;     %Add 1 to correct indexing
t = double(output.data.polarity.timeStamp);
P = output.data.polarity.polarity;
t = (t-t(1))/1e6;

Events = [X,Y,t,P];

save(FileName(1:end-6),'Events');
 
end
 
