%INIT_EXP Summary of this function goes here

% tempstr
subjectInitials = input('Enter subjects initials: ','s');
if isempty(subjectInitials)
    subjectInitials = 'test';
end

stop_flag=0; % set this to 1 whenever experiment should stop
scellInitiationCommand=['initScell' num2str(1)];
eval(scellInitiationCommand); % perform routine 'initScell#(subtype)'

% general scell organization
scellSize=size(scell);
scellLength=prod(scellSize(:));
scellArray=reshape(scell,scellLength,1);
scellCompleted=[];
scellThisRound=[];
scellNextRound=[];
for scellID=randperm(scellLength)
    if get(scellArray{scellID},'complete')==1
        scellCompleted{end+1}=scellArray{scellID};
    elseif strcmp(get(scellArray{scellID},'initialized'),'yes')
        scellThisRound{end+1}=scellArray{scellID};
    end
end

s_i=ceil(rand(1)*length(scellThisRound)); % pick an index for scell in this round 's_i'

% l for log
l = struct('ConditionNum',{},'Brightness',{},'LetterHeight',{},'Resolution',{},'Response',{});
