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

