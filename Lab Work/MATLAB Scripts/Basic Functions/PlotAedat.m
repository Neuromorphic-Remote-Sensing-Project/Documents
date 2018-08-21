function PlotAedat(input, numPlots, distributeBy)

% This function calls the 'Plot...' function for each of the support event
% types

if ~exist('numPlots', 'var')
	numPlots = 3;
end

if ~exist('distributeBy', 'var')
	distributeBy = 'time';
end

if isfield(input.data, 'special')
	PlotSpecial(input); % This function displays all special events
end
if isfield(input.data, 'polarity')
	PlotPolarity(input, numPlots, distributeBy);
end
if isfield(input.data, 'frame')
	PlotFrame(input, numPlots, distributeBy);
end
if isfield(input.data, 'imu6')
	PlotImu6(input, numPlots, distributeBy);
end
if isfield(input.data, 'sample')
	PlotSample(input, numPlots, distributeBy);
end
if isfield(input.data, 'ear')
	PlotEar(input, numPlots, distributeBy);
end
if isfield(input.data, 'point1D')
	PlotPoint1D(input, numPlots, distributeBy);
end
if isfield(input.data, 'point2D')
	PlotPoint2D(input, numPlots, distributeBy);
end


