% Inputs

clearvars -except x y
parameter = 'Norm EPSC1 (%)';

% x = []; % Maximum CR amplitude, sorted from smallest to largest
% y = cell(1,9); % Cell array, each element contains all experiments for a mouse

% Compute summary statistics
n   = cellfun(@numel, y);
mu  = cellfun(@mean, y); % plotted point
sd  = cellfun(@std, y, 'UniformOutput', true);
sem = sd ./ sqrt(n); % error bar
% SEM^2: variance of the mean, used for weighting

% Define conservative finite weights using largest SEM from well-defined points (n > 1) as a pessimistic estimate
% Avoid using an extreme outlier SEM as the conservative bound
maxSEM = max(sem(n > 1 & sem < prctile(sem,95)));

sem(n == 1 | isnan(sem) | sem == 0) = maxSEM;

W = 1 ./ sem.^2;

% Build table for fitlm
tbl = table(x(:), mu(:), W(:), ...
            'VariableNames', {'X','Y','W'});

mdl = fitlm(tbl, 'Y ~ X', 'Weights', tbl.W);

% Keeps points in the model, but minimizes their influence
% Defensible but approximate
disp(mdl)

% Plot
figure; hold on

errorbar(x, mu, sem, 'o-', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6, ...
    'CapSize', 10);

% Predict requries a table with predictor variable X
xfit = linspace(min(x), max(x), 200)';
tblFit = table(xfit, 'VariableNames', {'X'});

yfit = predict(mdl, tblFit);

plot(xfit, yfit, 'r-', 'LineWidth', 2)

xlabel('Maximum CR amplitude')
ylabel(parameter)
title([parameter ' weighted linear regression (conservative weights)'])
legend('Mean ± SEM', 'Weighted fit')
grid off

% Extract R-squared and p-value
R2 = mdl.Rsquared.Ordinary;
pVal = mdl.Coefficients.pValue(2);   % p-value for slope (X)

% Annotate figure
txt = sprintf('R^2 = %.3f\np = %.3g', R2, pVal);

xPos = min(xfit) + 0.01 * range(xfit);
yPos = max(mu)   - 1.2 * range(mu);

text(xPos, yPos, txt, ...
    'FontSize', 11, ...
    'BackgroundColor', 'w', ...
    'EdgeColor', 'k');
