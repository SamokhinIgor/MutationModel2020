function mainLoop()
%MAIN Summary of this function goes here
%   Detailed explanation goes here
% Calculate all examples for article
% main( nIter, mSumDouble, pDouble, nDimensions, dMaxDouble, ...
%     muDouble, indDMaxStart, indDMaxEnd, nDIteration,, myEpsDouble, ...
%     diagQMinDouble, nQIteration, nMIteration, isQTheFirst, ...
%     isM0Equals, folderPrefixStr)

% Article 2020. Model.
%     main( 40000, 1, 0.9, 4, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 0, 10000, 0, 0, 'ex1'); % example 1
%     main( 40000, 1, 0.9, 4, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 10000, 0, 1, 0, 'ex2'); % example 2
%     main( 40000, 1, 0.9, 4, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 10000, 0, 1, 1, 'ex3'); % example 3
%     main( 40000, 1, 0.9, 4, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 3000, 1000, 1, 1, 'ex4'); % example 4
%     main( 40000, 1, 0.9, 4, 0.1, 100, 16, 1, 10000, 0.0001, 0.6, 0, 10000, 0, 0, 'ex5'); % example 5
%     main( 40000, 1, 0.9, 4, 0.1, 100, 16, 1, 10000, 0.0001, 0.6, 10000, 0, 1, 0, 'ex6'); % example 6
%     main( 40000, 1, 0.9, 4, 0.1, 100, 16, 1, 4000, 0.0001, 0.6, 10000, 0, 1, 1, 'ex7'); % example 7
%     main( 40000, 1, 0.9, 4, 0.1, 100, 16, 1, 10000, 0.0001, 0.6, 3000, 1000, 1, 1, 'ex8'); % example 8
%     main( 40000, 1, 0.9, 4, 0.1, 50, 16, 1, 5000, 0.0001, 0.6, 0, 10000, 0, 0, 'ex9'); % example 9
%     main( 40000, 1, 0.9, 4, 0.1, 100, 16, 1, 4000, 0.0001, 0.6, 0, 10000, 0, 0, 'ex10'); % example 10
%     main( 40000, 1, 0.9, 4, 0.1, 200, 16, 1, 3000, 0.0001, 0.6, 0, 10000, 0, 0, 'ex11'); % example 11
%     main( 40000, 1, 0.9, 4, 0.1, 200, 16, 1, 2000, 0.0001, 0.6, 3000, 1000, 1, 1, 'ex12'); % example 12
    
% Article 2020. Algorithm.
%     main( 40000, 1, 0.9, 3, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 0, 10000, 0, 0, 'ex13'); % example 13
%     main( 40000, 1, 0.95, 3, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 10000, 0, 1, 1, 'ex14'); % example 14
    main( 40000, 1, 0.95, 3, 0.1, 100, 1, 1, 0, 0.0001, 0.6, 2000, 1000, 1, 1, 'ex15'); % example 15
    

end