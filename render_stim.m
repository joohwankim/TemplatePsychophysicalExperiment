if presentAgain==0
    % read in the condition values
    conditionNum=get(scellThisRound{s_i},'condition_num');
    bgColor = conditions(conditionNum).brightness;
    letterHeight = conditions(conditionNum).letterHeight;
    whichSideRef=randi(2);
    whichSideStim=3-whichSideRef;
    simulatedPixelSize = get(scellThisRound{s_i},'currentValue');
    % generate testImg
    testImgSize = [200 800] * letterHeight / 37 ./ simulatedPixelSize;
    testImg = imresize(imresize(manyLetterImg, testImgSize),[200 800],'nearest');
    % choose up and down image
    if whichSideRef == 1 % ref is up
        upImg = refImg * (bgColor / 255);
        downImg = testImg * (bgColor / 255);
    else
        upImg = testImg * (bgColor / 255);
        downImg = refImg * (bgColor / 255);
    end
    stimPositionOffset = 300;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% render the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('FillRect',wid,bgColor);
Screen('PutImage',wid,upImg,...
    [wrect(3)/2 - 400, wrect(4)/2 - 100 - stimPositionOffset, wrect(3)/2 + 400, wrect(4)/2 + 100 - stimPositionOffset]);
Screen('PutImage',wid,downImg,...
    [wrect(3)/2 - 400, wrect(4)/2 - 100 - stimPositionOffset, wrect(3)/2 + 400, wrect(4)/2 + 100 - stimPositionOffset]);
Screen('Flip',wid);
pause(param.stim.duration);
