%Compile LED Data
clear all
close all
clc

Events = [];
[LEDWindow,NumPixels] = FindLEDWindow('SlowNom1kHz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom1Hz.aedat',1,LEDWindow),1];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom3.3Hz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom3.3Hz.aedat',3.3,LEDWindow),3.33];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom10Hz.aedat',.3);
Events = [Events;FindEventsPerCycle('SlowNom10Hz.aedat',10,LEDWindow),10];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom33Hz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom33Hz.aedat',33,LEDWindow),33.3];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom100Hz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom100Hz.aedat',100,LEDWindow),100];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom330Hz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom330Hz.aedat',333,LEDWindow),333];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom1kHz.aedat',.5);
Events = [Events;FindEventsPerCycle('SlowNom1kHz.aedat',1000,LEDWindow),1000];
%[LEDWindow,NumPixels] = FindLEDWindow('NomNom3.3kHz.aedat',.5);
%[LEDWindow,NumPixels] = FindLEDWindow(' NomNom5kHz.aedat',.5);
%Events = [Events;FindEventsPerCycle('FastNom5kHz.aedat',5000,LEDWindow),5000];
%Events = [Events;FindEventsPerCycle('SlowNom10kHz.aedat',10000,LEDWindow),10000];




figure 
hold on
plot(log10(Events(:,5)),log10(Events(:,3)),'b-*')  %On events per cycle per pixel
plot(log10(Events(:,5)),log10(Events(:,4)),'r-*')  %Off events per cycle per pixel