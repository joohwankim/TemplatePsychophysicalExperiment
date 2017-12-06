if isempty(get(scellThisRound{s_i},'MCS')) % staircasing
    reversalsBeforeResponse=get(scellThisRound{s_i},'currentReversals'); % remember # reversals
end

while(1)
    Screen('SelectStereoDrawBuffer',wid,0);
    Screen('FillRect',wid,bgColor);
    maskingIndex=randi(masking.numTex);
    Screen('DrawTexture',wid,maskingTx{maskingIndex});
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
        wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
        stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    Screen('SelectStereoDrawBuffer',wid,1);
    Screen('FillRect',wid,bgColor);
    Screen('DrawTexture',wid,maskingTx{maskingIndex});
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
        wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
        stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    Screen('Flip',wid);

    [a b c d]=KbCheck(-1);
    if a==1
        iKeyIndex=find(c);
        strInputName=KbName(iKeyIndex(1));

        if strcmp(strInputName,'UpArrow') || strcmp(strInputName,'up')...
                || strcmp(strInputName,'4') || strcmp(strInputName,'1!')
            if param.stim.type==1 % larger disparity means behind
                if whichSideRef==1
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},1);
                elseif whichSideRef==2
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},2);
                end
            elseif param.stim.type==2 % larger disparity means closer
                if whichSideRef==1
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},2);
                elseif whichSideRef==2
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},1);
                end
            end
            presentAgain=0;
            break;
        elseif strcmp(strInputName,'DownArrow') || strcmp(strInputName,'down')...
                || strcmp(strInputName,'1') || strcmp(strInputName,'2@')
            if param.stim.type==1
                if whichSideRef==1
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},2);
                elseif whichSideRef==2
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},1);
                end
            elseif param.stim.type==2
                if whichSideRef==1
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},1);
                elseif whichSideRef==2
                    scellThisRound{s_i}=processResponse(scellThisRound{s_i},2);
                end
            end
            presentAgain=0;
            break;
        elseif strcmp(strInputName,'space')
            presentAgain=1;
            break;
        elseif strcmp(strInputName,'ESCAPE')||strcmp(strInputName,'esc')
            stop_flag=1;
            break;
        end
    end
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
