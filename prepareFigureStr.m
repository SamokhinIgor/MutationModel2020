function [descriptionStr, figureStr] = prepareFigureStr( typeStr, ...
    typesDoubleVec, fileNameStr, folderPrefixStr)
    ss = textscan(fileNameStr,'%s','delimiter','\\');
    fileNameStr = ss{ end}{ end};
    labelStr = ['figure:system_base_', fileNameStr, '_', folderPrefixStr];
	switch typeStr
        case '$\log(\overline{ f})/\gamma$'
            descriptionStr = '«начени€ фитнеса в зависимости от количества итераций алгоритма';
        case 'm'
            descriptionStr = '«начени€ ландшафта приспособленности системы в стационарном положении равновеси€ в зависимости от количества итераций алгоритма';
        case 'd'
            descriptionStr = '«начени€ диагональных элементов матрицы смертности ';
            if size( typesDoubleVec, 1) > 1
                descriptionStr = [ descriptionStr, 'дл€ видов с номерами ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            else
                descriptionStr = [ descriptionStr, 'дл€ вида с номером ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            end
            descriptionStr = [ descriptionStr, ' в зависимости от количества итераций алгоритма'];
        case 'u'
            descriptionStr = '„исленности попул€ции ';
            if size( typesDoubleVec, 1) > 1
                descriptionStr = [ descriptionStr, 'видов с номерами ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            else
                descriptionStr = [ descriptionStr, 'вида с номером ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            end
            descriptionStr = [ descriptionStr, ' в стационарном положении равновеси€ в зависимости от количества итераций алгоритма'];
        case 'qS'
            descriptionStr = 'Ёлементы матрицы репликации на первой итерации алгоритма';
        case 'qF'
            descriptionStr = 'Ёлементы матрицы репликации на последней итерации алгоритма';
        otherwise
            error('Check myPlotFunc.m');
    end
    figureStr = ['\begin{figure}[htp]', newline, ...
        '  \begin{center}', newline, ...
        '    \includegraphics[width = 0.6\textwidth]{pictures/EasyQMD/', ...
        folderPrefixStr, '/', fileNameStr, '.eps}', newline, ...
        '    \caption{', descriptionStr, '}', newline, ...
        '    \label{', labelStr, '}', newline, ...
        '  \end{center}', newline, ...
      '\end{figure}', newline];
    descriptionStr = [descriptionStr, ' представлены на рис. \ref{', ...
        labelStr, '}. '];
end