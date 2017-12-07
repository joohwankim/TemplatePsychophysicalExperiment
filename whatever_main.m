% generate letter texture if it doesn't exist
if ~exist('lettertextures/manyletters.png','file');
    disp('Generate the letter image first by using RenderAndSaveLetters.m');
else
    stop_flag=0;
    %	initialize experimental parameters
    init_exp;

    if stop_flag~=1
        %	open psychtoolbox & prepare screen related parameters & data
        init_psychtoolbox;
    %     disp('finished init_psychtoolbox...');

    %     initialMessage;

        while (stop_flag==0)
            %	display image using chosen display protocol
            render_stim;
            %	process response
            process_response;
        end

        finalize_exp;
        %	close psychtoolbox
        finalize_psychtoolbox;
    end

    %	just to check
    disp('end of file');
end
