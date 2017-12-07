% Part of PTBStaircase class
% Robin Held
% Banks Lab
% UC Berkeley

% This function takes in the latest response and updates the number of
% reversals, step size, etc.
% Here, 0 means the response should be skipped, 1 means 'less,' (or
% in the case of slant nulling, that the stimulus appeared to have
% negative slant), and 2 means 'more'

function [ms] = processResponse(ms,response)
% minimumtrials = 20;

if ms.MCS == 1
    % Method of constant stimuli
    
    % Skip if the response is 0
    if (response ~= 0)
        % Add response to response vector.
        ms.responses = [ms.responses response];
        % 			disp(['responses recording for scell C# ' num2str(ms.condition_num) ' R# ' num2str(ms.captureRate_num)]);
        % Increment number of resposnes for this stimulus
        it = find(ms.MCS_stimuli == ms.currentValue);
        ms.MCS_num_responses(it) = ms.MCS_num_responses(it) + 1;
        
        %             display(['Condition #' num2str(ms.condition_num) ' Capture rate #' num2str(ms.captureRate_num) ' velocity ' num2str(ms.currentValue) ' : '...
        % 				num2str(sum(ms.MCS_num_responses)) ' trials completed out of ' num2str(ms.MCS_max_responses * ms.MCS_num_stimuli)]);
        
        if length(ms.responses) == 1
            % This is the first response, so make sure it is recorded
            ms.values(1) = ms.currentValue;
            % 				disp(['values recording, and it is the first recording for scell C# ' num2str(ms.condition_num) ' R# ' num2str(ms.captureRate_num)]);
        end
        
        if(sum(ms.MCS_num_responses) >= ms.MCS_max_responses * ms.MCS_num_stimuli)
            ms.complete = 1;
            %                 display(['Condition #' num2str(ms.condition_num) 'Capture rate #' num2str(ms.captureRate_num) ' velocity ' num2str(ms.currentValue)...
            % 					' completed']);
        end
        
        % Determine the next stimulus value...
        if ~ms.complete
            % Randomly choose a stimulus that has not been shown the
            % maximum number of times
            newValue = inf;
            while(newValue == inf)
                it = ceil(ms.MCS_num_stimuli*rand);
                if (ms.MCS_num_responses(it) < ms.MCS_max_responses)
                    newValue = ms.MCS_stimuli(it);
                end
            end
            
            % Add the new value to the array of values
            ms.values = [ms.values newValue];
            ms.currentValue = newValue;
            % 				disp(['recording next value for scell C#' num2str(ms.condition_num) ' R#' num2str(ms.captureRate_num)]);
        end
    end
    
    % debug item
    %         display(['Reversals: ' num2str(ms.currentReversals)]);
    %     display(['Current Value: ' num2str(ms.currentValue)]);
    %         display(['Value vector length: ' num2str(length(ms.values))]);
    % 		ms.values
    %         display(['Response vector length: ' num2str(length(ms.responses))]);
    %         display(['Value: ' num2str(ms.currentValue)]);
    %         display(['Value: ' num2str(ms.currentValue)]);
  
