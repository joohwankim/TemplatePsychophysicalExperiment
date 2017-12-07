% Part of PTBStaircase set.  Does NOT belong in the ~PTBStaircase
% directory.
% Robin Held 
% Banks Lab
% UC Berkeley

% Input a cell composed of staircases and randomly select one that has not
% been completed.  If all have been completed, return 0.

function [scell] = initializeStaircase(scell)
    

	if scell.MCS==1
		scell.MCS_num_stimuli=length(scell.MCS_stimuli);
		scell.MCS_num_responses=zeros(1,scell.MCS_num_stimuli);
        if scell.subtype==4
            % in visual acuity experiment, stimuli sequence is
            % predetermined.
            scell.currentValue = scell.MCS_stimuli(1);
        else
            randomVal=ceil(scell.MCS_num_stimuli*rand(1));
            scell.currentValue = scell.MCS_stimuli(randomVal);
        end

		scell.complete=0;
		scell.initialized='yes';
	else
		randomval=rand*scell.initialValue_random_range;
		random_offset= floor(randomval/scell.stepLimit)*scell.stepLimit;
		scell.currentValue = (scell.initialValue+(2*round(rand)-1)*random_offset) ;  %If its the first value, then this will return the initial value plus or minus some offset within initialValue_random_range, but rounded to the nearest minimum step unit
        if scell.currentValue<scell.minValue
            scell.currentValue=scell.minValue;
        elseif scell.currentValue>scell.maxValue
            scell.currentValue=scell.maxValue;
        end

		scell.complete=0;
		scell.lastDirection=0;
		scell.currentReversals=0;
		scell.initialized='yes';
	end
