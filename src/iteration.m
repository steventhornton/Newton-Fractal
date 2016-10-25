% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 7/2016                                                %
%                                                                         %
% Compute Newton's method on a grid of points.                            %
%                                                                         %
% INPUT                                                                   %
%   f .............. A function handle that takes a row vector as input   %
%                    and returns a matrix with the same number of columns %
%                    as the number of elements in the input vector. The   %
%                    rows of the matrix represent the value of the        %
%                    function and subsequent derivatives.                 %
%   method .... A function handle that takes 3 values as input:           %
%                   f ... A function handle for evaluating a function and %
%                         its derivatives                                 %
%                   x ... A vector of points to evaluate f at             %
%                   r ... Relaxation paramater                            %
%   options ... A struct of options.                                      %
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
function s = iteration(f, method, options)
    
    % Get the options
    r = options.r;
    resolution = options.resolution;
    margin = options.margin;
    maxIter = options.maxIter;
    tol = options.tol;
    smoothing = options.smoothing;
    
    % Set up the complex grid
    grid = makeMesh(margin, resolution);
    
    % Convert to a row vector
    grid = grid(:)';
    
    % Boolearn matrix, all false (same size as grid) 
    inTol = false(size(grid));
    
    % Vector that will be plotted (smooth count)
    s = zeros(size(grid));
    
    k = 0;
    
    % Continue looping until either maximum number of iterations is reached
    % or all grid points have been computed to within the tolerance.
    while k < maxIter && ~all(inTol(:))
        
        k = k + 1;
        
        % Get the values from the grid where the solution has not been
        % computed to within the tolerance yet
        gridCompute = grid(~inTol);
        
        % Evaluate the iteration method
        gNew = method(f, gridCompute, r);
        grid(~inTol) = gNew;
        t = gNew - gridCompute;
        
        if smoothing
            s(~inTol) = s(~inTol) + exp(-1./abs(t));
        else
            s(~inTol) = s(~inTol) + 1;
        end
        
        % Update inTol vector
        fg = f(grid);
        inTol(abs(fg(1,:)) < tol) = true;
    
    end
    
    % Reshape back to a matrix
    s = reshape(s, [resolution.height, resolution.width]);
    
end