function [conditionsValuesAvg, conditionsValuesSD] = populationStat(conditionsValues, arithmetics)
%POPULATIONARITHMETICS perform averaging of conditionsValues struct array
%  using population arithmetics of choice
% input: conditionsValues - struct array with values where replica are in the upper level cell array
% arithmetics - 'mean', 'median' or 'mode'
% output: conditionsValuesAvg - averaged array , conditionsValuesSD -
% standard deviation in the array (uses same structure)
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

