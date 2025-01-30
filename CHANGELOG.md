Changelog for Numerus (numerical-analysis-lib)
All notable changes to this project will be documented in this file.
The format is based on Keep a Changelog,
and this project adheres to Semantic Versioning.
[0.0.9] - 2024-01-30
Added

Initial beta release with core numerical analysis functionality
Differentiation module with:

Forward and Central Difference methods
Richardson Extrapolation
N-th order derivative computation
Automatic step size selection


Integration module featuring:

Trapezoidal Rule integration
Simpson's Rule
Gaussian Quadrature (n=5)
Adaptive Quadrature
Romberg Integration


Linear Solver module including:

Sparse Matrix operations
Gaussian Elimination for sparse systems
Singular system detection


Root Finding module with:

Bisection method
Interval validation
Custom convergence criteria



Security

Initial MIT license implementation
Safe error handling for numerical operations

Infrastructure

Initial test suite with QuickCheck properties
Basic CI/CD setup
Documentation system

Note
This is a beta release. APIs may change before reaching 1.0.0. Please report any issues or suggestions for improvement.