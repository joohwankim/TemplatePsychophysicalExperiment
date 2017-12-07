% analyze experiment subtype 2
% ver. alpha, only takes 1 data file. Not robust at all for data structure

close all;
clear all;

options = struct;
options.sigmoidName = 'norm';
options.expType = '2AFC';

priors.m_or_a='None';
priors.w_or_b='None';
priors.lambda='Uniform(0,.1)'; % lapse rate
priors.gamma='Uniform(0,.1)'; % guessing rate
nafc=2;
thresholdCut=0.5; % 75%

[filenames, pathname]=uigetfile('*.mat', 'Select all the experimental output files' ,'MultiSelect', 'on');
whatisthis=whos('filenames');
if strcmp(whatisthis.class, 'cell')
    number_of_files=length(filenames);
else
    number_of_files=1;
end

for index=1:number_of_files
    clear l;
    if strcmp(whatisthis.class, 'cell')
        load([pathname filenames{index}]);
        subjectInitials=filenames{index}(1:3);
    else
        load([pathname filenames]);
        subjectInitials=filenames(1:3);
    end
    
    if ~exist('data','var')
        data=[];
    end
    
    data = [data l];
end
%% data collection & sorting completed.
% start the analysis

a = []; % a for 'analyzed'
conditionCount = 0;
for si1 = 1:size(param.stim.brightness)
    for si2 = 1:size(param.stim.letterHeight)
        conditionCount = conditionCount + 1;
        a(si1,si2) = struct('px',{},'py',{},'pfreq',{},'res',{});
        brightness = param.stim.brightness(si1);
        letterHeight = param.stim.letterHeight(si1);
        tIndex = ([data.brightness] == brightness) .* ([data.letterHeight] == letterHeight);
        tValues = 1./data(tIndex).Resolution;
        tResponses = data(tIndex).Response;
        a(si1,si2).px = unique(tValues);
        for xi = 1:length(px)
            responsesThisVlue = tResponses(tValues==px(xi));
            a(si1,si2).pfreq(xi) = length(responsesThisValue);
            a(si1,si2).py(xi) = sum(responsesThisValue);
        end
        pInput = [a(si1,si2).px' a(si1,si2).py' a(si1,si2).pfreq'];
        a(si1,si2).res=psignifit(pInput,options);
        subplot(length(param.stim.brightness),length(param.stim.letterHeight),conditionCount);
        plotPsych(a(si1,si2).res);
        title(['Brightness: ' num2str(param.stim.brightness(si1)) ' Letter: ' num2str(param.stim.letterHeight(si2))]);
    end
end
