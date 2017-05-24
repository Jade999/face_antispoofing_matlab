function featuresDense = Extract_SURF_Image(im,step)
[nRows, nCols] = size(im);
colInd = (1 : step : nCols)';
rowInd = (1 : step : nRows)';
[A, B] = meshgrid(colInd, rowInd);
 densePoints = [A(:) B(:)];
[featuresDense, validPointsDense] = extractFeatures(im, densePoints, 'Method', 'SURF','Upright',true);
end

