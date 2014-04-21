function criteria = checkSigmoidality(y)
%CHECKINHIBITION check whether data vector y satisfy the
%sigmoidality criteria. Sigmoidality criteria here is:
% minimum value should be lower than 50% of the maximum
%   input: data vector y
%   output: boolean yes/no
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

if min(y) < 0.5*max(y)
    criteria = 1;
else
    criteria = 0;
end

end

