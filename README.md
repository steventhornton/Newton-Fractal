# Newton Fractal
This repository contains Matlab code for producing fractals in the complex plane arising from [Newton's](https://wikipedia.org/wiki/Newton%27s_method) and [Halley's](https://wikipedia.org/wiki/Halley%27s_method) iterations for root-finding. These are referred to as [Newton Fractals](https://wikipedia.org/wiki/Newton_fractal).

This code unfortunately does not take advantage of the GPU computing capabilities in Matlab as Matlab requires CUDA, which I do not have.

#### Matlab Requirements
- The __Parallel Computing Toolbox__ must be installed. If you do not have the parallel computing toolbox install you may modify the code slightly by changing any `parfor` loops to `for` loops.
- The __Symbolic Toolbox__ is needed for providing symbolic expressions to the fractal functions. You can still create fractals by using function handles instead.
- All contents (files and subfolders) of the `src/` directory must be in your Matlab working directory.

## Using the Matlab Code
There are two main functions for producing fractals `newtonFractal` and `halleyFractal` for Newton's and Halley's methods respectively. These functions are called as:
```matlab
newtonFractal(f, workingDir, options);
halleyFractal(f, workingDir, options);
```
### Input Function
The first input argument `f` can be either a function handle or a symbolic expression.
- __Function handle__ The function must take a row vector as input and return a matrix. The first row in the output matrix represents the values of the function evaluated at the input values. Subsequent rows represent represent derivatives of the function evaluated at the input points. For Newton's method, the first derivative is required (matrix with 2 rows). For Halley's method, the first two derivatives are require (matrix with 3 rows).
- __Symbolic expression__ The Symbolic Toolbox must be installed within Matlab to use this type of function input. A univariate symbolic function should be provided. It's derivatives will be computed automatically.

### The Working Directory
The second input argument `workingDir` is the location where images will be saved. When either method is called a `README.txt` file will be written to the working directory with information about the images produced. The images are automatically named as `Image-k.png` to ensure images are never overwritten.

### Options

| Option Name | Default | Details |
|----------- | ------- | ------- |
| `margin` | [-1-1i, 1+1i] | Must be a struct with keys: <ul><li>`bottom`</li><li>`top`</li><li>`left`</li><li>`right`</li></ul> that indicating the margins for the image. |
| `height` | 250 (pixels) | The height (in pixels) of the grid to be used. The width is determined from the `margin` such that each grid point is square. |
| `maxIter` | 50 | Maximum number of iterations for Newton's or Halley's method |
| `tol` | `1e-6` | Tolerance used to determine if an iteration has converged. The value of the input function at a point must be smaller in magnitude than this value to have converged. |
| `smoothing` | `false` | When `true`, exponential smoothing is used to provide a smooth transition in the colors between different number of iterations to convergence. |
| `r` | 1 | Relaxation parameter used for the iterations. |
| `cmap` | Matlab's `hsv` colormap. | A `m x 3` vector of values in [0,1] that specify the colors to be used for the image. Each row is an rgb triple. |

## Examples

### Example 1
```matlab
% -------------------------------------------------------------------------
% EXAMPLE 1 -- Newton fractal of x^3 - 1.
% -------------------------------------------------------------------------

f = @(x) [x.^3 - 1; % f(x)  = x^3 - 1
          3*x.^2];  % f'(x) = 3x^2

workingDir = '~/Example1/';

newtonFractal(f, workingDir);
```

Output image:

<p align="center">
    <img alt="Newton Fractal Example 1" src="https://s3.amazonaws.com/stevenethornton.github/NewtonFractal_ex1.png"/>
</p>

### Example 2
```matlab
% -------------------------------------------------------------------------
% EXAMPLE 2 -- Newton fractal of x^3 - 1.
%
% Requires the Symbolic Toolbox
% -------------------------------------------------------------------------

syms x

workingDir = '~/Example2/';

newtonFractal(x^3 - 1, workingDir);
```

Output image:

<p align="center">
    <img alt="Newton Fractal Example 2" src="https://s3.amazonaws.com/stevenethornton.github/NewtonFractal_ex2.png"/>
</p>

### Example 3
```matlab
% -------------------------------------------------------------------------
% EXAMPLE 3 -- Halley fractal of x^3 - 1.
% -------------------------------------------------------------------------

f = @(x) [x.^3 - 1; % f(x)   = x^3 - 1
          3*x.^2;   % f'(x)  = 3x^2
          6*x];     % f''(x) = 6x

workingDir = '~/Example3/';

halleyFractal(f, workingDir);
```

Output image:

<p align="center">
    <img alt="Halley Fractal Example 3" src="https://s3.amazonaws.com/stevenethornton.github/NewtonFractal_ex3.png"/>
</p>

### Example 4
```matlab
% -------------------------------------------------------------------------
% EXAMPLE 4 -- Newton fractal of x^3 - 1 with options.
% -------------------------------------------------------------------------

% Margins for the image
margin = struct('bottom', -1.5, ...
                   'top',  1.5, ...
                  'left', -pi,  ...
                 'right',  pi);

% Custom colormap
cmap = [255,   0,   0;
          0, 255,   0;
          0,   0, 255;
          0,   0,   0]/255;

opts = struct('margin', margin, ...
             'maxIter', 50,     ...
                 'tol', 0.01,   ...
              'height', 1000,   ...
                'cmap', cmap);

f = @(x) [sin(x);   % f(x)  = sin(x)
          cos(x)];  % f'(x) = cos(x)

workingDir = '~/Example4/';

newtonFractal(f, workingDir, opts);
```

Output image:

<p align="center">
    <img alt="Newton Fractal Example 4" src="https://s3.amazonaws.com/stevenethornton.github/NewtonFractal_ex4.png"/>
</p>

### Example 5
```matlab
% -------------------------------------------------------------------------
% EXAMPLE 5 -- Halley fractal of x^3 - 1 with relaxation parameter of 2.
% -------------------------------------------------------------------------

margin = struct('bottom', -0.9, ...
                   'top',  0.9, ...
                  'left', -0.9, ...
                 'right',  0.9);

% Custom colormap
cmap = [200, 200, 255;
         80,  80, 220;
          0,   0,   0;
          0,   0,   0]/255;

opts = struct('margin', margin, ...
             'maxIter', 75,     ...
                 'tol', 0.001,  ...
              'height', 1000,   ...
           'smoothing', true,   ...
                   'r', 2,      ...
                'cmap', cmap);

workingDir = '~/Example5/';

syms x

halleyFractal(x^3 - 1, workingDir, opts);
```

Output image:

<p align="center">
    <img alt="Halley Fractal Example 5" src="https://s3.amazonaws.com/stevenethornton.github/NewtonFractal_ex5.png"/>
</p>
