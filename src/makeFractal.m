% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 7/2016                                                %
%                                                                         %
% Create a Newton or Halley fractal in the complex plane.                 %
%                                                                         %
% INPUT                                                                   %
%   f .............. A function handle that takes a row vector as input   %
%                    and returns a matrix with the same number of columns %
%                    as the number of elements in the input vector. The   %
%                    rows of the matrix represent the value of the        %
%                    function and subsequent derivatives.                 %
%   method ......... A function handle that takes 3 values as input:      %
%                       f ... A function handle for evaluating a          %
%                               function and it's derivatives             %
%                       x ... A vector of points to evaluate f at         %
%                       r ... Relaxation paramater                        %
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
%                   x_n+1 = x_n - r*method                                %
%                 where method is dependent on the method used (f/df for  %
%                 Newtons' method).                                       %
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
function makeFractal(f, method, workingDirIn, options)

    % Make working directory if it doesn't exit
    if workingDirIn(end) == filesep
        workingDir = workingDirIn;
    else
        workingDir = [workingDirIn, filesep];
    end
    mkdir_if_not_exist(workingDir);

    % Process the options
    opts = processOptions(options);

    margin    = opts.margin;
    maxIter   = opts.maxIter;
    tol       = opts.tol;
    height    = opts.height;
    smoothing = opts.smoothing;
    r         = opts.r;
    cmap      = opts.cmap;

    % Get resolution
    resolution = getResolution();
    opts.resolution = resolution;

    % Output filename
    outputFilename = makeOutputFilename();

    % Make the fratal
    runIteration()

    % Write readme file
    writeReadMe();


    % =====================================================================
    % FUNCTIONS
    % =====================================================================

    % ---------------------------------------------------------------------
    function runIteration()

        s = iteration(f, method, opts);
        
        if smoothing
            rgb = double2rgb(s, cmap);
        else
            rgb = int2rgb(s, cmap);
        end
        
        % Write the image to a file
        imwrite(rgb, [workingDir, outputFilename]);
        fprintf(['Image written to: ', outputFilename, '\n']);

    end
    

    % ------------------------------------------------------------------- %
    % getResolution                                                       %
    %                                                                     %
    % Compute the resolution struct based on the height and margins.      %
    %                                                                     %
    % OUTPUT                                                              %
    %   A struct resolution = {'width', w, 'height', h}                   %
    % ------------------------------------------------------------------- %
    function resolution = getResolution()

        % Check the margins and make the resolution structure
        if margin.bottom >= margin.top
            error 'Bottom margin must be less than top margin';
        end
        if margin.left >= margin.right
            error 'Left margin must be less than top margin';
        end

        width = getWidth();

        resolution = struct('width', width, 'height', height);

    end


    % ------------------------------------------------------------------- %
    % getWidth                                                            %
    %                                                                     %
    % Compute the width (in px) based on the height and the margins such  %
    % that each grid point is a square                                    %
    %                                                                     %
    % OUTPUT                                                              %
    %   A struct resolution = {'width', w, 'height', h}                   %
    % ------------------------------------------------------------------- %
    function width = getWidth()
        heightI = margin.top - margin.bottom;
        widthI = margin.right - margin.left;
        width = floor(widthI*height/heightI);
    end


    % ------------------------------------------------------------------- %
    % outputFilename                                                      %
    %                                                                     %
    % Determine the name of the output file.                              %
    %                                                                     %
    % OUTPUT                                                              %
    %   A string of the form                                              %
    %   Image-(i) where i is a positive integer.                          %
    % ------------------------------------------------------------------- %
    function outputFilename = makeOutputFilename()

        outPrefix = 'Image-';

        if exist([workingDir, outPrefix, '1.png']) == 2
            i = 2;
            while exist([workingDir, outPrefix , num2str(i), '.png']) == 2
                i = i + 1;
            end
            outputFilename = [outPrefix, num2str(i), '.png'];
        else
            outputFilename = [outPrefix, '1.png'];
        end
    end


    % ------------------------------------------------------------------- %
    % writeReadMe                                                         %
    %                                                                     %
    % Write a readme file in the workingDir with information about        %
    % when the data was created, what was used to create the data, etc.   %
    % ------------------------------------------------------------------- %
    function writeReadMe()

        file = fopen([workingDir, 'README.txt'], 'a');

        fprintf(file, [outputFilename, '\n']);

        % Date
        fprintf(file, ['\tCreated ...... ', datestr(now,'mmmm dd/yyyy HH:MM:SS AM'), '\n']);

        % Function
        fprintf(file, ['\tFunction ..... ', func2str(f), '\n']);

        % Method
        %fprintf(file, ['\tmethod ....... ', method, '\n']);

        % Margin
        fprintf(file, ['\tmargin ....... bottom: ', num2str(margin.bottom), '\n']);
        fprintf(file, ['\t                  top: ', num2str(margin.top), '\n']);
        fprintf(file, ['\t                 left: ', num2str(margin.left), '\n']);
        fprintf(file, ['\t                right: ', num2str(margin.right), '\n']);

        % Resolution
        fprintf(file, ['\tresolution ... ', num2str(resolution.width), 'x', num2str(resolution.height), '\n']);

        % maxIter
        fprintf(file, ['\tmaxIter ...... ', num2str(maxIter), '\n']);

        % tol
        fprintf(file, ['\ttol .......... ', num2str(tol), '\n']);

        % smoothing
        if smoothing
            fprintf(file, '\tsmoothing .... true\n');
        else
            fprintf(file, '\tsmoothing .... false\n');
        end

        % r
        fprintf(file, ['\tr ............ ', num2str(r), '\n']);

        % cmap
        fprintf(file, ['    cmap .............. ', ...
                       num2str(cmap(1,1)), ', ', ...
                       num2str(cmap(1,2)), ', ', ...
                       num2str(cmap(1,3)), '\n']);
        for i=2:size(cmap, 1)
            fprintf(file, ['                        ', ...
                           num2str(cmap(i,1)), ', ', ...
                           num2str(cmap(i,2)), ', ', ...
                           num2str(cmap(i,3)), '\n']);
        end

        fprintf(file, '\n\n\n');
        fclose(file);

    end

end