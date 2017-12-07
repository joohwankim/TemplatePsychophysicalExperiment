% below initializes 1 staircase cell
s=PTBStaircase;

% system parameters
system.pixelVisualAngle=1; % minarc, assuming 3H viewing
system.frameRate=120; % 60 frames/s
param.frameRate=system.frameRate;
param.pixelVisualAngle=system.pixelVisualAngle;

% experimental parameters
param.stim.brightness=[25 80 250];
param.stim.letterHeight=[37 74]; % letter height in pixel (37 is the size of interest)
param.stim.simulatedPixelSize = [1 2 3 4 5 6 7 8 10 12 16]; % simulated pixel size in pixel (2 means 2 x 2 pixel block is treated as one pixel)
param.stim.stimColor=[255 255 255];
param.stim.duration=1; % in sec
% staircase setting
param.scell.initialValueRandomRange=15; % in gray level
param.scell.initialValue=5;
param.scell.initialStepSize=2;
param.scell.minValue=1;
param.scell.maxValue=11;
param.scell.maxReversals=40;
param.scell.maxTrials=100;
param.scell.stepLimit=1;
param.scell.numUp=1;
param.scell.numDown=2;

scellTemplate = set(s,...
    'initialValue',param.scell.initialValue,...
    'initialValue_random_range',param.scell.initialValueRandomRange,...
    'stepSize',param.scell.initialStepSize,...
    'minValue',param.scell.minValue,...
    'maxValue',param.scell.maxValue,...
    'maxReversals',param.scell.maxReversals,...
    'maximumtrials',param.scell.maxTrials,...
    'stepLimit',param.scell.stepLimit,...
    'numUp',param.scell.numUp,...
    'numDown',param.scell.numDown,...
	'initialized','no');

conditions = struct();
conditionIndex = 0;
for brightness_i=1:length(param.stim.brightness)
    for letterCase_i = 1:length(param.stim.letterCase)
        conditionIndex = conditionIndex + 1;
        conditions(conditionIndex).brightness = param.stim.brightness(brightness_i);
        conditions(conditionIndex).letterCase = param.stim.letterCase{letterCase_i};
        scell{brightness_i,letterCase_i}=set(scellTemplate,'condition_num',conditionIndex);
        scell{brightness_i,letterCase_i}=initializeStaircase(scell{brightness_i,letterCase_i});
    end
end