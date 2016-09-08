% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 6/2016                                                %
%                                                                         %
% Create a matrix where the entries are complex values such that the      %
% entire matrix represents a grid in the complex plane.                   %
%                                                                         %
% INPUT                                                                   %
%   margin ....... Struct with keys:                                      %
%                      left ..... Left margin                             %
%                      right .... Right margin                            %
%                      bottom ... Bottom margin                           %
%                      top ...... Top margin                              %
%   resolution ... Struct with keys:                                      %
%                      width .... number of columns in grid               %
%                      height ... number of rows in grid                  %
%                                                                         %
% OUTPUT                                                                  %
%   A 2D complex matrix of grid points in the complex plane               %
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
function grid = makeMesh(margin, resolution)

    reMin = margin.left;
    reMax = margin.right;
    imMin = margin.bottom;
    imMax = margin.top;
    
    width = resolution.width;
    height = resolution.height;
    
    x = linspace(reMin, reMax, width);
    y = linspace(imMin, imMax, height);
    
    [x, y] = meshgrid(x, y);
    
    grid = x + 1i * y;
    
end