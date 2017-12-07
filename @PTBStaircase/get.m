% Mostly written by Björn Vlaskamp.  Modified by Robin held
function [uit s] = get(s,varargin)
% SET Set asset properties and return the updated object
propertyArgIn = varargin;
while length(propertyArgIn) >= 1,
	prop = propertyArgIn{1};
	propertyArgIn = propertyArgIn(2:end);
	switch prop
		case 'complete',
			uit = s.complete;
		case 'condition_num'
			uit = s. condition_num;
		case 'captureRate_num'
			uit = s. condition_num;
		case 'letterSize'
			uit = s. letterSize;
		case 'stimDistance',
			uit = s.stimDistance;
		case 'currentValue',
			if isempty(s.currentValue)
				disp('*********************************************')
				disp('You have not initialized this staircase')
				disp('Make sure that you have run the initializeStaircase routine')
				disp('*********************************************')
				uit =NaN;
			else
				uit = s.currentValue;
			end
		case 'altVariable'
			uit = s.altVariable;
		case 'values'
			uit = s.values;
		case 'responses'
			uit = s.responses;
		case 'reversalflag'
			uit = s.reversalflag;
		case 'currentReversals'
			uit = s.currentReversals;
		case 'presentation'
			uit = s.presentation;
		case 'flash'
			uit = s.flash;
		case 'dutyCycle'
			uit = s.dutyCycle;
		case 'protocol'
			uit = s.protocol;
		case 'eyeMovement'
			uit = s.eyeMovement;
		case 'contrast'
			uit = s.contrast;
		case 'refreshRate'
			uit = s.refreshRate;
		case 'resolution'
			uit = s.resolution;
		case 'viewingDistance'
			uit = s.viewingDistance;
		case 'framesPerCapture'
			uit = s.framesPerCapture;
		case 'initialized'
			uit = s.initialized;
		case 'straightrun'
			uit = s.straightrun;
		case 'monocular'
			uit = s.monocular; 
		case 'initialValue'
			uit = s.initialValue; 
		case 'stepSize'
			uit = s.stepSize;  
		case 'training'
			uit = s.training;
		case 'MCS'
			uit = s.MCS;    
		case 'MCS_num_stimuli'
			uit = s.MCS_num_stimuli;    
		case 'MCS_stimuli'
			uit = s.MCS_stimuli;    
		case 'MCS_num_responses'
			uit = s.MCS_num_responses; 
		case 'MCS_max_responses'
			uit = s.MCS_max_responses;      
        case 'subtype'
            uit = s.subtype;
        case 'rotationSpeed'
            uit = s.rotationSpeed;
        case 'color'
            uit = s.color;
        case 'greenRatio'
            uit = s.greenRatio;
        case 'rgbValues'
            uit = s.rgbValues;
        case 'blurWidth'
            uit = s.blurWidth;
        case 'barSpeed'
            uit = s.barSpeed;
        case 'barWidth'
            uit = s.barWidth;
        case 'captureSequence'
            uit = s.captureSequence;
        case 'disparity'
            uit = s.disparity;
        case 'crosstalk'
            uit = s.crosstalk;
        case 'stimColor'
            uit = s.stimColor;
        case 'bgColor'
            uit = s.bgColor;
	otherwise
	  error('Property does not exist')
	end
end
