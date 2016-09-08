% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 7/2016                                                %
%                                                                         %
% INPUT                                                                   %
%   f .............. Either a function handle or a symbolic expression.   %
%                        Function handle: Must take a row vector as input %
%                                         and returns a matrix with 2     %
%                                         rows and the same number of     %
%                                         columns as the number of        %
%                                         elements in the input row       %
%                                         vector. The first row           %
%                                         represents the value of the     %
%                                         function evaluated at the input %
%                                         points, and the second row is   %
%                                         the first derivative of the     %
%                                         function evaluated at the input %
%                                         points.                         %
%                        Symbolic expression: A symbolic expression in    %
%                                             one variable.               %
%   workingDirIn ... The directory to save output images.                 %
%   options ........ A struct containing the options                      %
%                                                                         %
% OPTIONS                                                                 %
%   Options should be a struct with the keys below                        %
%   margin ...... Default: (-1-1i, 1+i)                                   %
%                       Struct with keys:                                 %
%                           left ..... Left margin                        %
%                           right .... Right margin                       %
%                           bottom ... Bottom margin                      %
%                           top ...... Top margin                         %
%   maxIter ..... Default: 50                                             %
%                 Maximum number of iterations.                           %
%   tol ......... Default: 1e-6                                           %
%                 Tolerance used for determining if an iteration has      %
%                 converged.                                              %
%   height ...... Default: 250 (pixels)                                   %
%                 Height in pixels for the ouput image. The width is      %
%                 computed automatically based on the margin such that    %
%                 all pixels are squares.                                 %
%   smoothing ... Default: false                                          %
%                 When true, exponential smoothing is used to provide a   %
%                 smooth transition in the colors between different       %
%                 number of iterations to convergence.                    %
%   r ........... Default: 1                                              %
%                 A parameter used in the iterations:                     %
%                   x_n+1 = x_n - r*f(x_n)/f'(x_n)                        %
%   cmap ........ Default: Matlab's hsv colormap                          %
%                                                                         %
% LICENSE                                                                 %
%   This program is free software: you can redistribute it and/or modify  %
%   it under the terms of the GNU General Public License as published by  %
%   the Free Software Foundation, either version 3 of the License, or     %
%   any later version.                                                    %
%                                                                         %
%   This program is distributed in the hope that it will be useful,       %
%   but WITHOUT ANY WARRANTY; without even the implied warranty of        %
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         %
%   GNU General Public License for more details.                          %
%                                                                         %
%   You should have received a copy of the GNU General Public License     %
%   along with this program.  If not, see http://www.gnu.org/licenses/.   %
% ----------------------------------------------------------------------- %
function newtonFractal(f, workingDirIn, options)
    
    % Check the number of arguments
    narginchk(2, 3)
    
    if nargin < 3
        options = struct();
    end
    
    % Check/convert the input function
    if isa(f, 'function_handle')
        g = f;
    elseif isa(f, 'sym')
        
        % Convert symbolic expression to function handle with derivative
        h   = matlabFunction(f);
        dh  = matlabFunction(diff(f));
        
        g = @(x) [ h(x);
                  dh(x)];
    else
        error('Input function must be a function handle or symbolic expression');
    end
    
    % Function handle for Newton's method
    method = @(f, x, r) newtonsMethod(f, x, r);
    
    % Make the fractal
    makeFractal(g, method, workingDirIn, options);
    
end