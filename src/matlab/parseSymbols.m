function stringOut = parseSymbols(stringIn, mode, prefix)
%PARSESYMBOLS substitutes following symbols in either 'forward' or
%'backward' mode to make a string compatible with either file name or a 
% struct array handle:
%   Detailed explanation goes here
%' '<->'_'
%','<->'--'
%':'<->'__'
%'.'<->'-'

if nargin < 1
   error ('Provide at least a string to parse in the argument');
end
if nargin < 2
   mode = 'forward';
end
if nargin < 3
   prefix = '';
end

switch mode
    case 'forward'
        stringIn = strrep(stringIn, ':', '__');
        stringIn = strrep(stringIn, ',', '--');
        stringIn = strrep(stringIn, ' ', '_');
        stringIn = strrep(stringIn, '.', '-');
        stringIn = strcat(prefix, stringIn);
    case 'backward'
        stringIn = strrep(stringIn, prefix, '');
        stringIn = strrep(stringIn, '__', ':');
        stringIn = strrep(stringIn, '--', ',');
        stringIn = strrep(stringIn, '_', ' ');
        stringIn = strrep(stringIn, '-', '.');
end
stringOut = stringIn;
end

