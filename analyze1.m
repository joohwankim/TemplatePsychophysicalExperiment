% analyze experiment subtype 2
% ver. alpha, only takes 1 data file. Not robust at all for data structure

close all;
clear all;

priors.m_or_a='None';
priors.w_or_b='None';
priors.lambda='Uniform(0,.1)'; % lapse rate
priors.gamma='Uniform(0,.1)'; % guessing rate
nafc=1;
thresholdCut=0.5; % 75%

[filenames, pathname]=uigetfile('*.mat', 'Select all the experimental output files' ,'MultiSelect', 'on');
whatisthis=whos('filenames');
if strcmp(whatisthis.class, 'cell')
    number_of_files=length(filenames);
else
    number_of_files=1;
end

for index=1:number_of_files
    clear scell;
    if strcmp(whatisthis.class, 'cell')
        load([pathname filenames{index}]);
        subjectInitials=filenames{index}(1:3);
    else
        load([pathname filenames]);
        subjectInitials=filenames(1:3);
    end
    
    if ~exist('compiled','var')
        compiled=[];
    end
    
    for si1=1:size(scell,1)
        for si2=1:size(scell,2)
            for si3=1:size(scell,3)
                compiled{si1,si2,si3}.crosstalk=get(scell{si1,si2,si3},'crosstalk');
                compiled{si1,si2,si3}.disparity=get(scell{si1,si2,si3},'disparity');
                compiled{si1,si2,si3}.stimColor=get(scell{si1,si2,si3},'stimColor');
                compiled{si1,si2,si3}.values=get(scell{si1,si2,si3},'values');
                compiled{si1,si2,si3}.responses=get(scell{si1,si2,si3},'responses');
            end
        end
    end
end
%% data collection & sorting completed.
% start the analysis

for si1=1:size(scell,1)
    for si2=1:size(scell,2)
        disp(['fitting ' num2str((si1-1)*size(scell,2)+si2) ' out of ' num2str(size(scell,1)*size(scell,2))]);
        for si3=1:size(scell,3)
            tValues=compiled{si1,si2,si3}.values;
            tResponses=compiled{si1,si2,si3}.responses-1;
            clear px pfreq py;
            px=unique(tValues);
            for xi=1:length(px)
                responsesThisValue=tResponses(find(tValues==px(xi)));
                pfreq(xi)=length(responsesThisValue);
%                 py(xi)=sum(responsesThisValue)/pfreq(xi);
                py(xi)=sum(responsesThisValue);
            end
            compiled{si1,si2,si3}.px=px;
            compiled{si1,si2,si3}.py=py;
            compiled{si1,si2,si3}.pfreq=pfreq;