% staircasing    
else
    
    
    % Skip if the response is 0
    if response ~= 0
        % Add response to response vector.
        ms.responses = [ms.responses(:)' response];
        
        if ms.straightrun == 1
            % The staircase should ignore the response in terms of step size and direction
            if length(ms.responses) == 1
                ms.values(1) = ms.currentValue;
                disp('values recording');
                %             else
                %                 if ((ms.currentValue <= ms.minValue) || (ms.currentValue >= ms.maxValue))
                %                     % The staircase has traversed all the intended values.
                %                     ms.complete = 1;
                %                     display 'Staircase complete!';
                %                 end
            end
            
            % Add the new value to the array of values
%             newValue = ms.currentValue + exp(log(ms.currentValue) + log(ms.stepSize)); %
            newValue = ms.currentValue + ms.stepSize;
                    
            %                 newValue = (ms.currentValue + ms.stepSize);
            ms.values = [ms.values newValue];
            disp('values recording');
            ms.currentValue = newValue;
            
            % Double-check that the current value isn't outsite the bounds
            if ((ms.currentValue < ms.minValue) || (ms.currentValue > ms.maxValue))
                ms.complete = 1;
                display 'Staircase complete!';
            end
            
            
        else
            % Treat as a normal staircase
            % Check whether this is the first response
            if length(ms.responses) ~= 1
                % Check whether the current response is the same as the last one
                if response ~= ms.responses(length(ms.responses) - 1)
                    if ((response == 1 && ms.numUp == 1 && ms.responserunflip >= ms.numDown) || (response == 2 && ms.numDown == 1 && ms.responserunflip >= ms.numUp))
                        % Halve the step size
                        if (ms.currentReversals < ms.maxReversals)
                            ms.stepSize = ms.stepSize / 2;
                        end
                        % Make sure the stepSize is larger than the minimum
                        if abs(ms.stepSize) < abs(ms.stepLimit)
                            ms.stepSize = sign(ms.stepSize) * abs(ms.stepLimit);
                        end
                        ms.currentReversals = ms.currentReversals + 1;
                        ms.reversalflag(length(ms.responses))=1;
                        % Check if the max # of reversals has been met
%                         if (ms.currentReversals > ms.maxReversals)&&(length(ms.responses)>=minimumtrials)
                        if (ms.currentReversals > ms.maxReversals)
                            ms.complete = 1;
                            display 'Staircase complete!';
                        end
                    end
                    ms.responserun=1.1;  %This can be one, but slight offset eliminates any roundoff error concern
                    ms.responserunflip=1.1;
                else %response is same as previous
                    ms.responserun=ms.responserun+1;
                    ms.responserunflip=ms.responserunflip+1;
                    if ((ms.responserunflip==ms.responserun) && (ms.responserunflip < (length(ms.responses) + 0.1)) && ....
                            ((response ==1 && ms.responserun>=ms.numUp) ...
                            || (response == 2 && ms.responserun>=ms.numDown))) ...
                            ... % below is exceptional case when subject keeps
                            ... % choosing one direction always even after hitting
                            ... % the limit of value
                            || (((response==1 && ms.responserun>=ms.numUp) && (ms.currentValue == ms.maxValue)) ||...
                            (response==2 && ms.responserun>=ms.numDown) && (ms.currentValue == ms.minValue))
                        % Halve the step size
                        if (ms.currentReversals < ms.maxReversals)
                            ms.stepSize = ms.stepSize / 2;
                        end
                        % Make sure the stepSize is larger than the minimum
                        if abs(ms.stepSize) < abs(ms.stepLimit)
                            ms.stepSize = sign(ms.stepSize) * abs(ms.stepLimit);
                        end
                        ms.currentReversals = ms.currentReversals + 1;
                        ms.reversalflag(length(ms.responses))=1;
                        % Check if the max # of reversals has been met
                        if (ms.currentReversals == ms.maxReversals)
                            ms.complete = 1;
                            display 'Staircase complete!';
                        end
                    end
                end
                if(length(ms.responses)>ms.maximumtrials)
                    ms.complete = 1;
                    display 'Staircase terminated, trial count exceeded';
                end
            else
                % This is the first response, so make sure the first value was
                % recorded
                ms.values(1) = ms.currentValue;
%                 disp('first value recording');
                ms.responserun = 1.1;  %start the response counter, even on first
                ms.responserunflip=1.1;
            end
            % Determine the next stimulus value...if the staircaes is not
            % complete
            if ~ms.complete
                if response == 1
                    stepSign = 1;
                elseif response == 2
                    stepSign = -1;
                end
                
                if ((response ==1 && ms.responserun>=ms.numUp)  || ...
                        (response == 2 && ms.responserun>=ms.numDown)) %make and adjustment
                    
                    % Make sure the new value is not outside the acceptable range
%                     newValue = ms.currentValue + (stepSign * exp(log(ms.currentValue) + log(ms.stepSize)));
                    newValue = ms.currentValue + (stepSign * ms.stepSize);
                  
                    if newValue > ms.maxValue
                        newValue = ms.maxValue;
                    elseif newValue < ms.minValue
                        newValue = ms.minValue;
                    end
                    
                    if newValue ~= ms.currentValue % if new value is different than current value
                        ms.responserun=0;  %reset responserun after an adjustment
                    end
                    
                else  %don't make an adjustment
                    newValue=ms.currentValue;
                end
                
                % Add the new value to the array of values
                ms.values = [ms.values newValue];
%                 disp('values recording');
                ms.currentValue = newValue;
            end
        end
    end
    
    % Debugging items
    
%     display(['Reversals: ' num2str(ms.currentReversals)]);
    %     display(['Current Value: ' num2str(ms.currentValue)]);
%     display(['Value vector length: ' num2str(length(ms.values))]);
%     display(['Condition #' num2str(ms.condition_num) ' Capture Rate #' num2str(ms.captureRate_num)]);
%     ms.values
%     ms.complete
%     ms.maxReversals
    %         display(['Value: ' num2str(ms.currentValue)]);
    %         display(['Value: ' num2str(ms.currentValue)]);

end

