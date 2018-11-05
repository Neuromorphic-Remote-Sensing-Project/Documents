%Compiles data for DAVIS characterization and analysis
clear all 
close all 
clc

%Load APS calibration matrix.  This file is the output of the function
%CalibrateAPS and contains arrays XY, XY_DN, and XYStd.
load('PixelCalibrationMatrix','XY','XY_DN','XYStd');



