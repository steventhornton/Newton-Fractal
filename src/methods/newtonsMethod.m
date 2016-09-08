% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 7/2016                                                %
%                                                                         %
% Compute Newton's method on a grid of points.                            %
%   xn = x - r*f(x)/f'(x)                                                 %
%                                                                         %
% INPUT                                                                   %
%   f ... A function handle that takes a row vector as input and returns  %
%         a matrix with 2 rows and the same number of columns as the      %
%         number of elements in the input row vector. The first row       %
%         represents the value of the function evaluated at the input     %
%         points, and the second row is the first derivative of the       %
%         function evaluated at the input points.                         %
%   x ... Points to evaluate Newton's method at.                          %
%   r ... Relaxation parameter                                            %
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
function xn = newtonsMethod(f, x, r)
    g = f(x);
    t = g(1,:)./g(2,:);
    xn = x - r*t;
end