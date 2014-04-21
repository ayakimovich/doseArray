function criteria = checkSigmoidality(y)
%CHECKINHIBITION check whether data vector y satisfy the
%sigmoidality criteria. Sigmoidality criteria here is:
% minimum value should be lower than 50% of the maximum
%   input: data vector y
%   output: boolean yes/no
if min(y) < 0.5*max(y)
    criteria = 1;
else
    criteria = 0;
end

end