%             pfitInputData=[px' py' pfreq'];
%             pfitOutput=pfit(pfitInputData,'shape','cumulative Gaussian','cuts',[0.2 0.5 0.8],'n_intervals',1,'verbose',0);
%             compiled{si1,si2,si3}.mu=pfitOutput.params.est(1);
%             compiled{si1,si2,si3}.sigma=pfitOutput.params.est(2);
            BInput=[px' py' pfreq'];
            B=BayesInference(BInput,priors,'nafc',nafc,'sigmoid','gauss','cuts',[0.2 0.5]);
            diag=Diagnostics(B.data,B.params_estimate,'sigmoid',B.sigmoid,...
                'core',B.core,'nafc',B.nafc,'cuts',B.cuts);
            compiled{si1,si2,si3}.B=B;
            compiled{si1,si2,si3}.diag=diag;
            compiled{si1,si2,si3}.threshold=diag.thres(2);
            compiled{si1,si2,si3}.CI=getCI(B,2,0.95);
        end
    end
end

%% organize and plot data
% figure(1);
% hold on;
% for si1=1:scellSize(1)
%     for si2=1:scellSize(2)
%         tempxc(si2)=compiled{si1,si2,1}.rotationSpeed;
%         tempyc(si2)=compiled{si1,si2,1}.mu;
%         tempxl(si2)=compiled{si1,si2,2}.rotationSpeed;
%         tempyl(si2)=compiled{si1,si2,2}.mu;
%     end
%     dataColor{si1}.xx=unique(tempxc);
%     dataColor{si1}.color=double(compiled{si1,1,1}.color)/255;
%     for ii=1:length(dataColor{si1}.xx)
%         jj=find(tempxc==dataColor{si1}.xx(ii));
%         dataColor{si1}.yy(ii)=tempyc(jj);
%     end
%     dataLuminanceEquivalent{si1}.xx=unique(tempxl);
%     dataLuminanceEquivalent{si1}.color=double(compiled{si1,1,2}.color)/255;
%     for ii=1:length(dataLuminanceEquivalent{si1}.xx)
%         jj=find(tempxl==dataLuminanceEquivalent{si1}.xx(ii));
%         dataLuminanceEquivalent{si1}.yy(ii)=tempyl(jj);
%     end
%     plot(dataColor{si1}.xx,dataColor{si1}.yy,'-','Color',dataColor{si1}.color);
%     plot(dataLuminanceEquivalent{si1}.xx,dataLuminanceEquivalent{si1}.yy,'--','Color',dataLuminanceEquivalent{si1}.color);
% end
% hold off;

fontSize=20;
close all;
figure('Position',[50 600 400 400]);
scellMarkerSize=8;
curveMarkerSize=10;
hold on;
% horizontal line
plot([0 40],[0 0],'-k');
plot([-100 100],[-100 100],'k--');
% prediction line for two saturated colors, straight without temporal
myColor{1}=[0 0 0];
myColor{2}=[1 0 0];
myColor{3}=[0 1 0];
myColor{4}=[0 0 1];
myColor{5}=[1 1 0];
myColor{6}=[1 0 1];
myColor{7}=[0 1 1];
for si1=1:size(scell,1)
    dataLine{si1}.color=myColor{si1};
    dataLine{si1}.crosstalk=compiled{si1,1,1}.crosstalk;
    dataLine{si1}.staircase=[];
    for si2=1:size(scell,2)
        if ~isempty(compiled{si1,si2,1}.threshold)
            tempx_c(si2)=compiled{si1,si2,1}.disparity;
            tempy_c(si2)=compiled{si1,si2,1}.threshold;
            tempel_c(si2)=compiled{si1,si2,1}.threshold-compiled{si1,si2,1}.CI(1);
            tempeh_c(si2)=compiled{si1,si2,1}.CI(2)-compiled{si1,si2,1}.threshold;
            dataLine{si1}.staircase{si2}=compiled{si1,si2,1}.values;
            dataLine{si1}.diag{si2}=compiled{si1,si2,1}.diag;
            dataLine{si1}.datax{si2}=compiled{si1,si2,1}.px;
            dataLine{si1}.datay{si2}=compiled{si1,si2,1}.py./compiled{si1,si2,1}.pfreq;
        else
            tempx_c=[];
            tempy_c=[];
            tempel_c=[];
            tempeh_c=[];
        end
    end
    dataLine{si1}.xx=unique(tempx_c);
    dataLine{si1}.yy=[];
    dataLine{si1}.el=[];
    dataLine{si1}.eh=[];
    for ii=1:length(dataLine{si1}.xx)
        jj=find(tempx_c==dataLine{si1}.xx(ii));
        dataLine{si1}.yy(ii)=tempy_c(jj);
        dataLine{si1}.el(ii)=tempel_c(jj);
        dataLine{si1}.eh(ii)=tempeh_c(jj);
    end
    errorbar(dataLine{si1}.xx,dataLine{si1}.yy,dataLine{si1}.el,dataLine{si1}.eh,'-o',...
        'Color',dataLine{si1}.color,...
        'LineWidth',2,...
        'MarkerSize',curveMarkerSize,...
        'MarkerFaceColor',dataLine{si1}.color);
%     errorbar(data_l{si1}.xx-0.2,-data_l{si1}.yy,data_l{si1}.el,data_l{si1}.eh,'--^',...
%         'Color',data_l{si1}.color,...
%         'LineWidth',2,...
%         'MarkerSize',curveMarkerSize,...
%         'MarkerFaceColor',data_l{si1}.color);
end
axis([0 40 -10 50]);
xlabel('Disparity in Contents (deg/sec)','FontSize',fontSize);
ylabel('Perceived Disparity (arcmin)','FontSize',fontSize);
set(gca,'FontSize',fontSize);
title(subjectInitials);
hold off;
box on;

figure(2);
for li=1:length(dataLine)
    for si=1:length(dataLine{li}.staircase)
        subplot(length(dataLine),length(dataLine{1}.staircase),si+(li-1)*length(dataLine{1}.staircase));
        plot(dataLine{li}.datax{si},dataLine{li}.datay{si},'ko');
        hold on;
        plot(dataLine{li}.diag{si}.pmf(:,1),dataLine{li}.diag{si}.pmf(:,2));
        title(['li: ' num2str(li) ' si: ' num2str(si)]);
        hold off;
    end
end

figure(3);
for li=1:length(dataLine)
    for si=1:length(dataLine{li}.staircase)
        subplot(length(dataLine),length(dataLine{1}.staircase),si+(li-1)*length(dataLine{1}.staircase));
        plot(dataLine{li}.staircase{si});
        title(['li: ' num2str(li) ' si: ' num2str(si)]);
    end
end