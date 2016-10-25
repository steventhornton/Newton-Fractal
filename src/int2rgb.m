% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 8/2016                                                %
%                                                                         %
% Apply a colormap to integer values by taking the integer values mod the %
% number of colors and applying the appropriate color from the colormap   %
%                                                                         %
% INPUT                                                                   %
%   img .... 2-dimensional array of integer values                        %
%   cmap ... m x 3 array where each row represents rgb values (in [0,1])  %
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
function rgb = int2rgb(img, cmap)
    
    [n,m] = size(img);
    
    % Convert to a vector
    s = img(:);
    
    % Reduce to the number of colors
    s = mod(s, size(cmap, 1)) + 1;
    
    % Get the colors
    rgb = cmap(s,:);
    
    rgb = reshape(rgb, [n, m, 3]);
    
end