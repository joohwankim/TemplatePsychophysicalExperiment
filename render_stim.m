previousKeyDownTime=-Inf;

if param.stim.type==1
    if presentAgain==0
        % set rendering variables
        stimDisparity=-get(scellThisRound{s_i},'disparity');
        refDisparity=-get(scellThisRound{s_i},'currentValue');
        stimColor=get(scellThisRound{s_i},'stimColor');
        bgColor=get(scellThisRound{s_i},'bgColor');
        crosstalk=get(scellThisRound{s_i},'crosstalk');
        whichSideRef=randi(2);
        whichSideStim=3-whichSideRef;

        % alter dot positions
        tempH=param.stim.dotSpacingH*rand(1,size(dotArrayUnaltered{1},2))-param.stim.dotSpacingH/2;
        tempV=param.stim.dotSpacingV*rand(1,size(dotArrayUnaltered{1},2))-param.stim.dotSpacingV/2;
        alterDotPosition{1}=[tempH; tempV];
        dotArray{1}=dotArrayUnaltered{1}+alterDotPosition{1};
        tempH=param.stim.dotSpacingH*rand(1,size(dotArrayUnaltered{2},2))-param.stim.dotSpacingH/2;
        tempV=param.stim.dotSpacingV*rand(1,size(dotArrayUnaltered{2},2))-param.stim.dotSpacingV/2;
        alterDotPosition{2}=[tempH; tempV];
        dotArray{2}=dotArrayUnaltered{2}+alterDotPosition{2};
        leftDotArray{whichSideRef}=...
            dotArray{whichSideRef}+...
            [refDisparity/2*ones(1,size(dotArray{whichSideRef},2)); zeros(1,size(dotArray{whichSideRef},2))]/2;
        rightDotArray{whichSideRef}=...
            dotArray{whichSideRef}-...
            [refDisparity/2*ones(1,size(dotArray{whichSideRef},2)); zeros(1,size(dotArray{whichSideRef},2))]/2;
        leftDotArray{whichSideStim}=...
            dotArray{whichSideStim}+...
            [stimDisparity/2*ones(1,size(dotArray{whichSideStim},2)); zeros(1,size(dotArray{whichSideStim},2))]/2;
        rightDotArray{whichSideStim}=...
            dotArray{whichSideStim}-...
            [stimDisparity/2*ones(1,size(dotArray{whichSideStim},2)); zeros(1,size(dotArray{whichSideStim},2))]/2;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % render the stimulus
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('FillRect',offwid,bgColor);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', offwid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',offwid,leftDotArray{whichSideStim},param.stim.dotDiameter,stimColor,[],2);
    Screen('BlendFunction', offwid, srcFactorOld, destFactorOld);
    leftOriginal=Screen('GetImage',offwid);
    Screen('FillRect',offwid,bgColor);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', offwid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',offwid,rightDotArray{whichSideStim},param.stim.dotDiameter,stimColor,[],2);
    Screen('BlendFunction', offwid, srcFactorOld, destFactorOld);
    rightOriginal=Screen('GetImage',offwid);
    % make crosstalk image
    leftOriginalIntensity=double(leftOriginal).^2.2;
    rightOriginalIntensity=double(rightOriginal).^2.2;
    leftStimIntensity=(1-crosstalk)*leftOriginalIntensity+...
        crosstalk*rightOriginalIntensity;
    rightStimIntensity=(1-crosstalk)*rightOriginalIntensity+...
        crosstalk*leftOriginalIntensity;
    leftStim=uint8(leftStimIntensity.^(1/2.2));
    rightStim=uint8(rightStimIntensity.^(1/2.2));
    Screen('SelectStereoDrawBuffer',wid,0);
    Screen('PutImage',wid,leftStim);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',wid,leftDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    Screen('FillRect',wid,bgColor,occlusionRects.left);
    Screen('DrawLines',wid,stimBorderLines.left,param.stim.borderLineWidth,stimColor);
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);

    Screen('SelectStereoDrawBuffer',wid,1);
    Screen('PutImage',wid,rightStim);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',wid,rightDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    Screen('FillRect',wid,bgColor,occlusionRects.right);
    Screen('DrawLines',wid,stimBorderLines.right,param.stim.borderLineWidth,stimColor);
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    % Screen('DrawText',wid,['crosstalk: ' num2str(crosstalk) ...
    %     ' stim disparity: ' num2str(stimDisparity)...
    %     ' reference disparity: ' num2str(refDisparity)],10,10,stimColor);
    Screen('Flip',wid);

    pause(param.stim.duration);
