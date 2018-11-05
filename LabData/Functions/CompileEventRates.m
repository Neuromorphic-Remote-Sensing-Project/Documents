%Compiles data for DAVIS characterization and analysis
clear all 
close all 
clc

%% Load APS calibration matrix.  

%This file is the output of the function CalibrateAPS and contains arrays XY, XY_DN, and XYStd.
load('PixelCalibrationMatrix','XY','XY_DN','XYStd');


%% Load all data files for threshold calculations and determine events/cycle.

%Define and initialize inputs for SpotEvents
NumCycles = 30;
EventsPos = XY;
EventsNeg = XY;
Volts = [];

%Load first event data set 
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_075V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_080V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_085V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_090V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_095V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_100V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_105V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_110V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_115V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_120V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_125V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_130V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_135V.mat',NumCycles,EventsPos,EventsNeg,Volts);
[EventsPos,EventsNeg,Volts] = SpotEvents('TL5_IPL5_NDF0_140V.mat',NumCycles,EventsPos,EventsNeg,Volts);






%% Save EventsPos, EventsNeg and Volts

save('TL5_IPL5_NDF0_Threshold','EventsPos','EventsNeg','Volts')









% figure
% plot(Volts,EventsPos(1,3:end),Volts,EventsNeg(1,3:end));
% title('Probability of Detection vs. Signal Amplitude')
% ylabel('Events Per Cycle')
% xlabel('Signal Amplitude (V)')
% 
% figure
% plot(Volts,EventsNeg(1:10,3:end));
% title('Negative Events Per Cycle vs. Signal Amplitude')
% ylabel('Events Per Cycle')
% xlabel('Signal Amplitude (V)')
% 
% 
% 
% 


% %Initialize arrays for "turn-on" voltage and contrast threshold at each pixel
% VthPos = zeros(length(Events),1);
% ThetaPos = zeros(length(Events),1);
% VthPos = zeros(length(Events),1);
% ThetaPos = zeros(length(Events),1);






%[Vth,Theta,VoltsPrev,EventsPrev] = BinResponse(Events,Volts,EventsPrev,VoltsPrev,VthPos,ThetaPos,VthNeg,ThetaNeg)
V = [1.3,1.4,1.5,1.6,1.7,1.8,1.9,2,2.1,2.2];
Offset = 1.75;







%Determine which pixels are responding at stimulus voltage level
% for idx = 1:length(Events)
%     if Events(idx,3) > Cutoff*NumCycles 
%         if VthPos(idx) == 0
%             VthPos(idx) = Volts;
%             
%             
%             HighCounts = interp1(V,XY_DN(idx,3:end),Offset+Voltage,'spline'); 
%             LowCounts = interp1(V,XY_DN(idx,3:end),Offset-Voltage,'spline');
%             ThetaPos(idx) = log(HighCounts/LowCounts);
%         end
%     end
%     if Events(idx,4) > Cutoff*NumCycles
%         
%         
%         
%         
%         
% end



% EV80 = SpotEvents('TL5_IPL5_NDF0_080V.mat',NumCycles);
% EV85 = SpotEvents('TL5_IPL5_NDF0_085V.mat',NumCycles);
% EV90 = SpotEvents('TL5_IPL5_NDF0_090V.mat',NumCycles);
% EV95 = SpotEvents('TL5_IPL5_NDF0_095V.mat',NumCycles);
% EV100 = SpotEvents('TL5_IPL5_NDF0_100V.mat',NumCycles);
% EV105 = SpotEvents('TL5_IPL5_NDF0_105V.mat',NumCycles);
% EV110 = SpotEvents('TL5_IPL5_NDF0_110V.mat',NumCycles);
% EV115 = SpotEvents('TL5_IPL5_NDF0_115V.mat',NumCycles);
% EV120 = SpotEvents('TL5_IPL5_NDF0_120V.mat',NumCycles);
% EV125 = SpotEvents('TL5_IPL5_NDF0_125V.mat',NumCycles);
% EV130 = SpotEvents('TL5_IPL5_NDF0_130V.mat',NumCycles);
% EV135 = SpotEvents('TL5_IPL5_NDF0_135V.mat',NumCycles);
% EV140 = SpotEvents('TL5_IPL5_NDF0_140V.mat',NumCycles);


%Bin each pixel according to it's "Turn On" value.  This corresponds to the
%point at which a pixel generates XX% of the expected number of events 







