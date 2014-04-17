function [conditionsValuesAvg, conditionsValuesSD] = populationStat(conditionsValues, arithmetics)
%POPULATIONARITHMETICS perform averaging of conditionsValues struct array
%  using population arithmetics of choice
% input: conditionsValues - struct array with values where replica are in the upper level cell array
% arithmetics - 'mean', 'median' or 'mode'
% output: conditionsValuesAvg - averaged array , conditionsValuesSD -
% standard deviation in the array (uses same structure)
firstReplica = 1;
nReplica = size(conditionsValues,2);
conditionsValuesAvg = cell2mat(conditionsValues(1,1));
conditionsValuesSD = cell2mat(conditionsValues(1,1));

fieldsNames = fieldnames(conditionsValues{1,firstReplica});
% get to level1
for iFields = 1:numel(fieldsNames)
    %get to Level2
    for iDrugs = 1:size(conditionsValues{1,firstReplica}.(fieldsNames{iFields}),2)
        %loop through all conditions, excluding first 2 (concentrations, and
        %non infected)
        disp(iDrugs);
        for iConditions = 2:size(conditionsValues{1,firstReplica}.(fieldsNames{iFields}){1,iDrugs},1)
            %iterate through each numeric value of the row
            for iValues = 2:size(conditionsValues{1,firstReplica}.(fieldsNames{iFields}){1,iDrugs},2)
                for iReplica = firstReplica:nReplica
                    valueVector(iReplica) =  cell2mat(conditionsValues{1,iReplica}.(fieldsNames{iFields}){1,iDrugs}(iConditions,iValues));
                end
                switch arithmetics
                    case 'mean'
                        conditionsValuesAvg.(fieldsNames{iFields}){1,iDrugs}(iConditions,iValues)...
                            = {mean(valueVector)};
                    case 'median'
                        conditionsValuesAvg.(fieldsNames{iFields}){1,iDrugs}(iConditions,iValues)...
                            = {median(valueVector)};
                    case 'mode'
                        conditionsValuesAvg.(fieldsNames{iFields}){1,iDrugs}(iConditions,iValues)...
                            = {mode(valueVector)};
                end
                
            end
            conditionsValuesSD.(fieldsNames{iFields}){1,iDrugs}(iConditions,iValues)...
                            = {std(valueVector)};
            
        end
    end
end


end

