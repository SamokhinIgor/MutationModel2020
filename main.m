function main( nIter, mSumDouble, pDouble, nDimensions, dMaxDouble, ...
    muDouble, indDMaxStart, indDMaxEnd, nDIteration, myEpsDouble, ...
    diagQMinDouble, nQIteration, nMIteration, isQTheFirst, isM0Equals, ...
    folderPrefixStr)
%MAIN Summary of this function goes here
%   Detailed explanation goes here
%     nIter - maximum number of iterations
%     mSumDouble - sum of m_i
%     pDouble - probability for matrix coefficients
%     nDimensions - number of types
%     dMaxDouble - maximum coefficient for death matrix
%     muDouble - multiplicator for death matrix based on Hamming distance
%     indDMaxStart - index of dominant type at the beginning. 1 <= indDMax <= 2 ^ nDimensions
%     indDMaxEnd - index of dominant type after nDIteration. 1 <= indDMax <= 2 ^ nDimensions
%     nDIteration - number of iteration to linear changing in death matrix. nIter > nDIteration. nDIteration > 0 for death coefficients changing
%     myEpsDouble - eps for linprog problem
%     diagQMinDouble - limit for linprog problem. Diag elements of solution matrix Q must be > this value > 0
%     nQIterations - number of QDoubleMatrix calculation in loop
%     nMIterations - number of mDoubleVec calculation in loop
%     isQTheFirst - 1 for start with QDoubleMatrix calculation, 0 for start
%     with mDoubleVec calculation
%     isM0Equals - 1 for m0DoubleVec equals in all elements, 0 - for
%     maximum element in the first position and zeros to another.
%     folderPrefixStr - prefix to result folder.
%   Run main( 4000, 1, 0.9, 4, 0.1, 100, 1, 1, 0, 0.001, 0.6, 0, 1000, 0, 0, 'test')    

% initialize results
    nTypes = 2 ^ nDimensions;
    mDoubleMatrix = zeros( nTypes, nIter);
    QDoubleArray = zeros( nTypes, nTypes, nIter);
    uDoubleMatrix = zeros( nTypes, nIter);
    DDoubleMatrix = zeros( nTypes, nIter);
    solveFitnessDoubleVec = zeros( 1, nIter);
%     myEpsDouble = mSumDouble / nTypes/ 1000; % eps for linprog problem
%     myEpsEIGSDouble = eps; % eps for eigs calculation
    myEpsMDoubleVec = repmat( myEpsDouble, nTypes, 1); % limit for linprog problem
    myEpsQDoubleVec = repmat( myEpsDouble, nTypes * nTypes, 1); % limit for linprog problem
    myEpsApproxDouble = 20 * eps;
    myEpsQDoubleMatrix = eye( nTypes) * diagQMinDouble; % limit for linprog problem. Diag elements of solution must be > const > 0
% prepare data    
    close all;
    tic;
    [QDoubleMatrix, DDoubleMatrixStart] = getData( nDimensions, pDouble, ...
        dMaxDouble, indDMaxStart, muDouble);% download data
    [~, DDoubleMatrixEnd] = getData( nDimensions, pDouble, ...
        dMaxDouble, indDMaxEnd, muDouble);% download data
    DDoubleMatrixCurrent = DDoubleMatrixStart; % initialize
    DDeltaDoubleMatrix = (DDoubleMatrixEnd - DDoubleMatrixStart) / ...
        nDIteration; % initialize
    if min( diag( QDoubleMatrix)) < diagQMinDouble 
        error('Error. diagQMinDouble should be less than minimum initial diag element of matrix Q.');
    end
