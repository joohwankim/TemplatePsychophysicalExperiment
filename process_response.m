if isempty(get(scellThisRound{s_i},'MCS')) % staircasing
    reversalsBeforeResponse=get(scellThisRound{s_i},'currentReversals'); % remember # reversals
end

Screen('FillRect',wid,bgColor);
Screen('Flip',wid);

[a b c]=KbStrokeWait;
strInputName=KbName(b);

if strcmp(strInputName,'space')
    presentAgain=1;
elseif strcmp(strInputName,'ESCAPE')||strcmp(strInputName,'esc')
    stop_flag=1;
elseif strcmp(strInputName,'UpArrow') || strcmp(strInputName,'DownArrow')
    % correct answer
    if (strcmp(strInputName,'UpArrow') && (whichSideRef == 1)) || (strcmp(strInputName,'DownArrow') && (whichSideRef == 2))
        scellThisRound{s_i}=processResponse(scellThisRound{s_i},2);
    % incorrect answer
    elseif (strcmp(strInputName,'DownArrow') && (whichSideRef == 1)) || (strcmp(strInputName,'UpArrow') && (whichSideRef == 2))
        scellThisRound{s_i}=processResponse(scellThisRound{s_i},1);
    end
    presentAgain=0;
    l(end+1).ConditionNum = conditionNum;
    l(end+1).Brightness = bgColor;
    l(end+1).LetterHeight = letterHeight;
    l(end+1).Resolution = 1 / (simulatedPixelSize / 240);
end

if presentAgain==0
    % select next scell to be processed
    if isempty(get(scellThisRound{s_i},'MCS')) % staircasing
        reversalsAfterResponse=get(scellThisRound{s_i},'currentReversals'); % remember # reversals
        if get(scellThisRound{s_i},'complete')==1
            clear temp;
            temp=[];
            for ii=1:length(scellThisRound)
                if ii==s_i
                    scellCompleted{end+1}=scellThisRound{ii};
                else
                    temp{end+1}=scellThisRound{ii};
                end
            end
            clear scellThisRound;
            scellThisRound=temp;
        elseif reversalsAfterResponse>reversalsBeforeResponse
            clear temp;
            temp=[];
            for ii=1:length(scellThisRound)
                if ii==s_i
                    scellNextRound{end+1}=scellThisRound{ii};
                else
                    temp{end+1}=scellThisRound{ii};
                end
            end
            clear scellThisRound;
            scellThisRound=temp;
        else % do nothing
        end
    elseif get(scellThisRound{s_i},'MCS')==1 % MCS
        if get(scellThisRound{s_i},'complete')==1
            clear temp;
            temp=[];
            for ii=1:length(scellThisRound)
                if ii==s_i
                    scellCompleted{end+1}=scellThisRound{ii};
                else
                    temp{end+1}=scellThisRound{ii};
                end
            end
            clear scellThisRound;
            scellThisRound=temp;
        else % move scell to next round anyway
            clear temp;
            temp=[];
            for ii=1:length(scellThisRound)
                if ii==s_i
                    scellNextRound{end+1}=scellThisRound{ii};
                else
                    temp{end+1}=scellThisRound{ii};
                end
            end
            clear scellThisRound;
            scellThisRound=temp;
        end
    end

    if isempty(scellThisRound)
        if isempty(scellNextRound)
            stop_flag=1; % end of the experiment
        else
            scellThisRound=scellNextRound;
            scellNextRound=[];
        end
    end
    s_i=ceil(rand(1)*length(scellThisRound));
end
