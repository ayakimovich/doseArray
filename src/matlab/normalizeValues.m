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

