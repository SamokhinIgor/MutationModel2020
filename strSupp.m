function var_str = strSupp( varVec, formatStr, delimiterStr)
% Generate text from Vector with special format and delimiter.
    nSize = size( varVec, 1);
    var_str = [];
    if nSize >= 1
        var_str = num2str( varVec( 1), formatStr);
    end
    for i = 2 : nSize
        var_str = [var_str, delimiterStr, num2str( varVec( i), formatStr)];
    end
end