function conditionsValues = retrieveValues(conditionsRanges,dataTable,readoutCol,cellsCol)
%RETRIEVEVALUES substitutes conditions ranges for their respective values
%   usageconditionsValues = retrieveValues(conditionsRanges,dataTable)
% Input: conditionsRanges structure array and dataTable cell array (data
% obtained from a csv data file), column indeces with respective data:
% infectionIndexAvgCol, infectionIndexSDCol, cellsAvgCol, cellsSDCol
%
% Output: structure array conditionsValues with identical structure as
% conditionsRAnges but with well names substituted by values


%create a structure array to parse the data into
conditionsValues.readout = conditionsRanges;
conditionsValues.cells = conditionsRanges;


%substitute ranges with respective values by iteration through indeces
for iDrug = 1:size(conditionsRanges,2)
    for jDoses = 2:size(conditionsRanges{iDrug},2)
        for iDoses = 2:size(conditionsRanges{iDrug},1)
            disp(['substituting: ',conditionsRanges{iDrug}(iDoses,jDoses)]);
            
                [matchingRow,matchingCol] = find(strcmp(dataTable(:,:), conditionsRanges{iDrug}(iDoses,jDoses)));
         
            %disp([matchingCol,matchingRow]);
            try
                conditionsValues.readout{iDrug}(iDoses,jDoses) = dataTable(matchingRow,readoutCol);

                conditionsValues.cells{iDrug}(iDoses,jDoses) = dataTable(matchingRow,cellsCol);

            catch err
                % Give more information for mismatch.
                if (regexp(err.message,'Assignment has more non-singleton rhs dimensions than non-singleton\w*'))
                    
                    msg = ['Most likely, well data anotation doesnt match the layout provided in the script parameters'];
                    error(msg);
                    
                    % Display any other errors as usual.
                 else
                    rethrow(err);
                end
            end
        end
    end
end


end

