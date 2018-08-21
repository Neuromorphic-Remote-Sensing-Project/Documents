function  [LEDWindow,NumPixels] = FindLEDWindow(FileName,Cutoff)
%Imports 100Hz collection file and returns pixel array containing the x and
%y addresses of each pixel within the diameter.  Takes the filename and the
%desired cutoff expressed as a percentage of the peak number of events
%experienced by the "center" pixel


%Import first 100,000 events from jAER datafile
input.filePath = FileName;
input.endEvent = 1e5;
output = ImportAedat(input);

%Convert AER data into single array with double floating point precision
%except Polarity which is a logical
X = double(output.data.polarity.x)+1; %Adds 1 to correct indexing
Y = double(output.data.polarity.y)+1; %Adds 1 to correct indexing
t = double(output.data.polarity.timeStamp); 
P = output.data.polarity.polarity;
t = (t-t(1))/1e6; %Starts timescale at 0 and converts from usec to seconds
AER = [X,Y,t,P];


%Iniitalize 2D data Arrays to store XY position of events
XYPosTot = [zeros(128)];

%Count Number of type 1 and type 0 events in first x events and place into
%XY position array
for ii = 1:length(X)
    x = X(ii); y = Y(ii);
    XYPosTot(x,y) = XYPosTot(x,y) + 1;
end


%Initialize array to store addresses of pixels within LED perimeter
PixAddress = [];

%Include only pixels that experience at least Cutoff% of the peak number of
%events for each type and report the pixel address
peakTot = max(XYPosTot(:));
for ix = 1:128
    for iy = 1:128
        if XYPosTot(ix,iy) >= Cutoff*peakTot
            PixAddress = [PixAddress;ix,iy];
        end
    end 
end


LEDWindow = PixAddress;
NumPixels = length(LEDWindow);



% XYPosClean = zeros(size(XYPosTot,2));
% for ii = 1:length(PixAddress)
%     x = PixAddress(ii,1); y = PixAddress(ii,2);
%     XYPosClean(x,y) = XYPosTot(x,y);
% end

% 
% s=surf(XYPosClean)
% s.EdgeColor = 'none'
% title('Total Events')


end

