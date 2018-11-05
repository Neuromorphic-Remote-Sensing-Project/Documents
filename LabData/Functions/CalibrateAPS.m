function [XY,XY_DN,XYStd] = CalibrateAPS

%Calibrates APS readout to function generator signal voltage for each pixel
%in output array XY.  Requires 0,130,140...210,220.mat files, which are the
%outputs of the function ReadFrames('XXX.aedat') that contain the parameters
%Mean, Std, and Val.

%% Step 1: Import zero signal mean and standard deviation at each pixel and
%save as ZeroMean, ZeroStd and ZeroV
load('0.mat','Mean','Std','Val');
ZeroMean = Mean; ZeroStd = Std; ZeroV = Val;

%% Step 2:  Import DC signal frames and extract uniform LED spot size pixels 
%FileNames correspond to DC voltage of signal

%Import Frames Corresponding to Max signal
load('220.mat');
MaxMean = Mean; MaxStd = Std; MaxV = Val;

%Convert Max Value Signal to DN
MaxDN = abs(MaxMean - ZeroMean);

%Extract LED spot by using a 95% max value cutoff
XY = [];
Cutoff = 0.95*max(MaxDN(:));
for xidx = 1:180
    for yidx = 1:240
        if MaxDN(xidx,yidx) > Cutoff
            XY = [XY;xidx,yidx];
        end
    end
end


%Load and convert each collection sample to DN
[DN130,Std130] = SpotDN('130.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN140,Std140] = SpotDN('140.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN150,Std150] = SpotDN('150.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN160,Std160] = SpotDN('160.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN170,Std170] = SpotDN('170.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN180,Std180] = SpotDN('180.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN190,Std190] = SpotDN('190.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN200,Std200] = SpotDN('200.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN210,Std210] = SpotDN('210.mat',XY,Cutoff,ZeroMean,MaxDN);
[DN220,Std220] = SpotDN('220.mat',XY,Cutoff,ZeroMean,MaxDN);

%Place all values into array containing XY address and signal level for each
%collection sample
XY_DN = [XY,DN130,DN140,DN150,DN160,DN170,DN180,DN190,DN200,DN210,DN220];
XYStd = [XY,Std130,Std140,Std150,Std160,Std170,Std180,Std190,Std200,Std210,Std220];


%% Plot characteristic response for all pixels from min to max signal
PixDN = XY_DN(:,3:end);
V = [1.3,1.4,1.5,1.6,1.7,1.8,1.9,2,2.1,2.2];
plot(V,PixDN)
xlabel('Signal Voltage (V)')
ylabel('Counts (DN)')

figure
loglog(V,XYStd(:,3:end));
xlabel('Log Signal (DN)')
ylabel('Log Noise (DN)')




%% Step 3:  Save XY_DN array 

save('PixelCalibrationMatrix','XY','XY_DN','XYStd')



end