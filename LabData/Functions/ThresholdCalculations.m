clear all 
close all
clc

%Load calibration matrices and event matrices
load('PixelCalibrationMatrix','XY','XY_DN','XYStd');
load('TL5_IPL5_NDF0_Threshold','EventsPos','EventsNeg','Volts')

%Calculate maximum and minimum voltages associated with each collection sample
Vmax = 1.75 + Volts'; % voltage sample at each diode setting for measurements
Vmin = 1.75 - Volts';

%Convert each voltage level to equivalent DN corresponding to each pixel
V_DN = 1.3:0.1:2.2; % calibration voltage settings [1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2];
DNMax = [];
DNMin = [];
for idx = 1:length(XY) % calibrate measured data using calibration curve y=mx+b
    DNMax = [DNMax;spline(V_DN,XY_DN(idx,3:end),Vmax')];
    DNMin = [DNMin;spline(V_DN,XY_DN(idx,3:end),Vmin')];
end

%Calculate Threshold corresponding to signal amplitude for each pixel
Threshold = log(DNMax./DNMin);

%Plot events per cycle vs. calculated threshold value (for sampled signal amplitude) at 5 random pixels
n = randi(225,5);
figure
plot(Threshold(n(1),:),EventsPos(n(1),3:end),Threshold(n(1),:),EventsNeg(n(1),3:end))
xlabel('Calibrated log(Max/Min) counts for V_p_i_x '); ylabel('Normalized Event Rate ( #Events/#Cycles)');
legend('Pos Events','Neg Events');

%
 figure;
 idx = [100, 150,200]; hold on; grid on;
%  plot(Threshold(idx,:)',EventsPos(idx,3:end)','b')
%  plot(Threshold(idx,:)',EventsNeg(idx,3:end)','r')
 plot(Volts',EventsPos(idx,3:end)','b')
 plot(Volts',EventsNeg(idx,3:end)','r')
 legend('Pos Events','Neg Events');

figure
plot(Threshold(n(2),:),EventsPos(n(2),3:end),Threshold(n(2),:),EventsNeg(n(2),3:end))
xlabel('Calibrated log(Max/Min) counts for V_p_i_x '); ylabel('Normalized Event Rate ( #Events/#Cycles)');
legend('Pos Events','Neg Events');

figure
plot(Threshold(n(3),:),EventsPos(n(3),3:end),Threshold(n(3),:),EventsNeg(n(3),3:end))
xlabel('Calibrated log(Max/Min) counts for V_p_i_x '); ylabel('Normalized Event Rate ( #Events/#Cycles)');
legend('Pos Events','Neg Events');

figure
plot(Threshold(n(4),:),EventsPos(n(4),3:end),Threshold(n(4),:),EventsNeg(n(4),3:end))
xlabel('Calibrated log(Max/Min) counts for V_p_i_x '); ylabel('Normalized Event Rate ( #Events/#Cycles)');
legend('Pos Events','Neg Events');

figure
plot(Threshold(n(5),:),EventsPos(n(5),3:end),Threshold(n(5),:),EventsNeg(n(5),3:end))
xlabel('Calibrated log(Max/Min) counts for V_p_i_x '); ylabel('Normalized Event Rate ( #Events/#Cycles)');
legend('Pos Events','Neg Events');


%% Determine how quickly each pixel responds as the signal amplitude increases.
% Signal amplitude is expressed in units of log(DNMax/DNMin) to correspond
% to theoritical pixel operation

%Use interp1 to determine threshold values corresponding to 10% and 90% 
%Probability of detection for each pixel
Pos10 = [zeros(length(XY),1),5*ones(length(XY),1)];     %Will hold value and position of pixel at first measurement that exceed 10% positive event rate
Neg10 = [zeros(length(XY),1),5*ones(length(XY),1)];     %"----------------------------------------------------negative---------"
Pos90 = [zeros(length(XY),1),5*ones(length(XY),1)];     %"------------------------------------------------90% positive---------"
Neg90 = [zeros(length(XY),1),5*ones(length(XY),1)];     %"------------------------------------------------90% negative---------"

%Strip X and Y addresses from EventsPos and EventsNeg arrays
EventsPos = EventsPos(:,3:end);
EventsNeg = EventsNeg(:,3:end);

%Determine the threshold value and event rate (events/cycle) at the first
%measurement to exceed 10% and 90% of the expected event rate for each type
%of event
for idx = 1:length(XY)
    
    for  idx2 = 1:length(EventsPos(1,:))
         if EventsPos(idx,idx2) > 0.10
             Pos10(idx,:) = [EventsPos(idx,idx2),Threshold(idx,idx2)];
         break
         end
    end
    
    for  idx2 = 1:length(EventsPos(1,:))
         if EventsNeg(idx,idx2) > 0.10
             Neg10(idx,:) = [EventsNeg(idx,idx2),Threshold(idx,idx2)];
         break
         end
    end
    
    for  idx2 = 1:length(EventsPos(1,:))
        if EventsPos(idx,idx2) > 0.90
            Pos90(idx,:) = [EventsPos(idx,idx2),Threshold(idx,idx2)];
        break
        end
    end
    
    for  idx2 = 1:length(EventsPos(1,:))
         if EventsNeg(idx,idx2) > 0.90
             Neg90(idx,:) = [EventsNeg(idx,idx2),Threshold(idx,idx2)];
         break
         end
    end
end


%Calculate a slope between the measured "threshold" (log(I2/I1)) and the resulting
%event rates by looking at the two points calculated above.  Units of the slope
%value are in Event Rate (%) per unit threshold change (delta(log(I2/I1)).
SlopePos = (Pos90(:,1) - Pos10(:,1))./(Pos90(:,2) - Pos10(:,2));
SlopeNeg = (Neg90(:,1) - Neg10(:,1))./(Neg90(:,2) - Neg10(:,2));

%Remove pixels that did not achieve an event rate of 90% or greater 
SlopePos(SlopePos < 0) = [];
SlopeNeg(SlopeNeg < 0) = [];

%Examine Histograms containing event rate per unit threshold
figure
hist(SlopePos,50);
xlabel('Rate of change between 10% and 90% positive event rate (per unit threshold)')
ylabel('Number of Pixels')
figure
hist(SlopeNeg,50);
xlabel('Rate of change between 10% and 90% negative event rate (per unit threshold)')
ylabel('Number of Pixels')



%% Determine threshold level where each pixel detects 90% of events (90% Probability of Detection)

%Create empty arrays to hold the event rate and threshold of the first
%measurement that exceeds 90% and the last measurement prior to meeting the
%90% threshold for each pixel in the array
FirstTo90Pos = [zeros(length(XY),1),5*ones(length(XY),1)];
FirstTo90Neg = [zeros(length(XY),1),5*ones(length(XY),1)];
LastBelow90Pos = [zeros(length(XY),1),5*ones(length(XY),1)];
LastBelow90Neg = [zeros(length(XY),1),5*ones(length(XY),1)];

%Fill the arrays
for idx = 1:length(XY)
    for  idx2 = 1:length(EventsPos(1,:))
         if EventsPos(idx,idx2) > 0.90
            FirstTo90Pos(idx,:) = [EventsPos(idx,idx2),Threshold(idx,idx2)];
            LastBelow90Pos(idx,:) = [EventsPos(idx,idx2-1),Threshold(idx,idx2-1)];
            break
         end
    end
    
    for  idx2 = 1:length(EventsPos(1,:))
         if EventsNeg(idx,idx2) > 0.90
            FirstTo90Neg(idx,:) = [EventsNeg(idx,idx2),Threshold(idx,idx2)];
            LastBelow90Neg(idx,:) = [EventsNeg(idx,idx2-1),Threshold(idx,idx2-1)];
            break
         end
    end
end

%Calculate the rate of change between FirstTo90 and LastBelow90 for each
%pixel
SlopePos90 = (FirstTo90Pos(:,1) - LastBelow90Pos(:,1))./(FirstTo90Pos(:,2) - LastBelow90Pos(:,2));
SlopeNeg90 = (FirstTo90Neg(:,1) - LastBelow90Neg(:,1))./(FirstTo90Neg(:,2) - LastBelow90Neg(:,2));

%Use slopes to interpolate and determine the threshold where each pixel should have
%crossed 90%
Thresh90Pos = (0.9 - LastBelow90Pos(:,1))./SlopePos90 + LastBelow90Pos(:,2);
Thresh90Neg = (0.9 - LastBelow90Neg(:,1))./SlopeNeg90 + LastBelow90Neg(:,2);

%Remove pixels that did not exceed 90%
Thresh90Pos = Thresh90Pos(~isnan(Thresh90Pos));
Thresh90Neg = Thresh90Neg(~isnan(Thresh90Neg));


%Examine Histograms containing 90% threshold for each pixel
figure
hist(Thresh90Pos,20);
xlabel('Threshold for 90% Probability Detect for Positive Events')
ylabel('Number of Pixels')
figure
hist(Thresh90Neg,20);
xlabel('Threshold for 90% Probability Detect for Negative Events')
ylabel('Number of Pixels')

%Report numbe of pixels not in range
PixelsNotInRange = length(XY) - length(SlopePos)


%% Determine if there is a relationship between when a pixel achieves 90% probability detect and rate of response

figure
plot(Thresh90Pos,SlopePos,'o');
xlabel('90% Threshold Value')
ylabel('Rate of Response (Event Rate per change in illumination)')
figure
plot(Thresh90Neg,SlopeNeg,'o');
xlabel('90% Threshold Value')
ylabel('Rate of Response (Event Rate per change in illumination)')






