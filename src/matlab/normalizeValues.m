function conditionsValuesNormalized = normalizeValues(conditionsValues)
%NORMALIZEVALUES normalizes values by the non treated control
%   Input: conditionsValues - structre array with values.
%
%   Output: conditionsValuesNormalized - structre array with values [0-1]
%   normalized by the non-treated control (considered as 100%)
%   
%   Formula: X/Xmax
%alternative formula:
%(X - Xmin)/(Xmax-Xmin), where Xmax
%   is non-treated and Xmin is uninfected
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


conditionsValuesNormalized = conditionsValues;
fieldsNames = fieldnames(conditionsValues);
% get to level1
for iFields = 1:numel(fieldsNames)
  %get to Level2
  for iDrugs = 1:size(conditionsValues.(fieldsNames{iFields}),2)
     %loop through all conditions, excluding first 2 (concentrations, and
     %non infected)
     disp(iDrugs);
     for iConditions = 2:size(conditionsValues.(fieldsNames{iFields}){1,iDrugs},1)
        %numberOfValues = numel(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, :));
        %Xmin = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, numberOfValues));
        % for infection it's no-treated maximum infected
        
        % define Xmax for different cases
        switch fieldsNames{iFields}
            case 'readout'
                if iConditions == 2
                    continue;
                end
                Xmax = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(3, 2));
            case 'cells'
                Xmax = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(2, 2));
            otherwise
                error('Unknown case for Xmax definition, please define it in the normalizeValues function');
        end
        %Normalization formula here
        %cath devision by zero
        if (Xmax)<=0
            error('Error: devision by zero or negative value');
        end
        
        

        conditionsValuesNormalized.(fieldsNames{iFields}){1,iDrugs}(iConditions, 2:end) = ...
            num2cell(cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, 2:end))/Xmax);
        
     
     end
  end
end



end

