% some initial instructions could be necessary later

% present the stimulus again?
presentAgain=0;

% tempstr
disp('hit enter when done');
while(1)
    [a b c]=KbStrokeWait(-1);
    iKeyIndex=find(b);
    strInputName=KbName(iKeyIndex);

    switch strInputName
        case {'RETURN','return','Return','enter'}
            break;
    end
end

screenNumber=0;
AssertOpenGL;
HideCursor;
ListenChar(2);

scrnNum=max(Screen('Screens'));
if param.stim.type==1
    [wid wrect]=Screen('OpenWindow',scrnNum,BlackIndex(scrnNum),[0 0 640 400],[],[],5);
    % [wid wrect]=Screen('OpenWindow',scrnNum,BlackIndex(scrnNum),[],[],[],4);
    [offwid offwrect]=Screen('OpenOffscreenWindow',scrnNum,BlackIndex(scrnNum),[0 0 wrect(3) wrect(4)]);
elseif param.stim.type==2
    [wid wrect]=Screen('OpenWindow',scrnNum,BlackIndex(scrnNum),[0 0 640 400],[],[],5);
    % [wid wrect]=Screen('OpenWindow',scrnNum,BlackIndex(scrnNum),[],[],[],4);
    [offwid offwrect]=Screen('OpenOffscreenWindow',scrnNum,BlackIndex(scrnNum),[0 0 wrect(3) wrect(4)]);
end

%% prepare for the experiment

% inter-trial masking
masking.numTex=200; % how many making images?
masking.dotSpacingH=param.stim.dotSpacingH;
masking.dotSpacingV=param.stim.dotSpacingV;
masking.dotSize=param.stim.dotDiameter;
[maskingDotH maskingDotV]=meshgrid(-masking.dotSpacingH:masking.dotSpacingH:(wrect(3)+masking.dotSpacingH),...
    -masking.dotSpacingV:masking.dotSpacingV:(wrect(4)+masking.dotSpacingV));
maskingDotH(2:2:end,:)=maskingDotH(2:2:end,:)+masking.dotSpacingH/2;
dotIndex=1;
for ii=1:size(maskingDotH,1)
    for jj=1:size(maskingDotH,2)
        maskingPrimitive(1,dotIndex)=maskingDotH(ii,jj);
        maskingPrimitive(2,dotIndex)=maskingDotV(ii,jj);
        dotIndex=dotIndex+1;
    end
end
for ii=1:masking.numTex
    % alter dot positions
    tempH=masking.dotSpacingH*rand(1,size(maskingPrimitive,2))-masking.dotSpacingH/2;
    tempV=masking.dotSpacingV*rand(1,size(maskingPrimitive,2))-masking.dotSpacingV/2;
    maskingJitter=[tempH; tempV];
    maskingDots=maskingPrimitive+maskingJitter;
    Screen('FillRect',offwid,[0 0 0]);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', offwid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawDots',offwid,maskingDots,masking.dotSize,[255 255 255],[],1);
    Screen('BlendFunction', offwid, srcFactorOld, destFactorOld);
    tempImg=Screen('GetImage',offwid);
    maskingTx{ii}=Screen('MakeTexture',wid,tempImg);
end

