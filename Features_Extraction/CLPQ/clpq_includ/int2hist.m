function h = int2hist(X, qlev, nbins)

    [row col n] = size(X); 

    if ~exist('qlev','var') || isempty(qlev)
        qlev = 4;
    end
    
    if ~exist('nbins','var')
        nbins = qlev^n;
    end
    
    
    X = floor(X);
    X = reshape(X, row*col, n);
    
    X =  bsxfun(@times, X, qlev.^(0:n-1));
    X = sum(X,2);
    
    bins = linspace(0, qlev^n-1, nbins);
    h = histc(X(:), bins);
    h = h / sum(h(:));
end