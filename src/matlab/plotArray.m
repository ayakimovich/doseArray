function plotArray(doseArrayValues, format)
%PLOTARRAY plots the dose array values as a heatmap
%   input: doseArrayValues structure array, image format to be saved 
%(e.g. 'pdf')
%
% doseArray Copyright (C) 2014 Artur Yakimovich
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
global outFolderPath;

if nargin < 2
    format = 'pdf';
end
%check if the global variable exists
if ~exist('outFolderPath', 'var') && outFolderPath ~= ''
   outFolderPath = pwd;
end

% get to level1
level1Names = fieldnames(doseArrayValues);
for iType = 1:numel(level1Names)
    %get to Level2
    level2Names = fieldnames(doseArrayValues.(char(level1Names(iType))));
    for iDrugs = 1:numel(level2Names)
        level3Names = fieldnames(doseArrayValues.(char(level1Names(iType))).(char(level2Names(iDrugs))));
        for iConditions = 1:numel(level3Names) 
            %level4Names = fieldnames(doseArrayValues.(char(level1Names(iType))).(char(level2Names(iDrugs))).(char(level3Names(iConditions))));
            
            valuesArray.(char(level1Names(iType))){iConditions,iDrugs} =  doseArrayValues.(char(level1Names(iType))).(char(level2Names(iDrugs))).(char(level3Names(iConditions)));
        end
    

   %plot dose values for each drug in a subplot
    
    %valuesMatrix = cell2mat(valuesArray.(char(level1Names(iType))));
    hFig = figure(1);
    set(hFig, 'Position', [500 500 205*numel(level2Names) 40*numel(level3Names)]);
    %set(hFig, 'PaperSize', [270*numel(level2Names)+10 70*numel(level3Names)+10])
    set(gcf,'PaperPositionMode','auto');
    %title(gca,level1Names(iType),'FontSize',16,'fontWeight','bold');
    subplot(1,numel(level2Names), iDrugs);
    
    valuesMatrix = cell2mat(valuesArray.(char(level1Names(iType)))(1:iConditions,iDrugs));
    textValueMatrix = arrayfun(@num2str, (round(valuesMatrix.*100)./100), 'unif',0);
    %susbstitute values 0 for the 'NA'
    for i = 1:size(textValueMatrix,1)
        if textValueMatrix{i,1} == '0'
           textValueMatrix{i,1} = 'NA';
        end
    end
    rowLabels = parseSymbols(level3Names,'backward','c_');
    columnLabels = parseSymbols(level2Names(iDrugs),'backward','c_');
    [y,x] = size(valuesMatrix);
       
    imagesc(valuesMatrix);
    hStrings = text(repmat(x,y,1),1:y,textValueMatrix(:),...
        'HorizontalAlignment','center');
    axis tight;
    set(0,'DefaultAxesLooseInset',[0,0,0,0]);
    colormap(flipud(gray(100)));
    if min(valuesMatrix(:))~= max(valuesMatrix(:))
        colorbar;
        caxis([min(valuesMatrix(:)) max(valuesMatrix(:))]);
    else
        caxis([max(valuesMatrix(:))-1 max(valuesMatrix(:))+1]);
    end
    set(gca,'XTick',[1:x]);
    set(gca,'XTickLabe', columnLabels);
    set(gca,'YTick',[1:y]);
    set(gca,'YTickLabe', rowLabels);
    set(gca,'FontSize',10,'fontWeight','bold');
    %manipulte vlaues display properties
    set(hStrings,'FontSize',10,'fontWeight','bold');
    midValue = mean(get(gca,'CLim'));
    textColors = repmat(valuesMatrix(:) > midValue,1,3);
    set(hStrings,{'Color'},num2cell(textColors,2));
    end
    % save plot for each type
    path = cell2mat(fullfile(outFolderPath, strcat(level1Names(iType), '.pdf')));
    saveas(hFig,path,'pdf');
    close (hFig);
end

   
    
%     HeatMap(valuesMatrix, 'RowLabels', rowLabelsValues,...
%         'ColumnLabels', columnLabelsValues, ...
%         'Colormap', colormapValues,...
%         'DisplayRange', displayRangeValue,...
%     );


    
end


