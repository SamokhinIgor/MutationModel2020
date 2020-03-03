function [alphaDoubleVec, functionalDouble, uPopulationDoubleVec] = ...
    algorithm( nTypes, alphaDoubleVec, alphaSumDouble, QDoubleMatrix, ...
    KDoubleMatrix, KInverseDoubleMatrix, myEpsDoubleVec, zeroDoubleVec)
%MAIN Summary of this function goes here
%   Detailed explanation goes here
%     nIter - number of iterations
%     alphaSumDouble - sum of alpha_i
%     pDouble - probability for matrix coefficients
%     nDimensions - number of types
%     kMaxDouble - number of types
%     indKMax - index of dominant type. 1 <= indDMax <= 2 ^ nDimensions
%     muDouble - koefficient for death matrix
%   Run [alphaDoubleVec, functionalDouble] = main( 5000, 1, 0.97, 2, 0.1, 1, 2)

%     options = odeset('RelTol',1e-8,'AbsTol',1e-8);

    alphaDoubleVec = alphaDoubleVec * alphaSumDouble / ...
        sum( alphaDoubleVec);
    ADoubleMatrix = diag( alphaDoubleVec);
    QAlphaDoubleMatrix = QDoubleMatrix * ADoubleMatrix;
%         QSystemDoubleMatrix = QAlphaDoubleMatrix;
    eigUDoubleMatrix = KInverseDoubleMatrix * QAlphaDoubleMatrix;
    [ uDoubleVec, expSDouble] = eigs( eigUDoubleMatrix, 1);
%         [ uDoubleVec, expSDouble] = eigs( eigUDoubleMatrix, nTypes); % delete this
%         singlePickDouble = 3.340278966692738
    functionalDouble = log( expSDouble);
    uDoubleVec = uDoubleVec * functionalDouble / sum( uDoubleVec); % only for S functional
    if max( uDoubleVec > 20 * eps) * max( uDoubleVec < -20 * eps) == 1
        error('Wrong u eig vector!');
    elseif max( uDoubleVec < -20 * eps)
        uDoubleVec = - uDoubleVec;
    end
    uDoubleVec = max( zeroDoubleVec, uDoubleVec);
%         sum( uDoubleVec) - log( expSDouble) % check u distribution
%         alphaDoubleMatrix( :, i) = alphaDoubleVec; % save results
    uPopulationDoubleVec = uDoubleVec; % save results
%         functionalDoubleVec( i) = functionalDouble; % save results
%  check solution - all works correct
%         isnCorrect = QAlphaDoubleMatrix * uDoubleVec - expSDouble * ...
%             DDoubleMatrix * uDoubleVec;
%         [ ~, uODEDoubleMatrix] = ode45(@mySystem,[0 2000], ones( nTypes, 1),options);
%         uODEDoubleVec = uODEDoubleMatrix( end, :)'
%         fracDoubleVec = uDoubleVec ./ uODEDoubleVec
%%%%%%%%%%%%%%%%%%%%%%%%
    normUDouble = sum( KDoubleMatrix * uDoubleVec);
    uDoubleVec = uDoubleVec / normUDouble;
%         normUDouble = sum( KDoubleMatrix * uDoubleVec)
%         isCorrect = isequal( normUDouble, 1)

%         checkUNorm = sum( DDoubleMatrix * uDoubleVec)
    eigVDoubleMatrix = KInverseDoubleMatrix * (QAlphaDoubleMatrix');
%         QSystemDoubleMatrix = QAlphaDoubleMatrix';
    [ vDoubleVec, exp2SDouble] = eigs( eigVDoubleMatrix, 1);
    if max( vDoubleVec > 20 * eps) * max( vDoubleVec < -20 * eps) == 1
        error('Wrong v eig vector!');
    elseif max( vDoubleVec < -20 * eps)
        vDoubleVec = - vDoubleVec;
    end
    vDoubleVec = max( zeroDoubleVec, vDoubleVec);
%         disp( uDoubleVec ./ vDoubleVec); % find another solution?
    normVDouble = dot( KDoubleMatrix * uDoubleVec, vDoubleVec);
    vDoubleVec = vDoubleVec / normVDouble;

%         [ ~, vODEDoubleMatrix] = ode45(@mySystem,[0 2000], ones( nTypes, 1),options);
%         vODEDoubleVec = vODEDoubleMatrix( end, :)'
%         fracDoubleVec = vDoubleVec ./ vODEDoubleVec
%         
%         normVDouble = dot( KDoubleMatrix * uDoubleVec, vDoubleVec)
%         isCorrect = isequal( normVDouble, 1)
%         checkVNorm = dot( DDoubleMatrix * uDoubleVec, vDoubleVec)
    suppDoubleVec = QDoubleMatrix * vDoubleVec;
    rDoubleVec = suppDoubleVec .* uDoubleVec;
    rDoubleVec
%         disp( rDoubleVec');
    linprogDoubleMatrix = zeros( nTypes);
    linprogDoubleMatrix( 1, :) = 1;
    linprogDoubleVec = zeros( nTypes, 1);
    leftDoubleVec = max( -myEpsDoubleVec, -alphaDoubleVec);
%         if max( abs( alphaDeltaDoubleVec)) > 20 * eps
    alphaDeltaDoubleVec = linprog( -rDoubleVec, [], [], ...
        linprogDoubleMatrix, linprogDoubleVec, leftDoubleVec, ...
        myEpsDoubleVec);
%         disp( alphaDeltaDoubleVec');
    alphaDoubleVec = alphaDoubleVec + alphaDeltaDoubleVec;
%         end
%         pause( 0.1);
    
%     function dy = mySystem(t,y)
%         sDouble = sum( y);
%         dy = QSystemDoubleMatrix * y * exp( -sDouble)- KDoubleMatrix * y;
%     end
end
