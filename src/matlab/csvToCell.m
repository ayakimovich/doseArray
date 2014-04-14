function outputArray = csvToCell(fileName, delimiter)
%% csvToCell
% usage:
% outputArray = csvToCell(fileName, delimiter)
% 

%check
if nargin < 2
    delimiter = ',';
end

fileID = fopen(fileName);
inputData = textscan(fileID, '%s', 'delimiter', '\t');
fclose(fileID);
inputData = [inputData{:}];

numberOfLines = length(inputData(:,:));
indexDelimiter = cell(numberOfLines, 1);
nDelimiter = zeros(numberOfLines, 1);

for i = 1 : numberOfLines
    indexDelimiter{i} = [find(inputData{i} == delimiter), length(inputData{i }) + 1];
    nDelimiter(i) = length( indexDelimiter{i} );
end

if any(diff(nDelimiter))
    fprintf( 'Warning: number of fields is not constant.\n' );
end

nFields = max(nDelimiter);
outputArray = cell(numberOfLines, nFields);
 
for i = 1 : numberOfLines
    index = 1;
    for field = 1 : nDelimiter(i)
        cellValue = inputData{i}(index : indexDelimiter{i}(field) - 1);
        cellValue_num = str2double(cellValue);
        if isnan(cellValue_num)
            outputArray{i, field } = cellValue;
        else
            outputArray{i, field } = cellValue_num;
        end
        index = indexDelimiter{i}(field) + 1;
    end
end
return
