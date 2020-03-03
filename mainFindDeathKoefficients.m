function mainFindDeathKoefficients()
%MAIN Summary of this function goes here
%   Detailed explanation goes here
% Calculate all examples
    muDouble = 0.1;
    alphaSumDouble = 7;
    firstElemDouble = 4;
    [alphaDoubleVec, ~] = main( 2, alphaSumDouble, 0.97, 2, 0.1, 1, ...
        muDouble);
    while alphaDoubleVec( 1) >= firstElemDouble - 0.0001  
        muDouble = muDouble + 0.1;
        [alphaDoubleVec, ~] = main( 2, alphaSumDouble, 0.97, 2, 0.1, 1, ...
            muDouble);
        disp( muDouble)
        disp( alphaDoubleVec')
    end
    disp( muDouble)
    disp( alphaDoubleVec')
        
    
end