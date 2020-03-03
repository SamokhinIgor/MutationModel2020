function [descriptionStr, figureStr] = prepareFigureStr( typeStr, ...
    typesDoubleVec, fileNameStr, folderPrefixStr)
    ss = textscan(fileNameStr,'%s','delimiter','\\');
    fileNameStr = ss{ end}{ end};
    labelStr = ['figure:system_base_', fileNameStr, '_', folderPrefixStr];
	switch typeStr
        case '$\log(\overline{ f})/\gamma$'
            descriptionStr = '�������� ������� � ����������� �� ���������� �������� ���������';
        case 'm'
            descriptionStr = '�������� ��������� ����������������� ������� � ������������ ��������� ���������� � ����������� �� ���������� �������� ���������';
        case 'd'
            descriptionStr = '�������� ������������ ��������� ������� ���������� ';
            if size( typesDoubleVec, 1) > 1
                descriptionStr = [ descriptionStr, '��� ����� � �������� ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            else
                descriptionStr = [ descriptionStr, '��� ���� � ������� ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            end
            descriptionStr = [ descriptionStr, ' � ����������� �� ���������� �������� ���������'];
        case 'u'
            descriptionStr = '����������� ��������� ';
            if size( typesDoubleVec, 1) > 1
                descriptionStr = [ descriptionStr, '����� � �������� ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            else
                descriptionStr = [ descriptionStr, '���� � ������� ', ...
                    strSupp( typesDoubleVec, '%5.0f', ', ')];
            end
            descriptionStr = [ descriptionStr, ' � ������������ ��������� ���������� � ����������� �� ���������� �������� ���������'];
        case 'qS'
            descriptionStr = '�������� ������� ���������� �� ������ �������� ���������';
        case 'qF'
            descriptionStr = '�������� ������� ���������� �� ��������� �������� ���������';
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
    descriptionStr = [descriptionStr, ' ������������ �� ���. \ref{', ...
        labelStr, '}. '];
end