%     m0DoubleVec = (nTypes : - 1: 1)';
    if isM0Equals
        m0DoubleVec = ones( nTypes, 1) * mSumDouble / nTypes;
    else
        m0DoubleVec = [ 1; zeros( nTypes - 1, 1)];
    end
    m0DoubleVec = m0DoubleVec * mSumDouble / sum( m0DoubleVec); % normilize
    mDoubleVec = m0DoubleVec;
    mDeltaDoubleVec = myEpsMDoubleVec; % for loop exit condition
    QDeltaDoubleVec = myEpsMDoubleVec;
    iIter = 0;
    flag = 1;
    iQIteration = 0;
    iMIteration = 0;
    if (nQIteration == 0) && (nMIteration == 0) || (nQIteration < 0) ...
            || (nMIteration < 0)
        error('main.m : Wrong number of iterations!')
    end
    isQDoing = isQTheFirst;
    isQPrevDone = 1;
    linprogQDoubleMatrix = repmat( eye( nTypes), 1, nTypes); % sum_j q_ij = const
    linprogQDoubleVec = zeros( nTypes, 1); % sum_j delta q_ij = 0
    linprogMDoubleMatrix = ones( 1, nTypes); % sum m_i = const
    linprogMDoubleVec = 0; % sum delta m_i = 0
% make iteration
    while ((iIter < nIter) && flag) || (iIter < nDIteration)
        mDoubleVec = mDoubleVec * mSumDouble / sum( mDoubleVec); % make constraint about sum
        iIter = iIter + 1;
        if isQDoing
            flag = sum( abs( QDeltaDoubleVec)) > 100 * eps; % in the previous iteration did change QDoubleMatrix
            if ~flag
                iQIteration = nQIteration; % stop doing Q
            end
        else
            flag = sum( abs( mDeltaDoubleVec)) > 100 * eps; % in the previous iteration did change mDoubleVec
            if ~flag
                iMIteration = nMIteration; % stop doing M
            end
        end
        if flag
            isQPrevDone = 1;
        end
        if ~flag && isQPrevDone
            flag = 1;
            isQPrevDone = 0;
        end
        if (iQIteration == nQIteration) && (iMIteration == nMIteration)
            iQIteration = 0;
            iMIteration = 0;
        end
        mDiagDoubleMatrix = diag( mDoubleVec);
        QmDoubleMatrix = QDoubleMatrix * mDiagDoubleMatrix;
        eigUDoubleMatrix = (DDoubleMatrixCurrent ^ -1) * QmDoubleMatrix;
%         opts.tol = myEpsEIGSDouble; %% try this. Prerare for deleting
%         [ uDoubleVec, expSDouble] = eigs( eigUDoubleMatrix, 1, 'lr', opts); % find solution with fixed accuracy
        [ uDoubleVec, expSDouble] = eigs( eigUDoubleMatrix, 1);
        uSumDouble = log( expSDouble);
        uDoubleVec = uDoubleVec * uSumDouble / sum( uDoubleVec); % only for S functional
        uDoubleVec = correctApprox( uDoubleVec, myEpsApproxDouble);
        uPopulationDoubleVec = uDoubleVec;
%         fitnessDouble = mDoubleVec' * uPopulationDoubleVec;
%         sum( uDoubleVec) - log( expSDouble) % check u distribution
        mDoubleMatrix( :, iIter) = mDoubleVec; % save results
        uDoubleMatrix( :, iIter) = uPopulationDoubleVec; % save results
        QDoubleArray( :, :, iIter) = QDoubleMatrix; % save results
        DDoubleMatrix( :, iIter) = diag(DDoubleMatrixCurrent);
%         solveFitnessDoubleVec( iIter) = fitnessDouble; % save results
        solveFitnessDoubleVec( iIter) = uSumDouble; % save results
%  check solution - all works correct
%         isnCorrect = QmDoubleMatrix * uDoubleVec - expSDouble * ...
%             DDoubleMatrix * uDoubleVec;
%         norm1Double = sum( DDoubleMatrix * uDoubleVec);
        uDoubleVec = uDoubleVec / sum( DDoubleMatrixCurrent * uDoubleVec);
