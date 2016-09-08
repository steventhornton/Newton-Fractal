% ----------------------------------------------------------------------- %
% AUTHOR .... Steven E. Thornton (Copyright (c) 2016)                     %
% EMAIL ..... sthornt7@uwo.ca                                             %
% UPDATED ... Sept. 6/2016                                                %
%                                                                         %
% Process the options input options struct. If an option is not in the    %
% options struct the default value is used.                               %
%                                                                         %
% INPUT                                                                   %
%   options ... (struct) contains keys corresponding to the options       %
%                                                                         %
% OUTPUT                                                                  %
%   A struct opts with keys                                               %
%       margin ...... struct(left, right, bottom, top), double            %
%       maxIter ..... posint                                              %
%       tol ......... positive double (<1)                                %
%       height ...... posint                                              %
%       smoothing ... bool                                                %
%       r ........... double                                              %
%       cmap ........ m x 3 array of doubles in [0,1]                     %
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
function opts = processOptions(options)
    
    % Check the number of input arguments
    if nargin ~= 1
        error('processOptions:WrongNumberofArgs', ...
              'processOptions expects one argument.');
    end
    
    % Check that options is a struct
    if ~isstruct(options)
        error('processOptions:InvalidOptionsStruct', ...
              'options argument must be a structured array');
    end
    
    optNames = struct('margin', 'margin', ...
                     'maxIter', 'maxIter', ...
                         'tol', 'tol', ...
                      'height', 'height', ...
                   'smoothing', 'smoothing', ...
                           'r', 'r', ...
                        'cmap', 'cmap');
    fnames = fieldnames(options);
    
    if ~all(ismember(fnames, fieldnames(optNames)))
        error('processOptions:InvalidOption',  ...
              'Invalid option provided');
    end
    
    opts = struct();
    
    % Default values
    opts.margin    = struct('bottom', -1, ...
                            'top',     1, ...
                            'left',   -1, ...
                            'right',   1);
    opts.maxIter   = 50;
    opts.tol       = 1e-6;
    opts.height    = 250;
    opts.smoothing = false;
    opts.r         = 1;
    opts.cmap      = hsv;
    
    % margin ---------------------------
    if isfield(options, optNames.margin)
        
        opts.margin = options.margin;
        
        % TO DO: Add type checking (struct: left, right, bottom, top))
        
    end
    
    % maxIter --------------------------
    if isfield(options, optNames.maxIter)
        
        opts.maxIter = options.maxIter;
        
        % Check that maxIter is a positive integer
        if ~isposint(opts.maxIter)
            error('maxIter option must be a positive integer');
        end
        
    end
    
    % tol ---------------------------
    if isfield(options, optNames.tol)
        
        opts.tol = options.tol;
        
        % Check that tol is in [0,1]
        if opts.tol < 0 || opts.tol > 1
            error('tol option must be between 0 and 1');
        end
        
    end
    
    % height ---------------------------
    if isfield(options, optNames.height)
        
        opts.height = options.height;
        
        if ~isposint(opts.height)
            error('height option must be a positive integer');
        end
        
    end
    
    % smoothing ---------------------------
    if isfield(options, optNames.smoothing)
        
        opts.smoothing = options.smoothing;
        
        % TO DO: Add type checking (bool)
        
    end
    
    % r ---------------------------
    if isfield(options, optNames.r)
        
        opts.r = options.r;
        
        % TO DO: Add type checking (float)
        
    end
    
    % cmap -----------------------------
    if isfield(options, optNames.cmap)
        opts.cmap = options.cmap;
    end
    
    
    % ---------------------------------------------------------------------
    % Type checking functions
    % ---------------------------------------------------------------------
    
    function b = isposint(x)
    
        b = logical(0);
    
        try
            b = logical((x > 0) & (~mod(x, 1)));
        end
    end
    
end