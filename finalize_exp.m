%FINALIZE_EXP Summary of this function goes here
%   Detailed explanation goes here

%	save experiment data

% default format
datafilename=['datafiles/' subject_initials '_' datestr(clock,30) '.mat'];

for ii=1:length(scellCompleted)
    for j1=1:size(scell,1)
        for j2=1:size(scell,2)
            if get(scell{j1,j2},'crosstalk')==get(scellCompleted{ii},'crosstalk') && ...
                    get(scell{j1,j2},'disparity')==get(scellCompleted{ii},'disparity')
                scell{j1,j2}=scellCompleted{ii};
            end
        end
    end
end
uniqueStr = datestr(clock,30);
datafilename=['datafiles/' subject_initials '_' uniqueStr '.mat'];

save(datafilename,'l','scell','param','scellCompleted','scellThisRound','scellNextRound');
