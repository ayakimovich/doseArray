function outputArray = csvToCell(fileName, delimiter)
%% csvToCell
% usage:
% outputArray = csvToCell(fileName, delimiter)
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
