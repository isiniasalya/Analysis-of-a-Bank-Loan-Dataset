% % Descriptive Analysis
clc; clear;
data = readtable('bankloan.csv');

miss_Val = ismissing(data);
B = unique(data,'rows');
t = size(data)~= size(B);

% Creating a new variable 'default_name'
default_name = categorical(data.default,[0 1],{'No' 'Yes'});

% Filter data based on a condition
condition = data.default == 1;
def_yes = data(condition,:);
condition = data.default == 0;
def_no = data(condition,:);

% Income by Default
% Income by Default
figure(1)
boxplot(zscore(data.income),default_name)
xlabel('Default')
ylabel('Income')
title('Income by Default')

% Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.income)
title('Normal probability plot of Income of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.income);
title('Normal probability plot of Income of Not Defaults');
% Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.income,def_yes.income);
pval

%%Debt to Income ratio by Default

figure(2)
boxplot(zscore(data.debtinc),default_name)
xlabel('Default')
ylabel('Debt to Income ratio')
title('Debt to Income ratio by Default')

% % Create a new figure
figure;
% % Plot the first subplot
subplot(2,1,1);
normplot(def_yes.debtinc)
title('Normal probability plot of Debt to Income Ratio of Defaults');
% % Plot the second subplot
subplot(2,1,2);
normplot(def_no.debtinc);
title('Normal probability plot of Debt to Income Ratio of Not Defaults');

%Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.debtinc,def_yes.debtinc);
pval


%Credit card debt by Default
figure(3)
boxplot(zscore(data.creddebt),default_name)
xlabel('Default')
ylabel('Credit card Debt')
title('Credit card debt by Default')

% Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.creddebt)
title('Normal probability plot of Credit Card Debt of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.creddebt);
title('Normal probability plot of Credit Card Debt of Not Defaults');
%Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.creddebt,def_yes.creddebt);
pval


% Other debts by Default
figure(4)
boxplot(zscore(data.othdebt),default_name)
xlabel('Default')
ylabel('Other debts')
title('Other debts by Default')
% Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.othdebt)
title('Normal probability plot of Other Debts of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.creddebt);
title('Normal probability plot of Other Debts of Not Defaults');
% Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.othdebt,def_yes.othdebt);
pval


% % Employ by Default
figure(5)
boxplot(zscore(data.employ),default_name)
xlabel('Default')
ylabel('Employ')
title('Employ by Default')

% Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.employ)
title('Normal probability plot of Employement Years of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.employ);
title('Normal probability plot of Employement Years of Not Defaults');
% Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.employ,def_yes.employ);
pval


% Age by Default
figure(5)
boxplot(zscore(data.age),default_name)
xlabel('Default')
ylabel('Age')
title('Age by Default')
% Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.age)
title('Normal probability plot of Age of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.age);
title('Normal probability plot of Age of Not Defaults');
% Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.age,def_yes.age);
pval

% % Address by Default
 figure(5)
 boxplot(zscore(data.address),default_name)
 xlabel('Default')
 ylabel('Address')
 title('Address by Default')

% % Create a new figure
figure;
% Plot the first subplot
subplot(2,1,1);
normplot(def_yes.address)
title('Normal probability plot of Address of Defaults');
% Plot the second subplot
subplot(2,1,2);
normplot(def_no.address);
title('Normal probability plot of Address of Not Defaults');
% % Wilcoxon's Rank Sum test to compare the medians
[pval,h] = ranksum(def_no.address,def_yes.address);
pval


% %stacked bar percentage
%Compute the frequency of each category for each response
categories = unique(data.ed);
freq = zeros(length(categories),2);
for i = 1:length(categories)
    freq(i,1) = length(data.default(data.ed == categories(i) & data.default == 0));
    freq(i,2) = length(data.default(data.ed == categories(i) & data.default == 1));
    if isempty(freq(i,:))
        freq(i,:) = [0 0];
    end
end

percentages = bsxfun(@rdivide, freq, sum(freq, 2)) * 100;
bar(percentages, 'stacked');
xlabel('Default status');
ylabel('Percentage');
legend('Not Defaulted','Defaulted');

% Calculate Spearman correlation
rho = corr(data.default,data.age, 'type', 'Spearman');

% Display result
disp(['Spearman correlation coefficient: ' num2str(rho)]);
