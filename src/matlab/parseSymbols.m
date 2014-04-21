function stringOut = parseSymbols(stringIn, mode, prefix)
%PARSESYMBOLS substitutes following symbols in either 'forward' or
%'backward' mode to make a string compatible with either file name or a 
% struct array handle:
%   Detailed explanation goes here
%':'<->'_l_'
%','<->'_o_'
%' '<->'_s_'
%'.'<->'_d_'
%'-'<->'_a_'

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
        stringIn = strrep(stringIn, ':', '_l_');
        stringIn = strrep(stringIn, ',', '_o_');
        stringIn = strrep(stringIn, ' ', '_s_');
        stringIn = strrep(stringIn, '.', '_d_');
        stringIn = strrep(stringIn, '-', '_a_');
        stringIn = strcat(prefix, stringIn);
    case 'backward'
        stringIn = strrep(stringIn, prefix, '');
        stringIn = strrep(stringIn,'_l_', ':');
        stringIn = strrep(stringIn,'_o_', ',');
        stringIn = strrep(stringIn,'_s_', ' ');
        stringIn = strrep(stringIn,'_d_', '.');
        stringIn = strrep(stringIn,'_a_', '-');
end
stringOut = stringIn;
end

