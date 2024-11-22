# Numerus: Advanced Numerical Analysis Library in Haskell

### Overview

Numerus is a high-performance numerical analysis library implemented in pure Haskell, designed for scientific computing, engineering applications, and academic research. It provides a comprehensive suite of numerical methods with an emphasis on accuracy, stability, and clean functional design.

### Key Features

#### Differentiation Module
- Forward and Central Difference methods
- Richardson Extrapolation for improved accuracy
- N-th order derivative computation
- Automatic step size selection
- Vector-valued function support
- Accuracy up to O(h²) for central differences

#### Integration Module
- Trapezoidal Rule integration
- Simpson's Rule for improved accuracy
- Gaussian Quadrature (optimized for n=5)
- Adaptive Quadrature for difficult integrands
- Romberg Integration with Richardson extrapolation
- Support for reversed intervals and error handling

#### Linear Solver
- Sparse Matrix operations
- Gaussian Elimination optimized for sparse systems
- Robust handling of singular and near-singular cases
- Automatic detection of inconsistent systems

#### Root Finding
- Bisection method with guaranteed convergence
- Robust error handling and interval validation
- Support for custom convergence criteria

### Installation

Add to your package.yaml or .cabal file:

```yaml
dependencies:
- numerus
```

Or install via cabal:

```bash
cabal install numerus
```

### Quick Examples

```haskell
import Numerus.Differentiation
import Numerus.Integration
import Numerus.RootFinding

-- Computing derivative of sin(x)
let derivative = centralDifference sin (pi/4) 0.0001
    -- Result ≈ cos(π/4)

-- Integrating x² from 0 to 1
let integral = simpson (\x -> x*x) 0 1 100
    -- Result ≈ 0.3333...

-- Finding root of x² - 2
let root = bisection (\x -> x*x - 2) 0 2 0.0001
    -- Result ≈ 1.4142...
```

### Error Handling

All functions implement comprehensive error checking:

```haskell
-- Safe handling of invalid inputs
trapezoidal (\x -> x^2) 0 1 (-1)  -- Throws appropriate error
simpson (\x -> x^2) 0 1 3         -- Validates even intervals
gaussianQuadrature 0 (\x -> x) 0 1  -- Validates positive points
```

### Testing

The library includes extensive QuickCheck properties and unit tests:

```bash
cabal test
```

Tests cover:
- Numerical accuracy against known solutions
- Edge cases and error conditions
- Property-based randomized testing
- Stability under various input conditions

### Documentation

Generate comprehensive documentation:

```bash
cabal haddock
```

Each module includes:
- Detailed function descriptions
- Mathematical background
- Usage examples
- Error handling specifications
- Performance characteristics

### Performance Characteristics

- Integration methods achieve accuracy up to 1e-10 for smooth functions
- Differentiation methods provide O(h²) convergence for central differences
- Sparse matrix operations optimized for O(n) performance on typical systems
- All algorithms incorporate stability safeguards

### Contributing

We welcome contributions! Please:

1. Ensure code is pure functional and well-documented
2. Include QuickCheck properties for new features
3. Maintain numerical stability
4. Follow existing code style
5. Add appropriate unit tests
6. Update documentation as needed

### License

MIT License (c) 2024

### Future Development

Planned features:
- Additional optimization methods
- Extended root finding algorithms
- Eigenvalue computation
- Special function support
- Statistical analysis tools

### Contact

- Issues: https://github.com/feuvpi/numerus/issues
- Maintainer: fredvpg@gmail.com