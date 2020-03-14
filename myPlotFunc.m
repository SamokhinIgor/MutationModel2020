function [descriptionsStr, figuresStr] = myPlotFunc( mDoubleMatrix, ...
    uDoubleMatrix, DDoubleMatrix, solveFitnessDoubleVec, iterDoubleVec, ...
    fileStr, folderPrefixStr)
%MY_PLOT_FUNC Summary of this function goes here
%   Detailed explanation goes here
%     nIter = size( mDoubleMatrix, 2);
%     nPoints = min( 500, nIter);
%     stepInt = nIter / nPoints;
%     pointsVec = 1 : stepInt : nIter;
%     mDoubleMatrix = mDoubleMatrix( :, pointsVec);
%     uDoubleMatrix = uDoubleMatrix( :, pointsVec);
%     solveFunctionalDoubleVec = solveFunctionalDoubleVec( :, pointsVec);
%     iterDoubleVec = iterDoubleVec( :, pointsVec);
%   Output:
%     resultTextStr - text to article.
    iFig = 1; % the first figure number
    isMMainVec = max( mDoubleMatrix, [], 2) > max( max( mDoubleMatrix)) / 2;
    isUMainVec = max( uDoubleMatrix, [], 2) > max( max( uDoubleMatrix)) / 2.5;
    isMainVec = isMMainVec | isUMainVec;
    isAnotherVec = ~ isMainVec;
    nTypes = size( mDoubleMatrix, 1);
    indVec = 1 : nTypes;
    indMainVec = indVec( isMainVec);
    indAnotherVec = indVec( isAnotherVec);
    [ uMainDoubleMatrix, uAnotherDoubleMatrix] = plotDivider( ...
        uDoubleMatrix, isMainVec);
    [ iFig, descriptionsStr, figuresStr] = myPlotFuncSupp( iFig, ...
        iterDoubleVec, solveFitnessDoubleVec, 'Iteration', ...
        '$\log(\overline{ f})/\gamma$', [ fileStr, 'MUTfitness'], ...
        folderPrefixStr);
    [ iFig, descriptionStr, figureStr] = myCumsumFill( iFig, ...
        iterDoubleVec, mDoubleMatrix, 'Iteration', 'm', ...
        [fileStr, 'MUTm'], folderPrefixStr);
    descriptionsStr = [ descriptionsStr, descriptionStr];
    figuresStr = [ figuresStr, figureStr];
    [ iFig, descriptionStr, figureStr] = myFill( iFig, iterDoubleVec, ...
        uMainDoubleMatrix, 'Iteration', 'u', indMainVec, ...
        [fileStr, 'MUTUMain'], folderPrefixStr);
    descriptionsStr = [ descriptionsStr, descriptionStr];
    figuresStr = [ figuresStr, figureStr];
    if ~isempty( uAnotherDoubleMatrix)
        [ iFig, descriptionStr, figureStr] = myFill( iFig, ...
            iterDoubleVec, uAnotherDoubleMatrix, 'Iteration', 'u', ...
            indAnotherVec, [fileStr, 'MUTUAnother'], folderPrefixStr);
        descriptionsStr = [ descriptionsStr, descriptionStr];
        figuresStr = [ figuresStr, figureStr];
    end
    if ~isequal(DDoubleMatrix( :, 1), DDoubleMatrix( :, end))
        [ iFig, descriptionStr, figureStr] = myFill( iFig, iterDoubleVec, ...
            DDoubleMatrix, 'Iteration', 'd', indVec, ...
            [fileStr, 'D'], folderPrefixStr);
        descriptionsStr = [ descriptionsStr, descriptionStr];
        figuresStr = [ figuresStr, figureStr];
    end
    pause(0.00001);
end

function [ iFig, descriptionStr, figureStr] = myPlotFuncSupp( iFig, ...
    xVec, yVec, xStr, yStr, fileName, folderPrefixStr)
    xLimits = [ min( xVec), max( xVec)];
    yLimits = [ min( [yVec, 0]), max( yVec)];
    [f, iFig] = createNewFigure( iFig); % only 1 function in legend
    plot(xVec, yVec, '-k', 'LineWidth', 2);
    xlabel(xStr, 'Interpreter', 'Latex'); 
    ylabel(yStr, 'Interpreter', 'Latex'); 
    xLimits =  figure_lim_supp( xLimits);
    xlim(xLimits);
    yLimits =  figure_lim_supp( yLimits);
    ylim(yLimits);
    saveas( f, fileName, 'pdf');
    saveas( f, fileName, 'jpg');
    saveas( f, fileName, 'm');
    saveas( f, fileName, 'eps');

    
    [descriptionStr, figureStr] = prepareFigureStr( yStr, ...
        [], fileName, folderPrefixStr);
end

function [ uMainDoubleMatrix, uAnotherDoubleMatrix] = plotDivider( ...
    uDoubleMatrix, indMainVec)
    nTypes = size( uDoubleMatrix, 1);
    uMainDoubleMatrix = uDoubleMatrix;
    uAnotherDoubleMatrix = uDoubleMatrix;
    for i = nTypes : -1 : 1
        if indMainVec( i)
            uAnotherDoubleMatrix( i, :) = [];
        else
            uMainDoubleMatrix( i, :)  = [];
        end
    end
