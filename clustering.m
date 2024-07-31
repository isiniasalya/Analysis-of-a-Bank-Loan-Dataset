% Perform Kruskal-Wallis test on age variable
%p_age = kruskalwallis(X_train(:,1), idx2);
% p_age = kruskalwallis(high_age, high_defaults);
% [p_age, tbl_age, stats_age] = kruskalwallis(high_age, high_defaults);
% p_employ = kruskalwallis(high_employ, high_defaults);
% [p_address, tbl_address, stats_address] = kruskalwallis(high_address, high_defaults,'off');
% p_income = kruskalwallis(high_income, high_defaults,'off');
% [p_debtinc, tbl_debtinc, stats_debtinc] = kruskalwallis(high_debtinc, high_defaults);
% [p_creddebt, tbl_creddebt, stats_creddebt] = kruskalwallis(high_creddebt, high_defaults);
% [p_othdebt, tbl_othdebt, stats_othdebt] = kruskalwallis(high_othdebt, high_defaults);
% % null hypothesis that there is no association between the variables.
% 
% 
% rho = corr(high_defaults, high_income, 'type', 'Spearman');


% using descriptive statistics and hypothesis tests as needed

clc;clear;
data = readtable('bankloan.csv');

%find missing values
missing_values = ismissing(data);
sum(missing_values);

%find duplicates
[~, ia, ic] = unique(data, 'rows', 'stable');
duplicate_rows = ia(histc(ic, 1:numel(ia)) > 1, :);
%duplicate_rows = find(duplicated(data, 'rows'));
[unique_rows, ~, idx] = unique(data, 'rows');

%convert default variable into names
% % default_name = categorical(data.default, [0, 1], {'No', 'Yes'});
% % data.default_name = default_name;
% % data;

%%%%%%%%%%%%%%data preprocessing%%%%%%%%%%%%%
% Dropping variables Again!
data(:, {'ncust','customer','age','ed','income','othdebt'}) = [];
data;
myArray = table2array(data);
myArray(:, 1) = [];
data = array2table(myArray, 'VariableNames', data.Properties.VariableNames([2:end]));

% Filter data based on a condition
condition = data.default == 1;
filtered_data_1 = data(condition,:);

% Print filtered data
disp(filtered_data_1);

% Filter data based on a condition
condition = data.default == 0;
filtered_data_0 = data(condition,:);

% Print filtered data
disp(filtered_data_0);
data;


% Create a new table called 'predictors' containing all predictor variables
responseCol = strcmp(data.Properties.VariableNames, 'default');
predictors = data(:, ~responseCol);
% Convert the predictor table to a matrix
X = zscore(table2array(predictors));
Y = data.default;

%spliting the dataset
rng(10);
% Split data into training, testing, and validation sets
cvp = cvpartition(size(X,1),'Holdout',0.2);  % 20% for testing
X_train = X(cvp.training,:);
Y_train = Y(cvp.training,:);
X_test = X(cvp.test,:);
Y_test = Y(cvp.test,:);


%%%%%%%%%%%%%%%%%%%%%%kmeans

%selecting the best number of clusters
kValues = 2:10;
meanSilhouetteScores = zeros(length(kValues), 1);
% Compute silhouette scores for each value of k
for i = 1:length(kValues)
    k = kValues(i);
    idx = kmeans(X_train,k,'replicates', 10);
    meanSilhouetteScores(i) = mean(silhouette(X_train,idx));
end
% Plot the silhouette scores against the number of clusters
plot(kValues, meanSilhouetteScores, 'bo-');
xlabel('Number of clusters');
ylabel('Average silhouette score');
% Find the k value that maximizes the silhouette score
[bestScore, bestIndex] = max(meanSilhouetteScores);
bestK = kValues(bestIndex);
fprintf('Best number of clusters = %d, silhouette score = %.4f\n', bestK, bestScore);

[idx2,c] = kmeans(X_train,bestK,'replicates', 10);
figure(2)
[silh,h] = silhouette(X_train,idx2);
xlabel('Silhouette Value')
ylabel('Cluster')

%number of observations in eacj cluster
counts = histcounts(idx2, 1:max(idx2)+1);
counts

default_rates = zeros(bestK, 1);
for i = 1:bestK
    default_rates(i) = sum(Y_train(idx2==i))/sum(idx2==i); % calculate the proportion of defaults in each cluster
end
[~, high_default_cluster] = max(default_rates); % select the cluster with the highest proportion of defaults

% Identify the customers in the high-default cluster
high_default_idx = find(idx2 == high_default_cluster);
high_default_customers = data(high_default_idx, :);

medians = grpstats(X_train, idx2, 'median');
std_devs = grpstats(X_train, idx2, 'std');
% rang = grpstats(X_train, idx2, {@max, @min});
% ranges = rang(1,:) - rang(2,:); % Calculate the range as the difference between the maximum and minimum values
% 
% Age by Clusters
figure(3)
boxplot(X_train(:,1),idx2);
xlabel('Cluster')
ylabel('Age')
title('Age of Defaults by clusters')

% Employ by Clusters
figure(4)
boxplot(X_train(:,3),idx2);
xlabel('Cluster')
ylabel('Years with current employer')
title('Years with current employer of Defaults by clusters')

% Address by Clusters
figure(5)
boxplot(X_train(:,4),idx2);
xlabel('Cluster')
ylabel('Years at current address')
title('Years at current address of Defaults by clusters')

% Income by Clusters
figure(6)
boxplot(X_train(:,5),idx2);
xlabel('Cluster')
ylabel('Income')
title('Income of Defaults by clusters')

% debtinc by Clusters
figure(7)
boxplot(X_train(:,6),idx2);
xlabel('Cluster')
ylabel('Debt to income ratio')
title('Debt to income ratio of Defaults by clusters')

% creddebt by Clusters
figure(8)
boxplot(X_train(:,7),idx2);
xlabel('Cluster')
ylabel('Credit card debt in thousands')
title('Credit card debt in thousands of Defaults by clusters')

% othdebt by Clusters
figure(9)
boxplot(X_train(:,8),idx2);
xlabel('Cluster')
ylabel('Other debt in thousands')
title('Other debt in thousands of Defaults by clusters')

% Education level by Clusters

%Compute the frequency of each category for each response
category = unique(X_train(:,2));
freqen = zeros(length(category),2);
for i = 1:length(category)
    freqen(i,1) = length(idx2(X_train(:,2) == category(i) & idx2 == 1));
    freqen(i,2) = length(idx2(X_train(:,2) == category(i) & idx2 == 2));
    if isempty(freqen(i,:))
        freqen(i,:) = [0 0];
    end
end

percentages = bsxfun(@rdivide, freqen, sum(freqen, 2)) * 100;
figure(10)
bar(percentages, 'stacked');
xlabel('Education level');
ylabel('Percentage');
legend('Cluster1','Cluster2');