elseif param.stim.type==2
    if presentAgain==0
        % set rendering variables
        stimDisparity=get(scellThisRound{s_i},'disparity');
        refDisparity=get(scellThisRound{s_i},'currentValue');
        stimColor=get(scellThisRound{s_i},'stimColor');
        bgColor=get(scellThisRound{s_i},'bgColor');
        crosstalk=get(scellThisRound{s_i},'crosstalk');
        whichSideRef=randi(2); % I take it as it is, but it means which order is reference
        whichSideStim=3-whichSideRef; % similarly, which order is stimulus

        % alter dot positions
        tempH=param.stim.dotSpacingH*rand(1,size(dotArrayUnaltered{1},2))-param.stim.dotSpacingH/2;
        tempV=param.stim.dotSpacingV*rand(1,size(dotArrayUnaltered{1},2))-param.stim.dotSpacingV/2;
        alterDotPosition{1}=[tempH; tempV];
        dotArray{1}=dotArrayUnaltered{1}+alterDotPosition{1};
        tempH=param.stim.dotSpacingH*rand(1,size(dotArrayUnaltered{2},2))-param.stim.dotSpacingH/2;
        tempV=param.stim.dotSpacingV*rand(1,size(dotArrayUnaltered{2},2))-param.stim.dotSpacingV/2;
        alterDotPosition{2}=[tempH; tempV];
        dotArray{2}=dotArrayUnaltered{2}+alterDotPosition{2};
        leftDotArray{whichSideRef}=...
            dotArray{whichSideRef}+...
            [refDisparity/2*ones(1,size(dotArray{whichSideRef},2)); zeros(1,size(dotArray{whichSideRef},2))]/2;
        rightDotArray{whichSideRef}=...
            dotArray{whichSideRef}-...
            [refDisparity/2*ones(1,size(dotArray{whichSideRef},2)); zeros(1,size(dotArray{whichSideRef},2))]/2;
        leftDotArray{whichSideStim}=...
            dotArray{whichSideStim}+...
            [stimDisparity/2*ones(1,size(dotArray{whichSideStim},2)); zeros(1,size(dotArray{whichSideStim},2))]/2;
        rightDotArray{whichSideStim}=...
            dotArray{whichSideStim}-...
            [stimDisparity/2*ones(1,size(dotArray{whichSideStim},2)); zeros(1,size(dotArray{whichSideStim},2))]/2;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % render the stimulus
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('FillRect',offwid,bgColor);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', offwid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',offwid,leftDotArray{whichSideStim},param.stim.dotDiameter,stimColor,[],2);
    Screen('BlendFunction', offwid, srcFactorOld, destFactorOld);
    leftOriginal=Screen('GetImage',offwid);
    Screen('FillRect',offwid,bgColor);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', offwid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',offwid,rightDotArray{whichSideStim},param.stim.dotDiameter,stimColor,[],2);
    Screen('BlendFunction', offwid, srcFactorOld, destFactorOld);
    rightOriginal=Screen('GetImage',offwid);
    % make crosstalk image
    leftOriginalIntensity=double(leftOriginal).^2.2;
    rightOriginalIntensity=double(rightOriginal).^2.2;
    leftStimIntensity=(1-crosstalk)*leftOriginalIntensity+...
        crosstalk*rightOriginalIntensity;
    rightStimIntensity=(1-crosstalk)*rightOriginalIntensity+...
        crosstalk*leftOriginalIntensity;
    leftStim=uint8(leftStimIntensity.^(1/2.2));
    rightStim=uint8(rightStimIntensity.^(1/2.2));
    
    % masking before first depth plane
    maskingTime0=GetSecs;
    while(GetSecs-maskingTime0<param.stim.maskingTime)
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
    end
    
    % first depth plane
    Screen('SelectStereoDrawBuffer',wid,0);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if whichSideStim==1 % display stim
        Screen('PutImage',wid,leftStim);
    else
        Screen('DrawDots',wid,leftDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    end
    Screen('FillRect',wid,bgColor,occlusionRects.left);
    if param.stim.borderLineWidth>0
        Screen('DrawLines',wid,stimBorderLines.left,param.stim.borderLineWidth,stimColor);
    end
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);

    Screen('SelectStereoDrawBuffer',wid,1);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if whichSideStim==1 % display stim
        Screen('PutImage',wid,rightStim);
    else
        Screen('DrawDots',wid,rightDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    end
    Screen('FillRect',wid,bgColor,occlusionRects.right);
    if param.stim.borderLineWidth>0
        Screen('DrawLines',wid,stimBorderLines.right,param.stim.borderLineWidth,stimColor);
    end
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    % Screen('DrawText',wid,['crosstalk: ' num2str(crosstalk) ...
    %     ' stim disparity: ' num2str(stimDisparity)...
    %     ' reference disparity: ' num2str(refDisparity)],10,10,stimColor);
    Screen('Flip',wid);
    pause(param.stim.duration);
    
    % masking before first depth plane
    maskingTime0=GetSecs;
    while(GetSecs-maskingTime0<param.stim.maskingTime)
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
    end
    
    % second depth plane
    Screen('SelectStereoDrawBuffer',wid,0);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if whichSideStim==2 % display stim
        Screen('PutImage',wid,leftStim);
    else
        Screen('DrawDots',wid,leftDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    end
    Screen('FillRect',wid,bgColor,occlusionRects.left);
    if param.stim.borderLineWidth>0
        Screen('DrawLines',wid,stimBorderLines.left,param.stim.borderLineWidth,stimColor);
    end
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);

    Screen('SelectStereoDrawBuffer',wid,1);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if whichSideStim==2 % display stim
        Screen('PutImage',wid,rightStim);
    else
        Screen('DrawDots',wid,rightDotArray{whichSideRef},param.stim.dotDiameter,stimColor,[],2);
    end
    Screen('FillRect',wid,bgColor,occlusionRects.right);
    if param.stim.borderLineWidth>0
        Screen('DrawLines',wid,stimBorderLines.right,param.stim.borderLineWidth,stimColor);
    end
    % Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
    %     wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
    %     stimColor,[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    % Screen('DrawText',wid,['crosstalk: ' num2str(crosstalk) ...
    %     ' stim disparity: ' num2str(stimDisparity)...
    %     ' reference disparity: ' num2str(refDisparity)],10,10,stimColor);
    Screen('Flip',wid);
    pause(param.stim.duration);

end
