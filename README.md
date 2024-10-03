Based on the provided code, here are some suggestions to make the library professional and ready to ship:

Documentation: Add Haddock comments to explain the purpose and usage of each function. This will make it easier for users to understand how to use the library. You can also consider using a documentation generator like Haddock to create HTML documentation.

Testing: Write unit tests for each function to ensure they work correctly. You can use a testing framework like QuickCheck or HUnit.

Error Handling: Currently, the gaussianElimination function uses fromJust which will throw an error if the input is invalid. Consider using Maybe or Either to handle errors in a more robust way.

Type Classes: Consider using type classes to make the functions more generic. For example, you could use the Num type class to make the functions work with different numeric types.

Performance: Consider using more efficient algorithms or data structures to improve performance. For example, you could use a sparse matrix representation for the Gaussian elimination function.

API: Consider adding more functions to the API to make it more comprehensive. For example, you could add functions for solving systems of nonlinear equations, or for computing eigenvalues and eigenvectors.

Some additional features you could consider adding to make the library more interesting:

Optimization: Add functions for optimization, such as linear programming, quadratic programming, or nonlinear optimization.

Signal Processing: Add functions for signal processing, such as filtering, convolution, or Fourier transforms.

Statistics: Add functions for statistical analysis, such as hypothesis testing, confidence intervals, or regression analysis.

Interpolation: Add functions for interpolation, such as polynomial interpolation, spline interpolation, or radial basis function interpolation.

Special Functions: Add functions for special mathematical functions, such as Bessel functions, Legendre functions, or elliptic functions.

Some resources to learn more:

The Haskell wiki has a page on numerical analysis with links to various libraries and resources.
The Hackage package repository has a section on numerical analysis with many libraries and packages available.
The book "Numerical Methods in Haskell" by George Shilov provides a comprehensive introduction to numerical analysis in Haskell.
Some files you might want to add to your project:

A README.md file to provide an overview of the library and its features.
A LICENSE file to specify the license under which the library is released.
A CHANGELOG.md file to track changes and updates to the library.
A tests directory to store unit tests and other testing code.
A benchmarks directory to store benchmarking code and results.