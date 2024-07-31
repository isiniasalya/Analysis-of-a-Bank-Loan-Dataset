data = readtable('bankloan.csv')

size(data)
%def = data(:,12);


default_name = categorical(data.default, [0, 1], {'No', 'Yes'});
data.default_name = default_name;
data

%prectors and response
predictors = data(:,1:11)


P = cvpartition(default_name,'Holdout',0.20);
training = data(P.training,:)


t1 = fitctree(meas,species);
view(t1);
view(t1,'Mode','graph');
 