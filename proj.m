clc; clear;
data=readtable('bankloan.csv');

missingval=ismissing(data);
sum(missingval)

Res = data(:,12);
% Convert to categorical variable
y = categorical(Res, [0 1], {'no' 'yes'})

% Display the result
%disp(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[group, groupID] = findgroups(dataset.default);
splitData = cell(size(groupID));
for i = 1:length(groupID)
    splitData{i} = dataset(group == i, :);
end




