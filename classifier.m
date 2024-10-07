load('competition.mat');

% Find nearest nearest neighbor using Euclidean norm
assignment = []; % Array holding findings based on the
for i = 1:size(covid_testing, 1)
    comparison = [];
    for k = 1:length(centroid_labels)
        distance = norm(covid_testing(i, :) - centroids(k, :));
        comparison = [comparison distance];
    end
    [~, target] = min(comparison);
    assignment = [assignment centroid_labels(target)];
end

count = 0;

for i = 1:9
    if assignment(i) == i
        count = count + 1;
    end
end

percent_success = count/9 * 100;
disp(percent_success);

clear i;
clear k;
clear distance;
clear target;
clear comparison;
