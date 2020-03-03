function outLimitsVec =  figure_lim_supp( inLimitsVec)
%figure_lim_supp Summary of this function goes here
% DESCRIPTION
% Make limits more nice. Just for better visualization
% Input: 
% inLimitsVec - axis limits to correct
% Output: 
% outLimitsVec - corrected limits

% Copyright: Samokhin Igor // samokhin.igor@cs.msu.su // 30.04.2016

    inBonusDouble = ( inLimitsVec( 2) - inLimitsVec( 1) + 20 * eps) / 40;
    outLimitsVec( 1) = inLimitsVec( 1) - inBonusDouble;
    outLimitsVec( 2) = inLimitsVec( 2) + inBonusDouble;
end