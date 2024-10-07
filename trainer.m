% Group: Chase Montgomery, Hussain Albotabeekh, Ahmad Hamzeh
load('COVIDbyCounty.mat');

% Split into training and testing groups. Training group will be the first
% data value from each division and wont be added to the 
testing_group = []; % Census information for test group
training_group = []; % Census information for training group
covid_testing = []; % COVID information for testing group
covid_training = []; % COVID information for training group
testing_indicies = []; % Indicies for testing group that correlate to the 
                       % CNTY_CENSUS and CNTY_COVID locations.
smooth_covid = movmean(CNTY_COVID, 10);

% Extract testing group
for i = 1:9
    k = i;
    while CNTY_CENSUS.DIVISION(k) ~= i
        k = k + 1;
    end
    testing_group = [testing_group; CNTY_CENSUS(k, :)];
    covid_testing = [covid_testing; CNTY_COVID(k, :)];
    testing_indicies = [testing_indicies k];
end

% Training group without testing data
for i = 1:length(CNTY_COVID)
    if find(testing_indicies == i) ~= 0
        continue;
    else
        training_group = [training_group; CNTY_CENSUS(i, :)];
        covid_training = [covid_training; CNTY_COVID(i, :)];
    end
end


% Clustering COVID data into at least k = 9 groups because there are nine 
% divisions
k = 9;
covid_train_smooth = movmean(covid_training, 10);
[idx, centroids] = kmeans(covid_train_smooth, k);
S = silhouette(covid_train_smooth, idx);

% Cost function balances space with accuray
while norm(S) < 9.4
    k = k + 1;
    [idx, centroids] = kmeans(covid_train_smooth, k);
    S = silhouette(covid_train_smooth, idx);
end

% Plot finalized silhouette data
figure(1);
silhouette(covid_train_smooth, idx);
title('Sample Silhouette Chart');

% Find centroid labels for each centroid's division
centroid_labels = [];
for i = 1:size(centroids, 1)
    centroid_labels = [centroid_labels; ...
        mode(training_group.DIVISION(idx == i, :))];
end

clear i;
clear k;
clear S;

exportgraphics(gcf, 'silhouette_chart.png');
save competition centroids centroid_labels;