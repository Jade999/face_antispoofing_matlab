function P = whiten(P,G)

        [imrow imcol nfreq] = size(P);
        [frow fcol ~] = size(G);
        
        [xp yp] = meshgrid(1:fcol, 1:frow);
        pp = [xp(:) yp(:)];
        dd = dist(pp,pp');
        C = 0.9.^dd;
%         C = eye(size(C));

        % Form 2-D matrix operators M
        G = reshape(G, [frow*fcol nfreq]);
        M = G.';      
                
        % Compute whitening transformation matrix V
        D = M*C*M';
        A = diag( ones(1,nfreq) + (nfreq-1 :-1: 0)*1e-6 );
        [~,~,V] = svd(A*D*A);
        
        % Reshape frequency response     
        P = reshape(P , [imrow*imcol nfreq]);        
        P =(V.' * P.').';  
        
        % undo reshape
        P = reshape(P, [imrow imcol nfreq]);  

end