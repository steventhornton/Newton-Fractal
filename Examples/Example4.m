% -------------------------------------------------------------------------
% EXAMPLE 4 -- Newton fractal of x^3 - 1 with options.
% -------------------------------------------------------------------------

% Margins for the image
margin = struct('bottom', -1.5, ...
                   'top',  1.5, ...
                  'left', -pi, ...
                 'right',  pi);

% Custom colormap
cmap = [255, 0, 0;
        0, 255, 0;
        0, 0, 255;
        0, 0, 0]/255;
            
opts = struct('margin', margin, ...
             'maxIter', 50,     ...
                 'tol', 0.01,   ...
              'height', 1000,   ...
                'cmap', cmap);

f = @(x) [sin(x);   % f(x)  = sin(x)
          cos(x)];  % f'(x) = cos(x)

workingDir = '~/Example4/';

newtonFractal(f, workingDir, opts);