% stimtype==1 % simultaneous presentation of two depth planes
if param.stim.type==1
    % pregeneration part
    % coordinates of: occlusion planes and stimuli border lines
    % ------------------------
    % |    |    rect    |    |
    % |    |      2     |    |
    % |    |-------3----|    |
    % |    1     up     2    |
    % |    |    stim    |    |
    % |    |-------4----|    |
    % |rect|    rect    |rect|
    % |  1 |      3     |  5 |
    % |    |-------3----|    |
    % |    1    down    2    |
    % |    |    stim    |    |
    % |    |-------4----|    |
    % |    |    rect    |    |
    % |    |      4     |    |
    % ------------------------
    occlusionRects.cyclopian=[0 wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2;...
        0 0 wrect(4)/2-param.stim.separation/2 wrect(4)/2+param.stim.separation/2+param.stim.height 0;...
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 wrect(3);...
        wrect(4) wrect(4)/2-param.stim.separation/2-param.stim.height wrect(4)/2+param.stim.separation/2 wrect(4) wrect(4)];
    occlusionRects.left=occlusionRects.cyclopian+...
        param.stim.borderLineDisparity/2*[0 1 1 1 1;0 0 0 0 0;1 1 1 1 1;0 0 0 0 0];
    occlusionRects.right=occlusionRects.cyclopian-...
        param.stim.borderLineDisparity/2*[1 1 1 1 1;0 0 0 0 0;1 1 1 1 0;0 0 0 0 0];
    stimBorderLines.cyclopian=[wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 ... % x, up stim line 1
        wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, up stim line 2
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, up stim line 3
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, up stim line 4
        wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 ... % x, down stim line 1
        wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, down stim line 2
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, down stim line 3
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2; ... % x, down stim line 4
        wrect(4)/2-param.stim.separation/2-param.stim.height wrect(4)/2-param.stim.separation/2 ... % y, up stim line 1
        wrect(4)/2-param.stim.separation/2-param.stim.height wrect(4)/2-param.stim.separation/2 ... % y, up stim line 2
        wrect(4)/2-param.stim.separation/2-param.stim.height wrect(4)/2-param.stim.separation/2-param.stim.height ... % y, up stim line 3
        wrect(4)/2-param.stim.separation/2 wrect(4)/2-param.stim.separation/2 ... % y, up stim line 4
        wrect(4)/2+param.stim.separation/2 wrect(4)/2+param.stim.separation/2+param.stim.height ... % y, down stim line 1
        wrect(4)/2+param.stim.separation/2 wrect(4)/2+param.stim.separation/2+param.stim.height ... % y, down stim line 2
        wrect(4)/2+param.stim.separation/2 wrect(4)/2+param.stim.separation/2 ... % y, down stim line 3
        wrect(4)/2+param.stim.separation/2+param.stim.height wrect(4)/2+param.stim.separation/2+param.stim.height]; % y, down stim line 4
    stimBorderLines.left=stimBorderLines.cyclopian+...
        param.stim.borderLineDisparity/2*[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    stimBorderLines.right=stimBorderLines.cyclopian-...
        param.stim.borderLineDisparity/2*[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    % stim & bg colors
    colorSet{1}=[255 255 255];
    colorSet{2}=[0 0 0];

    % cyclopian dot position grid
    [dotH dotV]=meshgrid(1:param.stim.dotSpacingH:wrect(3),1:param.stim.dotSpacingV:wrect(4));
    dotH(2:2:end,:)=dotH(2:2:end,:)+param.stim.dotSpacingH/2;
    centerCoordH=wrect(3)/2;
    centerCoordV=wrect(4)/2;
    dotArrayUnaltered=[];
    dotIndex1=0;
    dotIndex2=0;
    for ii=1:size(dotH,1)
        for jj=1:size(dotH,2)
            criteriaH=...
                (dotH(ii,jj)-centerCoordH)>(-param.stim.width/2-param.stim.maximumDisparity*2) &&...
                (dotH(ii,jj)-centerCoordH)<(param.stim.width/2+param.stim.maximumDisparity*2);
            criteriaV1=...
                (dotV(ii,jj)-(centerCoordV-param.stim.height/2-param.stim.separation/2))>(-param.stim.height/2-param.stim.dotSpacingV) &&...
                (dotV(ii,jj)-(centerCoordV-param.stim.height/2-param.stim.separation/2))<(param.stim.height/2+param.stim.dotSpacingV);
            criteriaV2=...
                (dotV(ii,jj)-(centerCoordV+param.stim.height/2+param.stim.separation/2))>(-param.stim.height/2-param.stim.dotSpacingV) &&...
                (dotV(ii,jj)-(centerCoordV+param.stim.height/2+param.stim.separation/2))<(param.stim.height/2+param.stim.dotSpacingV);
            criteria1=criteriaH && criteriaV1;
            criteria2=criteriaH && criteriaV2;
            if criteria1==1 % include into first dot array
                dotIndex1=dotIndex1+1;
                dotArrayUnaltered{1}(1,dotIndex1)=dotH(ii,jj);
                dotArrayUnaltered{1}(2,dotIndex1)=dotV(ii,jj);
            elseif criteria2==1 % include into second dot array
                dotIndex2=dotIndex2+1;
                dotArrayUnaltered{2}(1,dotIndex2)=dotH(ii,jj);
                dotArrayUnaltered{2}(2,dotIndex2)=dotV(ii,jj);
            end
        end
    end

    % beginning of the experiment
    Screen('SelectStereoDrawBuffer',wid,0);
    Screen('FillRect',wid,[0 0 0]);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
        wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
        [255 255 255],[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    dispStr='hit any key to begin!';
    Screen('DrawText',wid,dispStr,100,wrect(4)/4,WhiteIndex(scrnNum));
    Screen('SelectStereoDrawBuffer',wid,1);
    Screen('FillRect',wid,[0 0 0]);
    [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
        wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
        [255 255 255],[],1); % fixation cross
    Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
    dispStr='hit any key to begin!';
    Screen('DrawText',wid,dispStr,100,wrect(4)/4,WhiteIndex(scrnNum));
    Screen('Flip',wid);

    KbStrokeWait(-1);
elseif param.stim.type==2 % stimtype==2, alternate presentation of two depth planes
    % pregeneration part
    % coordinates of: occlusion planes and stimuli border lines
    % ------------------------
    % |    |      2     |    |
    % |    |-------3----|    |
    % |rect1    stim    2rect|
    % |  1 |            |  4 |
    % |    |-------4----|    |
    % |    |      3     |    |
    % ------------------------
    occlusionRects.cyclopian=[0 wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2;...
        0 0 wrect(4)/2+param.stim.height/2 0;...
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 wrect(3);...
        wrect(4) wrect(4)/2-param.stim.height/2 wrect(4) wrect(4)];
    occlusionRects.left=occlusionRects.cyclopian+...
        param.stim.borderLineDisparity/2*[0 1 1 1;0 0 0 0;1 1 1 0;0 0 0 0];
    occlusionRects.right=occlusionRects.cyclopian-...
        param.stim.borderLineDisparity/2*[0 1 1 1;0 0 0 0;1 1 1 0;0 0 0 0];
    stimBorderLines.cyclopian=[wrect(3)/2-param.stim.width/2 wrect(3)/2-param.stim.width/2 ... % x, stim line 1
        wrect(3)/2+param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, stim line 2
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2 ... % x, stim line 3
        wrect(3)/2-param.stim.width/2 wrect(3)/2+param.stim.width/2; ... % x, stim line 4
        wrect(4)/2-param.stim.height/2 wrect(4)/2+param.stim.height/2 ... % y, stim line 1
        wrect(4)/2-param.stim.height/2 wrect(4)/2+param.stim.height/2 ... % y, stim line 2
        wrect(4)/2-param.stim.height/2 wrect(4)/2-param.stim.height/2 ... % y, stim line 3
        wrect(4)/2+param.stim.height/2 wrect(4)/2+param.stim.height/2]; % y, stim line 4
    stimBorderLines.left=stimBorderLines.cyclopian+...
        param.stim.borderLineDisparity/2*[1 1 1 1 1 1 1 1;0 0 0 0 0 0 0 0];
    stimBorderLines.right=stimBorderLines.cyclopian-...
        param.stim.borderLineDisparity/2*[1 1 1 1 1 1 1 1;0 0 0 0 0 0 0 0];
    % stim & bg colors
    colorSet{1}=[255 255 255];
    colorSet{2}=[0 0 0];

    % cyclopian dot position grid
    [dotH dotV]=meshgrid(1:param.stim.dotSpacingH:wrect(3),1:param.stim.dotSpacingV:wrect(4));
    dotH(2:2:end,:)=dotH(2:2:end,:)+param.stim.dotSpacingH/2;
    centerCoordH=wrect(3)/2;
    centerCoordV=wrect(4)/2;
    dotArrayUnaltered=[];
    dotIndex=1;
    for ii=1:size(dotH,1)
        for jj=1:size(dotH,2)
            criteriaH=...
                (dotH(ii,jj)-centerCoordH)>(-param.stim.width/2-param.stim.maximumDisparity*2) &&...
                (dotH(ii,jj)-centerCoordH)<(param.stim.width/2+param.stim.maximumDisparity*2);
            criteriaV=...
                (dotV(ii,jj)-centerCoordV)>(-param.stim.height/2-param.stim.dotSpacingV) &&...
                (dotV(ii,jj)-centerCoordV)<(param.stim.height/2+param.stim.dotSpacingV);
            criteria=criteriaH && criteriaV;
            if criteria==1 % include into first dot array
                dotArrayUnaltered{1}(1,dotIndex)=dotH(ii,jj);
                dotArrayUnaltered{1}(2,dotIndex)=dotV(ii,jj);
                dotIndex=dotIndex+1;
            end
        end
    end
    dotArrayUnaltered{2}=dotArrayUnaltered{1};

    % beginning of the experiment
    while(1)
        Screen('SelectStereoDrawBuffer',wid,0);
        Screen('FillRect',wid,[0 0 0]);
        maskingIndex=randi(masking.numTex);
        Screen('DrawTexture',wid,maskingTx{maskingIndex});
        [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
            wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
            [255 255 255],[],1); % fixation cross
        Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
        Screen('SelectStereoDrawBuffer',wid,1);
        Screen('FillRect',wid,[0 0 0]);
        Screen('DrawTexture',wid,maskingTx{maskingIndex});
        [srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        Screen('DrawLines',wid,[wrect(3)/2 wrect(3)/2 wrect(3)/2-param.fixationCross.size/2 wrect(3)/2+param.fixationCross.size/2;...
            wrect(4)/2-param.fixationCross.size/2 wrect(4)/2+param.fixationCross.size/2 wrect(4)/2 wrect(4)/2],param.fixationCross.lineWidth,...
            [255 255 255],[],1); % fixation cross
        Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
        Screen('Flip',wid);

        [a b c d]=KbCheck(-1);
        if a==1
            break;
        end
    end
end
