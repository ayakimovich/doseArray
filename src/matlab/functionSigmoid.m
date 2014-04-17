function output = functionSigmoid(fittingParams, x)
%FUNCTIONSIGMOID constant slope sigmoid function implementation
%fittingParams(1) - bottom
%fittingParams(2) - top
%fittingParams(3) - EC50
%fittingParams(4) - SlopeHill
% y = bottom + (top - bottom)/(1 + 10^(LogEC50-X-SlopeHill))

output = fittingParams(1) + (fittingParams(2) - fittingParams(1))...
    ./...
    (1 + 10.^((log10(fittingParams(3)) - x) - fittingParams(4)));

end

