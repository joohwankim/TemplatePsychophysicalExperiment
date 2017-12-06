% below initializes 1 staircase cell
s=PTBStaircase;

% system parameters
system.pixelVisualAngle=1; % minarc, assuming 3H viewing
system.frameRate=120; % 60 frames/s
param.frameRate=system.frameRate;
param.pixelVisualAngle=system.pixelVisualAngle;

% stim type definition
% 1: simultaneous presentation of two depth planes ( with vs without xtalk)
% 2: alternate presentation of two depth planes (with vs without xtalk)
param.stim.type=2;

if param.stim.type==1 % simultaneous presentation of two depth planes ( with vs without xtalk)
    % experimental parameters
    param.scell.initialValueRandomRange=15; % in gray level
    param.scell.initialValue=20;
    param.scell.initialStepSize=16;
    param.scell.minValue=-4;
    param.scell.maxValue=48;
    param.scell.maxReversals=20;
    param.scell.maxTrials=50;
    param.scell.stepLimit=1;
    param.scell.numUp=1;
    param.scell.numDown=1;
    % rendering related parameters
    param.stim.dotSpacingH=50;
    param.stim.dotSpacingV=20;
    param.stim.dotDiameter=24; % in pixels
    param.stim.width=300; % param window width
    param.stim.height=100; % param window height
    param.stim.separation=80;
    param.stim.borderLineWidth=3;
    param.stim.borderLineDisparity=5;
    param.stim.maximumDisparity=-param.scell.minValue;
    param.fixationCross.size=20;
    param.fixationCross.lineWidth=2;
    param.stim.duration=1; % in sec
elseif param.stim.type==2 % alternate presentation of two depth planes ( with vs without xtalk)
    % experimental parameters
    param.scell.initialValueRandomRange=15; % in gray level
    param.scell.initialValue=20;
    param.scell.initialStepSize=32;
    param.scell.minValue=-10;
    param.scell.maxValue=48;
    param.scell.maxReversals=20;
    param.scell.maxTrials=50;
    param.scell.stepLimit=4;
    param.scell.numUp=1;
    param.scell.numDown=1;
    % rendering related parameters
    param.stim.dotSpacingH=16;
    param.stim.dotSpacingV=16;
    param.stim.dotDiameter=2; % in pixels
    param.stim.width=320; % param window width
    param.stim.height=400; % param window height
    param.stim.maskingTime=0.5; % time between the first and the second depth planes
    param.stim.borderLineWidth=0; % 0 means no border line
    param.stim.borderLineDisparity=0; % no border line!
    param.stim.maximumDisparity=param.scell.maxValue;
    param.fixationCross.size=50;
    param.fixationCross.lineWidth=1;
    param.stim.duration=0.2; % in sec
end

% param.stim.crosstalk=[0 0.01 0.02 0.04 0.08 0.16 0.32];
% param.stim.disparity=[4 8 12 16 24 32];
param.stim.crosstalk=[0.16 0.32];
param.stim.disparity=[4 8 12 16 24 32];
param.stim.stimColor{1}=[255 255 255];
param.stim.bgColor{1}=[0 0 0];
% param.stim.stimColor{2}=[0 0 0];
% param.stim.bgColor{2}=[255 255 255];

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
for crosstalk_i=1:length(param.stim.crosstalk)
    for disparity_i=1:length(param.stim.disparity)
        conditionIndex = conditionIndex + 1;
        conditions(conditionIndex).crosstalk = param.stim.crosstalk(crosstalk_i);
        conditions(conditionIndex).disparity
        scell{crosstalk_i,disparity_i}=set(scellTemplate,...
            'crosstalk',param.stim.crosstalk(crosstalk_i),...
            'disparity',param.stim.disparity(disparity_i),...
        scell{crosstalk_i,disparity_i}=...
            initializeStaircase(scell{crosstalk_i,disparity_i});
    end
end