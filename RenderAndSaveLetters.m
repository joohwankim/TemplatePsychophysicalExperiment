jobType = 'many'; % 'many' or 'single'

try
    % Choosing the display with the highest display number is
    % a best guess about where you want the stimulus displayed.
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    % These preference setting selects the high quality text renderer on
    % each operating system: It is not really needed, as the high quality
    % renderer is the default on all operating systems, so this is more of
    % a "better safe than sorry" setting.
    Screen('Preference', 'TextRenderer', 1);

    % This command uncoditionally enables text anti-aliasing for high
    % quality text. It is not strictly needed here, because the default
    % setting is to let the operating system decide what to use - which is
    % usually anti-aliased rendering. This here just to demonstrate the
    % switch. On WindowsXP or Vista, there also exists a setting of 2 for
    % especially hiqh quality anti-aliasing. However, i couldn't ever see
    % any perceptible difference in quality...
    Screen('Preference', 'TextAntiAliasing', 1);

    % This setting disables user defined alpha-blending for text - not
    % strictly needed, alpha blending is disabled by default.
    Screen('Preference', 'TextAlphaBlending', 0);

    % We want the y-position of the text cursor to define the vertical
    % position of the baseline of the text, as opposed to defining the top
    % of the bounding box of the text. This command enables that behaviour
    % by default. However, the Screen('DrawText') command provides an
    % optional flag to override the global default on a case by case basis:
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
    KbName('UnifyKeyNames');
    
    % Open an onscreen window, fullscreen with default 50% gray background:
    [wid wrect]=Screen('OpenWindow', screenNumber, 255);
    Screen('BlendFunction', wid, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('TextFont',wid,'Times New Roman');
    
    if strcmp(jobType,'many')
        textSize = 112;
        captureRectW = 800;
        captureRectH = 200;
        while(1)
            Screen('TextSize',wid,textSize);
            captureRect = [wrect(3)/2 - captureRectW,wrect(4)/2 - captureRectH, wrect(3)/2 + captureRectW, wrect(4)/2 + captureRectH];
            message = [...
                'ABCDEFGHIJKLMNOPQR\n' ...
                'STUVWXYZabcdefghi\n' ...
                'jklmnopqrstuvwxyz' ...
                ];
            DrawFormattedText(wid,message,'center','center',[0 0 0]);
            Screen('FrameRect',wid,[255 0 0],captureRect + [-1 -1 1 1]);
            Screen('Flip',wid);
            letterImg = Screen('GetImage',wid,captureRect);
            imwrite(letterImg,'lettertextures/manyletters.png');
            [a b c] = KbStrokeWait;
            if strcmp(KbName(b),'LeftArrow')
                textSize = textSize - 10;
            elseif strcmp(KbName(b),'RightArrow')
                textSize = textSize + 10;
            elseif strcmp(KbName(b),'UpArrow')
                textSize = textSize + 1;
            elseif strcmp(KbName(b),'DownArrow')
                textSize = textSize - 1;
            elseif strcmp(KbName(b),'ESCAPE')
                break;
            elseif strcmp(KbName(b),'1!')
                captureRectW = captureRectW - 10;
            elseif strcmp(KbName(b),'2@')
                captureRectW = captureRectW + 10;
            elseif strcmp(KbName(b),'3#')
                captureRectH = captureRectH - 10;
            elseif strcmp(KbName(b),'4$')
                captureRectH = captureRectH + 10;
            end
        end
        
        aa = imread('lettertextures/manyletters.png');
        bb = imresize(aa,[200,800]);
        figure(2);imshow(bb);
    elseif strcmp(jobType,'single')
        textSize = 355;
        upperlower = 1;
        message = char([65:90 97:122]);
        Screen('TextSize',wid,textSize);
        for letter = message
            DrawFormattedText(wid,letter,'center','center',[0 0 0]);
            Screen('Flip',wid);
            letterImg = Screen('GetImage',wid,[wrect(3)/2 - 300, wrect(4)/2 - 375, wrect(3)/2 + 300, wrect(4)/2 + 375]);
            if letter < 95
                imwrite(letterImg,['lettertextures/upper_' letter '.png']);
            else
                imwrite(letterImg,['lettertextures/lower_' letter '.png']);
            end
        end
    end
    
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 0);

    % Close the screen, we're done...
    sca;

catch
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 0);
    sca;
    psychrethrow(psychlasterror);
end
