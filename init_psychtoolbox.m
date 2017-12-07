% some initial instructions could be necessary later

% present the stimulus again?
presentAgain=0;
KbName('UnifyKeyNames');

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
% tx_many =Screen('MakeTexture',wid,manyLetterImg); % rescaling it to 200 x 800 makes letters 37 pixels high, which is 8.07pt at 750mm viewing distance

% beginning of the experiment
Screen('FillRect',wid,[0 0 0]);

[srcFactorOld destFactorOld]=Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('BlendFunction', wid, srcFactorOld, destFactorOld);
dispStr='hit any key to begin!';
Screen('DrawText',wid,dispStr,100,wrect(4)/4,WhiteIndex(scrnNum));
Screen('Flip',wid);

KbStrokeWait(-1);
