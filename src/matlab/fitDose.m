function doseArrayValues = fitDose(conditionsValues)
%FITDOSE fitting the data array to either IC50 or LD50
%   input: dose array (averaged data expected)
%   output: array of fitted values
%   dependence: fitSigmoid




    fieldsNames = fieldnames(conditionsValues);
    % get to level1
    for iFields = 1:numel(fieldsNames)
        %get to Level2
        for iDrugs = 1:size(conditionsValues.(fieldsNames{iFields}),2)
            %loop through all conditions, excluding first 2 (concentrations, and
            %non infected)
            disp(iDrugs);
            for iConditions = 2:size(conditionsValues.(fieldsNames{iFields}){1,iDrugs},1)

                
                % define dose for different cases
                switch fieldsNames{iFields}
                    case 'readout'
                        if iConditions == 2
                            continue;
                        end
                        [IC50, rSquare, fittingParams, x, y] = fitSigmoid(...
                            cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(1, 3:end-1)),...
                            cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, 3:end-1)));
                        %plot and save fitting results:
                        %last three args: drug name, condition name,
                        %replica number
                        drugName = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(1, 1));
                        conditionName  = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, 1));
                        plotFitting(fittingParams,x, y, rSquare,...
                            drugName, conditionName, 'readout');
                        conditionFieldName = parseSymbols(conditionName, 'forward', 'c_');
                        %here we assable the IC50 LD50 data into a results array 
                        doseArrayValues.IC50.(parseSymbols(drugName, 'forward', 'c_')).(conditionFieldName) = IC50;
                        
                        
                    case 'cells'
                        if iConditions > 2
                            continue;
                        end
                        drugName = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(1, 1));
                        conditionName  = cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(iConditions, 1));
                        [LD50, rSquare, fittingParams, x, y] = fitSigmoid(...
                            cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(1, 3:end-1)),...
                            cell2mat(conditionsValues.(fieldsNames{iFields}){1,iDrugs}(2, 3:end-1)));
                        %plot and save fitting results:
                        %last three args: drug name, condition name,
                        %replica number
                        if rSquare > 0
                            plotFitting(fittingParams,x, y, rSquare,...
                                drugName, conditionName, 'cells');
                        end
                        
                        conditionFieldName = parseSymbols(conditionName, 'forward', 'c_');
                        %here we assable the IC50 LD50 data into a results array 
                        doseArrayValues.LD50.(parseSymbols(drugName, 'forward', 'c_')).(conditionFieldName) = LD50;
                        
                    otherwise
                        error('Unknown case for dose computation definition, please define it in the fitDose function');
                end
   
                
                
%                 conditionsValuesNormalized.(fieldsNames{iFields}){1,iDrugs}(iConditions, 2:end) = ...
%                     num2cell(/Xmax);
                
                
            end
        end
    end

end

