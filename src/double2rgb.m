% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Oct. 25/2016                                                %
%                                                                         %
% Apply a colormap to floating point values by interpolating between      %
% points in the colormap.                                                 %
%                                                                         %
% INPUT                                                                   %
%    img .... 2-dimensional array of floating point values                %
%    cmap ... m x 3 array where each row represents rgb values (in [0,1]) %
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
function rgb = double2rgb(img, cmap)
    
    % Background color
    bg = [0,0,0];
    
    [n,m] = size(img);
    
    % Convert to a vector
    s = img(:);
    
    rVal = zeros(size(s));
    gVal = zeros(size(s));
    bVal = zeros(size(s));
    
    % Only the valid points
    valid = isfinite(s);
    
    minVal = min(s(valid));
    maxVal = max(s(valid));
    
    % Fill in the non-valid points
    rVal(~valid) = bg(1);
    gVal(~valid) = bg(2);
    bVal(~valid) = bg(3);
    
    % Scale to a number between 0 and 1
    s(valid) = (s(valid) - minVal)/(maxVal - minVal);
    
    % Scale to a number between 1 and size(cmap)
    s(valid) = s(valid)*(size(cmap, 1) - 1) + 1;
    
    tZero = valid & ((s - floor(s)) == 0);
    tNotZero = valid & ((s - floor(s)) ~= 0);
    
    tFrac = s - floor(s);
    
    idx1 = floor(s);
    
    % When tFrac == 0
    rVal(tZero) = cmap(idx1(tZero), 1);
    gVal(tZero) = cmap(idx1(tZero), 2);
    bVal(tZero) = cmap(idx1(tZero), 3);
    
    % When tFrac ~= 0
    rVal1 = cmap(idx1(tNotZero), 1);
    gVal1 = cmap(idx1(tNotZero), 2);
    bVal1 = cmap(idx1(tNotZero), 3);
    rVal2 = cmap(idx1(tNotZero) + 1, 1);
    gVal2 = cmap(idx1(tNotZero) + 1, 2);
    bVal2 = cmap(idx1(tNotZero) + 1, 3);
    
    rVal(tNotZero) = (rVal2 - rVal1).*tFrac(tNotZero) + rVal1;
    gVal(tNotZero) = (gVal2 - gVal1).*tFrac(tNotZero) + gVal1;
    bVal(tNotZero) = (bVal2 - bVal1).*tFrac(tNotZero) + bVal1;
    
    rVal = reshape(rVal, [n, m]);
    gVal = reshape(gVal, [n, m]);
    bVal = reshape(bVal, [n, m]);
    
    rgb = cat(3, rVal, gVal, bVal);
    
end
