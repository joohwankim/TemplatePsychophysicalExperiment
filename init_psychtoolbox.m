% some initial instructions could be necessary later

% present the stimulus again?
presentAgain=0;
KbName('UnifyKeyNames');
% tempstr
disp('hit enter when done');
while(1)
    [a b c]=KbStrokeWait(-1);
    strInputName=KbName(b);

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
[wid wrect]=Screen('OpenWindow',scrnNum,BlackIndex(scrnNum),[0 0 2000 1000]);
Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
% read in textures of letters
% upperLetters = char(65:90);
% lowerLetters = char(97:122);
% tx_u = [];
% tx_l = [];
% for letter = upperLetters
%     letterImg = imread(['lettertextures/upper_' letter '.png']);
%     tx_u(end+1) = Screen('MakeTexture',wid,letterImg);
% end
% for letter = lowerLetters
%     letterImg = imread(['lettertextures/lower_' letter '.png']);
%     tx_l(end+1) = Screen('MakeTexture',wid,letterImg);
% end
manyLetterImg = imread('lettertextures/manyletters.png');
refImg = imresize(manyLetterImg,[200 800]);
% tx_many =Screen('MakeTexture',wid,manyLetterImg); % rescaling it to 200 x 800 makes letters 37 pixels high, which is 8.07pt at 750mm viewing distance

% beginning of the experiment
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
