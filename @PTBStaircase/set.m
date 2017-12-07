% Mostly written by Bjorn Vlaskamp
function a = mystaircaseset(a,varargin)
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'initialValue'
            a.initialValue = val;
        case 'condition_num'
            a.condition_num = val;
		case 'captureRate_num'
			a.captureRate_num = val;
		case 'letterSize'
			a.letterSize = val;
        case 'stepSize';
            a.stepSize = val;
        case 'tGuessSd'
			a.tGuessSd = val; 
        case 'maxReversals'
			a.maxReversals = val; 
        case 'maximumtrials'
            a.maximumtrials = val;
        case 'currentReversals'
			a.currentReversals = val; 
        case 'lastDirection'
			a.lastDirection = val;   
        case 'stimDistance'
			a.stimDistance = val;   
        case 'complete'
			a.complete = val;  
        case 'responses'
			a.responses = val;  
        case 'values'
            a.values = val;
        case 'stepLimit'
            a.stepLimit = val;
        case 'maxValue'
            a.maxValue = val; 
        case 'minValue'
            a.minValue = val; 
        case 'altVariable'
            a.altVariable = val;  
        case 'numUp'
            a.numUp = val;
        case 'numDown'
            a.numDown = val; 
        case 'initialValue_random_range'
            a.initialValue_random_range =val;
        case 'stim_order'
            a.stim_order=val;
		case 'presentation'
			a.presentation=val;
		case 'flash'
			a.flash=val;
		case 'dutyCycle'
			a.dutyCycle=val;
		case 'protocol'
			a.protocol=val;
		case 'eyeMovement'
			a.eyeMovement=val;
		case 'contrast'
			a.contrast=val;
		case 'refreshRate'
			a.refreshRate=val;
		case 'resolution'
			a.resolution=val;
		case 'viewingDistance'
			a.viewingDistance=val;
		case 'framesPerCapture'
			a.framesPerCapture=val;
		case 'initialized'
			a.initialized=val;
        case 'straightrun'
            a.straightrun=val;
        case 'monocular'
            a.monocular=val;    
        case 'training'
            a.training=val;        
        case 'MCS'
            a.MCS=val;    
        case 'MCS_num_stimuli'
            a.MCS_num_stimuli=val;    
        case 'MCS_stimuli'
            a.MCS_stimuli=val;    
        case 'MCS_num_responses'
            a.MCS_num_responses=val; 
        case 'MCS_max_responses'
            a.MCS_max_responses=val;
        case 'subtype'
            a.subtype=val;
        case 'rotationSpeed'
            a.rotationSpeed=val;
        case 'color'
            a.color=val;
        case 'greenRatio'
            a.greenRatio=val;
        case 'rgbValues'
            a.rgbValues=val;
        case 'blurWidth'
            a.blurWidth=val;
        case 'barSpeed'
            a.barSpeed=val;
        case 'barWidth'
            a.barWidth=val;
        case 'captureSequence'
            a.captureSequence=val;
        case 'disparity'
            a.disparity=val;
        case 'crosstalk'
            a.crosstalk=val;
        case 'stimColor'
            a.stimColor=val;
        case 'bgColor'
            a.bgColor=val;
        otherwise
        if ischar(prop),
            error(['Property ' prop ' does not exist in this class!'])
        else
            disp('Property: ')
            disp(prop)
            error('Property does not exist in this class!')
        end
    end
end