%         checkUNorm = sum( DDoubleMatrix * uDoubleVec)
        eigVDoubleMatrix = (DDoubleMatrixCurrent ^ -1) * (QmDoubleMatrix');
        [ vDoubleVec, exp2SDouble] = eigs( eigVDoubleMatrix, 1);
        vDoubleVec = correctApprox( vDoubleVec, myEpsApproxDouble);
%         disp( uDoubleVec ./ vDoubleVec); % find another solution?
        vDoubleVec = vDoubleVec / dot( DDoubleMatrixCurrent * uDoubleVec, ...
            vDoubleVec);
%         checkVNorm = dot( DDoubleMatrix * uDoubleVec, vDoubleVec)
        if isQTheFirst 
            if (iQIteration < nQIteration)
                isQDoing = 1;
            else
                isQDoing = 0;
            end
        else
            if (iMIteration < nMIteration)
                isQDoing = 0;
            else
                isQDoing = 1;
            end
        end    
        if isQDoing
% QDoubleMatrix variation
            iQIteration = iQIteration + 1;
            pDoubleMatrix = (mDiagDoubleMatrix * uDoubleVec) * vDoubleVec';
            pDoubleVec = pDoubleMatrix(:); % [q_11; q_21;, ...; q_n1; q_12; q_22; ...; q_n2; ...; q_1n; q_2n; ...; q_nn]
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            leftDoubleVec = max( -myEpsQDoubleVec, -(QDoubleMatrix(:) - myEpsQDoubleMatrix(:))); % diag elements of matrix must be greater than constant which is greater than zero
            QDeltaDoubleVec = linprog( -pDoubleVec, [], [], ...
                linprogQDoubleMatrix, linprogQDoubleVec, leftDoubleVec, ...
                myEpsQDoubleVec);
            QDeltaDoubleMatrix = reshape( QDeltaDoubleVec, nTypes, nTypes);
            QDoubleMatrix = QDoubleMatrix + QDeltaDoubleMatrix;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
% mDoubleVec variation
            iMIteration = iMIteration + 1;
            pDoubleVec = ( QDoubleMatrix') * vDoubleVec .* uDoubleVec;
            leftDoubleVec = max( -myEpsMDoubleVec, -mDoubleVec);
            mDeltaDoubleVec = linprog( -pDoubleVec, [], [], ...
                linprogMDoubleMatrix, linprogMDoubleVec, leftDoubleVec, ...
                myEpsMDoubleVec);
            mDoubleVec = mDoubleVec + mDeltaDoubleVec;
        end
    %         save('temp');
        if (iIter <= nDIteration)
            DDoubleMatrixCurrent = DDoubleMatrixCurrent + DDeltaDoubleMatrix;
        end
    end
    iterDoubleVec = 1 : iIter; % iteration vector
    mDoubleMatrix = mDoubleMatrix( :, 1 : iIter); % decrease size
    uDoubleMatrix = uDoubleMatrix( :, 1 : iIter); % decrease size
    DDoubleMatrix = DDoubleMatrix( :, 1 : iIter); % decrease size
    solveFitnessDoubleVec = solveFitnessDoubleVec( 1 : iIter); % decrease size
    QDoubleArray = QDoubleArray( :, :, 1 : iIter); % decrease size
%     disp( mDoubleVec);
%     isError = max(diff( solveFunctionalDoubleVec) < 0);
%     disp( isError);

%     isDeath = max(diff( sum( uDoubleMatrix, 1)) < -myEpsApproxDouble); % our population decrease

%     if isError
%         error( 'Population wants to die. For example, you should choose less death coefficients');
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%    
% create directory
    dirStr = myMakeDir( iIter, mSumDouble, isM0Equals, pDouble, ...
        nDimensions, dMaxDouble, indDMaxStart, diagQMinDouble, ...
        nQIteration, nMIteration, isQTheFirst, folderPrefixStr);
%     dirStr = myMakeDir( iIter, mSumDouble, m0DoubleVec, pDouble, ...
%         nDimensions, dMaxDouble, indDMax, nQIteration, nMIteration, ...
%         isQTheFirst, isDeath);
    fileStr = [dirStr, '\result ', ...
        num2str( solveFitnessDoubleVec( end)), ...
        ' ', strSupp( fix(clock())', '%d', ' ')];
    fileStr(  fileStr == '.') = ',';
    fileStr = [fileStr, '.mat'];
    figStr = [dirStr, '\', 'f_'];
    movieStr = [dirStr, '\', 'm_MUTQ'];
    save(fileStr);
% plot results
    resultTextStr = generateDescription( nQIteration, ...
        nMIteration, nDimensions, nTypes, diagQMinDouble, mDoubleMatrix, ...
        pDouble, myEpsDouble, nDIteration, DDoubleMatrix, uDoubleMatrix, ...
        solveFitnessDoubleVec, iterDoubleVec);
    [descriptionsPlotStr, figuresPlotStr] = myPlotFunc( mDoubleMatrix, ...
        uDoubleMatrix, DDoubleMatrix, solveFitnessDoubleVec, ...
        iterDoubleVec, figStr, folderPrefixStr);
    [descriptionsMovieStr, figuresMovieStr] = myMovieFunc( QDoubleArray, ...
        movieStr, folderPrefixStr);
    resultTextStr = [resultTextStr, '\par ', descriptionsPlotStr, ...
        descriptionsMovieStr, newline, ...
        figuresPlotStr, figuresMovieStr];
    disp( resultTextStr);
    save(fileStr);
    toc;
end

function resultTextStr = generateDescription( nQIteration, ...
    nMIteration, nDimensions, nTypes, diagQMinDouble, mDoubleMatrix, ...
    pDouble, myEpsDouble, nDIteration, DDoubleMatrix, uDoubleMatrix, ...
    solveFitnessDoubleVec, iterDoubleVec)
    resultTextStr = '\par Вариация ';
    if nQIteration > 0
        resultTextStr = [resultTextStr, 'матрицы репликаций'];
        if nMIteration > 0
            resultTextStr = [resultTextStr, ' и ландшафта приспособленности. Алгоритм поочередно делает ', ...
                num2str( nQIteration), ' итераций для матрицы репликаций и ', ...
                num2str( nMIteration), ' итераций для ландшафта приспособленности, если изменения увеличивают значение фитнеса'];
        end
    else
        resultTextStr = [resultTextStr, 'ландшафта приспособленности'];
    end
    if nDIteration > 0
        resultTextStr = [resultTextStr, '. Алгоритм проводится с учетом линейного изменения матрицы смертности'];
    end
    [~, indDMin] = min(DDoubleMatrix( :, 1));
    resultTextStr = [resultTextStr, '. Длина цепочки $l = ', ...
        num2str( nDimensions), ...
        '$, т.е. $n = ', num2str( nTypes), ...
        '$. Пусть $\gamma = 1$, $\check{q} = ', num2str( diagQMinDouble, 3), ...
        '$, $m_0 = $(', strSupp( mDoubleMatrix( :, 1), 4, ', '), ...
        '), $p = ', num2str( pDouble, 3), ...
        '$, $\varepsilon = ', num2str( myEpsDouble, '%8.4f'), ...
        '$, вид номер ', num2str( indDMin), ...
        ' является "диким"'];
    if nDIteration <= 0
        resultTextStr = [resultTextStr, '. $D = diag$(', strSupp( DDoubleMatrix( :, 1), 2, ', '), ...
        '). Полное изменение '];
    else
        resultTextStr = [resultTextStr, '. В начальный момент времени матрица смертности $D = diag$(', strSupp( DDoubleMatrix( :, 1), 2, ', '), ...
        '). Через ', num2str( nDIteration), ' итераций алгоритма матрица смертности $D = diag$(', strSupp( DDoubleMatrix( :, end), 2, ', '), ...
        '). Полное изменение '];
    end
    if nQIteration > 0
        resultTextStr = [resultTextStr, 'матрицы репликации '];
        if nMIteration > 0
            resultTextStr = [resultTextStr, 'и ландшафта приспособленности '];
        end
    else
        resultTextStr = [resultTextStr, 'ландшафта приспособленности '];
    end
    resultTextStr = [resultTextStr, 'завершилось за ', ...
        num2str( iterDoubleVec (end)), ...
        ' итераций алгоритма. До изменений численности популяций в стационарном положении равновесия распределены следующим образом: (', ...
        strSupp( uDoubleMatrix(:, 1), '%7.4f', ', '), ...
        '), что соответствует значению фитнеса $S = ', num2str( solveFitnessDoubleVec( 1), 4), ...
        '$. После изменений '];
    if nMIteration > 0
        [~, indMaxM] = max( mDoubleMatrix( :, end));
        resultTextStr = [ resultTextStr, 'вид номер ', ...
            num2str( indMaxM), ...
            ' получил преимущество ландшафта приспособленности $m = $(', ...
            strSupp( mDoubleMatrix( :, end), '%7.0f', ', '), '), '];
    end
    resultTextStr = [ resultTextStr, 'численности популяции в стационарном положении равновесия распределились следующим образом (', ...
        strSupp( uDoubleMatrix(:, end), '%7.4f', ', '), ...
        '), что соответствует значению фитнеса $S = ', num2str( solveFitnessDoubleVec( end), 4), '$.', newline];
end

function [dir_str] = myMakeDir( nIter, mSumDouble, isM0Equals, pDouble, ...
    nDimensions, dMaxDouble, indDMax, diagQMinDouble, ...
    nQIteration, nMIteration, isQTheFirst, folderPrefixStr) %, isDeath)
%     dir_str = 'data';
%     [ ~, ~, ~] = mkdir(dir_str);
%     if isDeath
%         dir_str = [dir_str, '\death'];
%     else
%         dir_str = [dir_str, '\life'];
%     end
%     [ ~, ~, ~] = mkdir(dir_str);
    nDimensionsStr = num2str( nDimensions);
    diagQMinDoubleStr = num2str( diagQMinDouble);
%     dir_str = [dir_str, '\nDim', nDimensionsStr];
    dir_str = ['nDim', nDimensionsStr, ' diagQMin', diagQMinDoubleStr];
    dir_str(  dir_str == '.') = ',';
    [ ~, ~, ~] = mkdir(dir_str);
    nIterStr = num2str( nIter);
    mSumDoubleStr = num2str( mSumDouble);
    isM0EqualsStr = num2str( isM0Equals');
    flag = 1;
    while flag
        nBefore = length( isM0EqualsStr);
        isM0EqualsStr = strrep( isM0EqualsStr, '  ', ' ');
        nAfter = length( isM0EqualsStr);
        flag = nAfter < nBefore;
    end
    pDoubleStr = num2str( pDouble);
    dMaxDoubleStr = num2str( dMaxDouble);
    indDMaxStr = num2str( indDMax);
    nQStr = num2str( nQIteration);
    nMStr = num2str( nMIteration);
    isQTheFirstStr = num2str( isQTheFirst);
    dir_str = [dir_str, '\', folderPrefixStr, ' nIt', nIterStr, ' mSum', mSumDoubleStr, ...
        ' isM0Equals', isM0EqualsStr, ' p', pDoubleStr, ' dMax', dMaxDoubleStr, ...
        ' indDMax', indDMaxStr, ' nQ', nQStr, ' nM', nMStr, ...
        ' isQ', isQTheFirstStr];
    dir_str(  dir_str == '.') = ',';
    [ ~, ~, ~] = mkdir(dir_str);
end

function myDoubleVec = correctApprox(myDoubleVec, myEpsApproxDouble)
    isSmall = (myDoubleVec <= myEpsApproxDouble) .* ...
        (myDoubleVec >= -myEpsApproxDouble);
    isSmall = logical( isSmall);
    myDoubleVec( isSmall) = 0;
    if max( myDoubleVec > myEpsApproxDouble) * ...
            max( myDoubleVec < -myEpsApproxDouble) == 1
        error('Wrong eig vector!');
    elseif max( myDoubleVec < 0)
        myDoubleVec = - myDoubleVec;
    end
    myDoubleVec = max( 0, myDoubleVec); 
end