%% Ra, Ri, and Ihold vs EI correlations

% Clear parameters 
Ra = [];
EI = [];
Ri = [];
Ihold = [];

% For line of best fit and plotting
coefficients = [];
xFit = [];
yFit = [];
parameter = [];

%%

parameter = Ihold;
paramtitle = 'Ihold';
coefficients = polyfit(parameter,EI,1);
xFit = linspace(min(parameter),max(parameter),10);
yFit = polyval(coefficients,xFit);
scatter(parameter,EI,'filled','k');
hold off;
hold on;
plot(xFit,yFit,'b');
hold off;
title([paramtitle ' vs. E/I Thy1 optotrained opto coronal'])
xlabel([paramtitle])
ylabel('E/I Ratio')