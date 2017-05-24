
function [PQ P] = clpq (mask,varargin)        

    [Z width level window umax vmax mode decorr split binv zeroterm axis] = parse_input(varargin{:});

if ~exist('mask','var') || isempty(mask)
    mask = [4 7 8 9];
end
    
    % force window size to be an odd scalar
    width = width + ~mod(width,2);
    
    
    % convert image into lum-chr format if needed. If there are two
    % color channels, the image is assumed to be already in IZ format. If
    % there is only one color channel, it is assumed to be only lum (i.e.
    % grayscale), or only chr (only one complex chrominance channel)

    if size(Z,3)==3
       Z = rgb2lc(Z, axis);
    end
    
    
    % create a 2D window by tensor-product of the 1D window, if necessary
    if isvector(window)
        window = window(:)*window(:).';
    end
    
      
    [u v] = meshgrid(-umax:umax , -(-vmax:vmax));
    u = u(:);
    v = v(:);

    nfreq = length(mask);    
    r = floor(width/2);
    range = 2*pi*(-r:r)/width;
    [X Y] = meshgrid(range, -range);    
    
    P=[];
    G=[];

    for c = 1:size(Z,3)
        for i = 1:nfreq
            kx = u(mask(i));
            ky = v(mask(i));
            g = exp(-1i * (kx*X + ky*Y) );
            g = rot90(g,2);
%             g = g ./ width;            
            P(:,:,i,c) = conv2(Z(:,:,c), window.*g, 'valid');
            G(:,:,i,c) = g;
        end
    end
    
    
    % ------ split real and imaginary parts if required -----------
    if split
        G0 = G;
        G(:,:,1:2:nfreq*2,:) = real(G0);
        G(:,:,2:2:end+1,:) = imag(G0);
        clear G0;

        P0 = P;
        P(:,:,1:2:nfreq*2,:) = real(P0);
        P(:,:,2:2:end+1,:) = imag(P0);
        clear P0;
    end
        
    % -------------decorrelate --------------
    if decorr
        P = whiten(P,G);
    end
    
%     if split
%         P = complex(P(:,:,1:2:end), P(:,:,2:2:end));
%     end

    % apply blur invariant if needed
    P = P.^binv;
   
    % set very small values to zero for both real and imaginary parts
    e = 1e-9;
    ZR = abs(real(P)) < e;
    ZI = abs(imag(P)) < e;
    P(ZR) = 1i * imag(P(ZR));
    P(ZI) = real(P(ZI));
              
    % quantize phase
    if split
        PQ = double(P>=0);
    else
        PQ = mod( angle(P), 2*pi );
        PQ = floor(level.*PQ / (2*pi));
    end

end




function [Z width level window umax vmax mode decorr split invariant zeroterm axis] = parse_input(varargin)

    % default values for input
    width = 5;
%     window = ones(width,1);     
    level = 4;
    umax = 1;
    vmax = 1; 
    mode = 'Sliding';
    invariant = 'None';
    zeroterm = false;
    decorr = true;
    split = true;
    axis = [1 1 1];

    % define some constants and parameter names
    MIN_PARAM = 1;
    TOT_PARAM = length(varargin);
    PARAM_NAMES = {'width', 'window', 'level', 'umax', 'vmax', 'mode', 'decorr', 'split', 'invariant', 'zeroterm', 'axis'};

    
    %---
    % at least one paramter must be specified
    if length(varargin) < MIN_PARAM
        error 'Not enough arguments.';
    end
    
    % ensure there are always pairs of the kind (parameter,value)
    if mod(TOT_PARAM-MIN_PARAM, 2)
        error 'Wrong number of parameters';
    end
    
    
    % get the image
    Z = varargin{1};
    
    
    % get the specified parameters
    for p = MIN_PARAM+1 : 2 : TOT_PARAM
        
        par = varargin{p};
        
        if ~ischar(par)
            error 'Parameter names must be strings.';
        end
        
        par = lower(par);

        if any( find(strcmpi(par, PARAM_NAMES), 1, 'last') )       
            eval( sprintf('%s = varargin{p+1};', par) );
            
            if isempty( eval(sprintf('%s',par)) )
                error 'Parameter values must not be empty.';
            end
        else
            error('Unknown parameter name "%s"', par);
        end
        
    end
       
    
    % typecheck all the inputs
    if isempty(Z) || ~isnumeric(Z) || size(Z,3) > 3
        error 'The image must be of grayscale, RGB, or IZ format.'
    end
    
    if ~isnumeric(width) || ~isscalar(width) || width < 1
        error 'Width must be a positive scalar';
    end   
    
    % create default for window parameter
    if ~exist('window', 'var')
        window = ones(width);
    end
   
    if ~isnumeric(window) || length(window)~=width
        error 'Window must be a vector (or a square matrix) having dimensions equal to the parameter "Width"';
    end
          
    if ~isnumeric(level) || ~isscalar(level) || level < 0
        error 'Level must be a non-negative scalar';
    end

    if ~islogical(zeroterm) || ~isscalar(zeroterm)
        error 'ZeroTerm must be true or false';
    end    

    if ~islogical(decorr) || ~isscalar(decorr)
        error 'Decorr must be true or false';
    end
    
    if ~islogical(split) || ~isscalar(split)
        error 'Split must be true or false';
    end        
    
    if ~ischar(mode)
        error '"Mode" must be a string.';
    end   

    if ~ischar(invariant)
        error '"Invariant" must be a string.';
    end       
   
    if ~isnumeric(umax) || ~isscalar(umax) || umax < 0 || umax > floor(width/2)
        error 'Umax must be a non-negative scalar and less or equal to width/2';
    end

    if ~isnumeric(vmax) || ~isscalar(vmax) || vmax < 0 || vmax > floor(width/2)
        error 'Vmax must be a non-negative scalar and less or equal to width/2 ';
    end
    
    if ~isnumeric(axis) || length(axis)~=3
        error 'The color axis must be a vector of 3 elements';
    end    

    invariant = lower(invariant);
    mode = lower(mode);
    
    switch invariant
        case 'none'
            invariant = 1;
        case 'centsymmblur'
            invariant = 2;
        otherwise
            error('Wrong value "%s" for parameter "invariant"',invariant);
    end
    
end