function plotFitting(fittingParams,x, y, rSquare, drugName, conditionName, type)
%PLOTFITTING this function plots fitted function from fitSigmoid function 
% overlaid with normalized log transformed data used for plotting and the 
% computed Rsquare value. Finally the function saves the png of the plot
% either in the path declared in the global 'outFolderPath' variable. If
% the global 'outFolderPath' variable is not declared the function will
% save the plots into the current woking folder.
%
% Note: the function uses it's own sigmoidal function, if changes are made
% please update

%check whether the global variable is declared, if not substitute with
%current folder
global outFolderPath

if ~exist('outFolderPath', 'var')
   outFolderPath = pwd;
end

%use fitting parameters obtained for plotting
functionHandle = @(x)(fittingParams(1) + (fittingParams(2) - fittingParams(1))./(1 + 10.^((log10(fittingParams(3)) - x) - fittingParams(4))));

%create a title with metainformation
chartTitle = strcat(char(drugName), ': ', char(conditionName),', ', type);

%create saving path including the title as a file name


fplot (functionHandle,[(min(x)-1) (max(x)+1)]);
hold on
title(chartTitle);
xlabel('log(dose)');
ylabel('normalized response');
text(0.5, 0.5, ['R^2: ', num2str(rSquare)], 'horizontalAlignment', 'center')
figureHandle = plot (x,y, 'Color', [1 0 0], 'Marker', 'o');
hold off

chartTitle = parseSymbols(chartTitle,'forward');

path = fullfile(outFolderPath,  'fitting');

if exist(path, 'dir')~=7
    mkdir(path);
end

path = fullfile(path, strcat(chartTitle, '.png'));
saveas(figureHandle,path,'png');
close all

end

