%% doseArray
% IC50, LD50, Pharmaceutical Index array computer and plotter
% input: path to csv file with inhibitory effect and cell number data (mean and sd)
% output: heatmap plot of IC50 array under different conditions as pdf

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



%
%User input

%specify condition groups as rows and columns of a cell array
% keep to following format:
% col 1: 
%(1) name
%(2) is 0 for 'no treatment' control
%(3 and on)doses
%
% col 2 and on: 
%(1) condition group name 
%(2) index of (e.g. 'no drug treatment' control) in a multi titer plate
%(3 and on)rage of wells in a multi titer plate respective to the dose
%(last) multi titer plate index of max effect (e.g. 'no virus control')
% 
% Example: specify as many nested cell arrays as you have drugs:
% conditionsRanges = {...
%         {'H4', 0, 16.23, 1.623, 0.1623, 0.01623, 0.01623, 'max';...
%     '2.36e3 pfu', 'B01', 'B02', 'B03', 'B04', 'B05', 'B06', 'A01';...
%     '2.36e2 pfu', 'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'A01';...
%     '2.36e1 pfu', 'D01', 'D02', 'D03', 'D04', 'D05', 'D06', 'A01'}...
%         {'H5',0, 16.23, 1.623, 0.1623, 0.01623, 0.01623, 'max';...
%     '2.36e3 pfu', 'B07', 'B08', 'B09', 'B10', 'B11', 'B12', 'A06';...
%     '2.36e2 pfu', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12', 'A06';...
%     '2.36e1 pfu', 'D07', 'D08', 'D09', 'D10', 'D11', 'D12', 'A06'}...
% };
sprintf(' doseArray  Copyright (C) 2014  Artur Yakimovich. \n This program comes with ABSOLUTELY NO WARRANTY.\n This is free software, and you are welcome to redistribute it under certain conditions.\n For details see https://www.gnu.org/licenses/gpl-3.0.txt')
conditionsRanges = {...
        {'H4', 0, 16.23, 1.623, 0.1623, 0.01623, 0.001623, 'max';...
    'NoVir', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A1';...
    '2.36e3 pfu', 'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'A1';...
    '2.36e2 pfu', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'A1';...
    '2.36e1 pfu', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'A1'}...
        {'H5',0, 16.23, 1.623, 0.1623, 0.01623, 0.01623, 'max';...
    'NoVir', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A6';...
    '2.36e3 pfu', 'B7', 'B8', 'B9', 'B10', 'B11', 'B12', 'A6';...
    '2.36e2 pfu', 'C7', 'C8', 'C9', 'C10', 'C11', 'C12', 'A6';...
    '2.36e1 pfu', 'D7', 'D8', 'D9', 'D10', 'D11', 'D12', 'A6'}...
        {'Ara-C', 0, 16.23, 1.623, 0.1623, 0.01623, 0.01623, 'max';...
    'NoVir', 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E1';...
    '2.36e3 pfu', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'E1';...
    '2.36e2 pfu', 'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'E1';...
    '2.36e1 pfu', 'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'E1'}...
        {'H8', 0, 16.23, 1.623, 0.1623, 0.01623, 0.01623, 'max';...
    'NoVir', 'E7', 'E8', 'E9', 'E10', 'E11', 'E12', 'E6';...
    '2.36e3 pfu', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'E6';...
    '2.36e2 pfu', 'G7', 'G8', 'G9', 'G10', 'G11', 'G12', 'E6';...
    '2.36e1 pfu', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'E6'}...
};

%specify input csv file & output folder
inPath = 'R:\Data\140305_H_paper\simultaneous_addition\doseArray\';
dataSeparator = ';';
global outFolderPath;
outFolderPath = 'R:\Data\140305_H_paper\simultaneous_addition\doseArray\';

%data file comuns
cellsCol = 1;
readoutCol = 3;

infectionIndexAvgCol = 1;
infectionIndexSDCol = 2;
cellsAvgCol = 3;
cellsSDCol = 4;
%specify the patter of data files to read
dataFilePattern = '*.csv';

%read all the files into nested cell array
dataFileList = dir(fullfile(inPath,dataFilePattern));
for i = 1:size(dataFileList,1)
   %read the data tables
    dataTable = csvToCell(fullfile(inPath,dataFileList(i,1).name), dataSeparator);
    %substitute ranges with respective values by iteration through indeces
    conditionsValues{i} = retrieveValues(conditionsRanges,dataTable,readoutCol,cellsCol);
end


%normalize data, here no-treatment control is used as 100%
conditionsValuesNomalized = cellfun(@normalizeValues, conditionsValues,'UniformOutput', false);

%average using population arithmetics of choice: mean, median, mode

[conditionsValuesAvg, conditionsValuesSD] = populationStat(conditionsValuesNomalized, 'median');

%fit each data range to a sigmoidal curve

doseArrayValues = fitDose(conditionsValuesAvg);

%plot & save the dose array results
plotArray(doseArrayValues, 'pdf');
