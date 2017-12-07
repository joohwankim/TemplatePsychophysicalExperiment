if presentAgain==0
    % read in the condition values
    conditionNum=get(scellThisRound{s_i},'condition_num');
    bgColor = conditions(conditionNum).brightness;
    letterHeight = conditions(conditionNum).letterHeight;
    whichSideRef=randi(2);
    whichSideStim=3-whichSideRef;
    simulatedPixelSize = get(scellThisRound{s_i},'currentValue');
    % generate testImg
    refImgSize = [200 800] * letterHeight / 37;
    testImgSize = [200 800] * letterHeight / 37 ./ simulatedPixelSize;
    refImg = imresize(manyLetterImg,refImgSize);
    testImg = imresize(imresize(manyLetterImg, testImgSize),refImgSize,'nearest');
    % adjust offset
    stimOffset = param.stim.positionOffset * letterHeight / 37;
    % choose up and down image
    if whichSideRef == 1 % ref is up
        upImg = refImg * (bgColor / 255);
        downImg = testImg * (bgColor / 255);
    else
        upImg = testImg * (bgColor / 255);
        downImg = refImg * (bgColor / 255);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% render the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect',wid,bgColor);
Screen('PutImage',wid,upImg,...
    [ ...
    wrect(3)/2 - size(refImg,2)/2, ...
    wrect(4)/2 - size(refImg,1)/2 - stimOffset/2, ...
    wrect(3)/2 + size(refImg,2)/2, ...
    wrect(4)/2 + size(refImg,1)/2 - stimOffset/2 ...
    ]); % The number of affected pixels is the same as the difference between 1st and 3rd elements (width) and 2nd and 4th elements (height) of the rect.
Screen('PutImage',wid,downImg,...
    [ ...
    wrect(3)/2 - size(refImg,2)/2, ...
    wrect(4)/2 - size(refImg,1)/2 + stimOffset/2, ...
    wrect(3)/2 + size(refImg,2)/2, ...
    wrect(4)/2 + size(refImg,1)/2 + stimOffset/2 ...
    ]); % The number of affected pixels is the same as the difference between 1st and 3rd elements (width) and 2nd and 4th elements (height) of the rect.
Screen('Flip',wid);
pause(param.stim.duration);
