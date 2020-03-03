function [descriptionsStr, figuresStr] = myMovieFunc( QDoubleArray, ...
    fileStr, folderPrefixStr)
%MY_MOVIE_FUNC Summary of this function goes here
%   Detailed explanation goes here
%   Save in file
    f = figure();
    %axis tight manual
    %ax = gca;
    %ax.NextPlot = 'replaceChildren';
    loops = size( QDoubleArray, 3);
    v = VideoWriter([fileStr, '.avi']);
    open(v);
    for j = [1 : max( 20, floor(loops(end) / 500)) : loops, loops( end)]
        Z = QDoubleArray(:, :, j);
        bar3(Z);
        xlabel('$j$', 'Interpreter', 'Latex'); 
        ylabel('$i$', 'Interpreter', 'Latex'); 
        zlabel(['$q_{ij}$ in ', num2str(j), ' iteration'], 'Interpreter', 'Latex'); 
        zlim([-0.005, 1.005]);
        drawnow
        frame = getframe(f);
        writeVideo(v,frame);
        if j == 1
            figStr = [fileStr, 'S'];
            saveas( f, figStr, 'pdf');
            saveas( f, figStr, 'eps');
            [descriptionsStr, figuresStr] = prepareFigureStr( 'qS', ...
                [], figStr, folderPrefixStr);
        end
    end
    figStr = [fileStr, 'F'];
    saveas( f, figStr, 'pdf');
    saveas( f, figStr, 'eps');
    [descriptionStr, figureStr] = prepareFigureStr( 'qF', ...
        [], figStr, folderPrefixStr);
    close(v);
    descriptionsStr = [ descriptionsStr, descriptionStr];
    figuresStr = [ figuresStr, figureStr];
    pause(0.00001);
end