end
% 
function [ iFig, descriptionStr, figureStr] = myFill( iFig, xDoubleVec, ...
    rowsDoubleMatrix, xStr, yStr, indPlotVec, fileName, folderPrefixStr)
    descriptionStr = '';
    figureStr = '';
    xLimits = [ min( xDoubleVec), max( xDoubleVec)];
    nTypes = size(rowsDoubleMatrix, 1);
    maxRowElementDoubleVec = max( abs( rowsDoubleMatrix), [], 2);
    if isequal(yStr, 'm')
        indGood = ones( size( maxRowElementDoubleVec));
    else
        indGood = maxRowElementDoubleVec > max( maxRowElementDoubleVec) ...
            / 8;
    end
    for j = 1 : 2 % plot all
        nActiveTypes = sum( indGood);
        if nActiveTypes > 0 % is something to plot
            [f, iFig] = createNewFigure( iFig);
            for i = 1 : nTypes
                if indGood( i)
                    yIStr = [yStr, '_{', num2str( indPlotVec(i)), '}'];
                    colorDoubleVec = sum( indGood( 1 : i)) / (nActiveTypes + 1) ...
                        * ones( 1, 3);
                    plot( xDoubleVec, rowsDoubleMatrix( i, :), 'Color', ...
                        colorDoubleVec, 'DisplayName', yIStr, 'LineWidth', 2);
                end
            end
            xLimits =  figure_lim_supp( xLimits);
            xlim(xLimits);
            yLimits = [ 0, max( max( rowsDoubleMatrix(indGood >= 1, :)))];
            yLimits =  figure_lim_supp( yLimits);
            ylim(yLimits);
            lngd = legend('show');
            set(lngd, 'Position', [0.8,0.25,0.05,0.6]);
            xlabel(xStr, 'Interpreter', 'Latex');
            ylabel(yStr, 'Interpreter', 'Latex');
            saveas( f, fileName, 'pdf');
            saveas( f, fileName, 'jpg');
            saveas( f, fileName, 'm');
            saveas( f, fileName, 'eps');
            [descriptionSuppStr, figureSuppStr] = prepareFigureStr( yStr, ...
                indPlotVec( indGood)', fileName, folderPrefixStr);
            descriptionStr = [ descriptionStr, descriptionSuppStr];
            figureStr = [ figureStr, figureSuppStr];
            indGood = ~indGood; % prepare to plot small values
            fileName = [fileName, 'Low']; % change fileName to plot small values
        end
    end
end

function [ iFig, descriptionStr, figureStr] = myCumsumFill( iFig, ...
    xDoubleVec, rowsDoubleMatrix, xStr, yStr, fileName, folderPrefixStr)
    fileName = [fileName, '_cumsum'];
    xLimits = [ min( xDoubleVec), max( xDoubleVec)];
    nSize = size(rowsDoubleMatrix, 2);
    nTypes = size(rowsDoubleMatrix, 1);
    cumsumDoubleMatrix = cumsum( rowsDoubleMatrix, 1);
    cumsumDoubleMatrix = [ zeros( 1, nSize); cumsumDoubleMatrix];
    yForwardDoubleMatrix = cumsumDoubleMatrix( 1 : end - 1, :);
    yBackDoubleMatrix = cumsumDoubleMatrix( 2 : end, end : -1 : 1);
    yDoubleMatrix = [ yForwardDoubleMatrix, yBackDoubleMatrix];
    yDoubleMatrix = yDoubleMatrix';
    xForwardDoubleMatrix = repmat( xDoubleVec, nTypes, 1);
    xDoubleMatrix = [ xForwardDoubleMatrix, ...
        xForwardDoubleMatrix( :, end : -1 : 1)];
    xDoubleMatrix = xDoubleMatrix';
    [f, iFig] = createNewFigure( iFig);
    maxRowElementDoubleVec = max( abs( rowsDoubleMatrix), [], 2);
    if nTypes < 10 && ~isequal(yStr, 'm')
        indGood = ones( size( maxRowElementDoubleVec));
    else
        indGood = maxRowElementDoubleVec > max( maxRowElementDoubleVec) ...
            / 100;
    end
    nActiveTypes = sum( indGood);
    for i = nTypes : -1 : 1
        if indGood( i) 
            yIStr = [yStr, '_{', num2str( i), '}'];
            colorDoubleVec = sum( indGood( 1 : i)) / (nActiveTypes + 1) ...
                * ones( 1, 3);
            fill( xDoubleMatrix( :, i), yDoubleMatrix( :, i),  ...
                colorDoubleVec, 'DisplayName', yIStr);
            indGood( i) = i;
        else
            indGood( i) = [];
        end
    end
    xLimits =  figure_lim_supp( xLimits);
    xlim(xLimits);
    yLimits = [ 0, max( max( cumsumDoubleMatrix))];
    yLimits =  figure_lim_supp( yLimits);
    ylim(yLimits);
    lngd = legend('show');
    set(lngd, 'Position', [0.8,0.25,0.05,0.6]);
    xlabel(xStr, 'Interpreter', 'Latex');
    ylabel(yStr, 'Interpreter', 'Latex'); 
    saveas( f, fileName, 'pdf');
    saveas( f, fileName, 'jpg');
    saveas( f, fileName, 'm');
    saveas( f, fileName, 'eps');
    [descriptionStr, figureStr] = prepareFigureStr( yStr, ...
        indGood, fileName, folderPrefixStr);
end

function [f, iFig] = createNewFigure( iFig)
    f = figure(iFig);
    clf( f);
    hold on;
    iFig = iFig + 1;
    set( f,'color',[1 1 1]);
end