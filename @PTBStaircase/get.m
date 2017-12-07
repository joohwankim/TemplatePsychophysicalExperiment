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
		case 'initialized'
			uit = s.initialized;
		case 'straightrun'
			uit = s.straightrun;
		case 'initialValue'
			uit = s.initialValue; 
		case 'stepSize'
			uit = s.stepSize;  
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
	otherwise
	  error('Property does not exist')
	end
end
