function [QDoubleMatrix, DDoubleMatrix] = getData( nDimensions, pDouble, ...
    dMaxDouble, indDMax, muDouble)
% GET_DATA Summary of this function goes here
% Detailed explanation goes here
    nTypes = 2 ^ nDimensions;
    allDoubleVec = 0 : nTypes - 1; % all type numbers
    elemDoubleMatrix = decimalToBinaryVector( allDoubleVec);
    distDoubleMatrix = zeros( nTypes); % initialize dist matrix
    for i = 1 : nTypes
        for j = 1 : nTypes
            subDoubleVec = elemDoubleMatrix( i, :) - ...
                elemDoubleMatrix( j, :); % substract binary vectors
            subDoubleVec = abs( subDoubleVec); % absolute values
            distDoubleMatrix( i, j) = sum( subDoubleVec); % sum differences
        end
    end
    QDoubleMatrix = pDouble .^ ( nDimensions - distDoubleMatrix) .* ...
        ( 1 - pDouble) .^ distDoubleMatrix;
    distVec = distDoubleMatrix( indDMax, :);
    d0DiagDoubleVec = dMaxDouble ./ ( 4 * ( 1 + muDouble * nTypes) .* ...
        ( 2 - distVec / nTypes));
    coefDouble = 4;
    kDiagDoubleVec = dMaxDouble * ( 1 - ...
        1 / ( 2 * coefDouble* ( 1 + muDouble * nTypes))) ./ ...
        ( 1 + muDouble * distVec);
    dDiagDoubleVec = d0DiagDoubleVec + kDiagDoubleVec;
%     dOldDiagDoubleVec = dMaxDouble ./ ( 1 + muDouble .* distVec);
    DDoubleMatrix = diag( dDiagDoubleVec);
end