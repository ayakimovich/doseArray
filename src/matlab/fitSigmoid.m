function [doseHalfMax, rSquare, fittingParams, x, y] = fitSigmoid(doseVector,effectVector)
%FITSIGMOID fits the effect vector and dose to a EC50 sigmoid curve
% uses nonlinear fit to a sigmoid equation with constant slope:
% y = bottom + (top - bottom)/(1 + 10^(LogEC50-X - HillSlope))
% for fitting to equation with a variable slope use fitSigmoidVarSlope
% function
%   input: doseVector,effectVector
%   output: doseHalfMax
% Note: 
% 1) x should not be log transformed, as it get's log transformed in the
% function
% 2) This equation assumes a vairable slope with Slopehill coefficient as a
% free parameter

if numel(doseVector) ~= numel(effectVector)
    error('for each dose an effect value is expected (and vice versa)');
end
%combine vectors
values = [effectVector;doseVector];

%specify fitting parameters

%fittingParams(1) - bottom
%fittingParams(2) - top
%fittingParams(3) - EC50
%fittingParams(4) - HillSlope
%(bottom + (top - bottom)/(1 + 10^(log10(EC50)-x - HillSLope))


modelFunction = @functionSigmoid;

fittingParams0 = ones(4,1);
fittingParams(1) = 0.1;
fittingParams(2) = 1.2;
%final transform vectors data vectors for fitting
x = values(2,:);
y = values(1,:);

%Set robust fitting options
opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';

%estimate if data is supposed to be fitted to a sigmoid,
%otherwise return 0
if checkSigmoidality(y)
else
   doseHalfMax = 0;
   rSquare = 0
   fittingParams = [];
   x = [];
   y = [];
   return;
end



%perform the fitting

% this function is depricated here
% [fittingParams,R,J,CovB,MSE,ErrorModelInfo] = ...
%     nlinfit(x,y,modelFunction,fittingParams0,opts);

% this function alloows boundry conditions
lowerBoundry = size(fittingParams0);
lowerBoundry(:) = 0;

upperBoundry = size(fittingParams0);
upperBoundry(2) = 2;


[fittingParams,resnorm,R] = lsqcurvefit(modelFunction, fittingParams0,x,y,lowerBoundry,upperBoundry);


%compute Rsquare from the obtained residuals R
rSquare = 1 - sum(R.^2) / sum((y - mean(y)).^2);

%Since fittingParams(3) is EC50 (or IC50 or LD50) return this value
if isreal(rSquare) && fittingParams(3) > 0
   doseHalfMax = fittingParams(3);
else
   doseHalfMax = 0;
   disp('Warning: failed to find dose');
end    

end

