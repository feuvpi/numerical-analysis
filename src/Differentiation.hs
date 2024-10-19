module Differentiation 
    ( finiteDifference
    , centralDifference
    , richardsonExtrapolation
    ) where

-- | Numerical differentiation using forward difference
--
-- This function takes a function f, a point x, and a step size h as input,
-- and returns an approximation of the derivative of f at x using forward difference.
forwardDifference :: (Double -> Double) -> Double -> Double -> Double
forwardDifference f x h = (f (x + h) - f x) / h

-- | Numerical differentiation using central difference
--
-- This function takes a function f, a point x, and a step size h as input,
-- and returns an approximation of the derivative of f at x using central difference.
centralDifference :: (Double -> Double) -> Double -> Double -> Double
centralDifference f x h = (f (x + h) - f (x - h)) / (2 * h)

-- | Numerical differentiation using Richardson extrapolation
--
-- This function takes a function f, a point x, an initial step size h, and the number of iterations n as input,
-- and returns an improved approximation of the derivative of f at x using Richardson extrapolation.
richardsonExtrapolation :: (Double -> Double) -> Double -> Double -> Int -> Double
richardsonExtrapolation f x h n = go n h
  where
    go 1 h' = centralDifference f x h'
    go k h' = (4 * d2 - d1) / 3
      where
        d1 = go (k-1) h'
        d2 = go (k-1) (h'/2)

-- | Alias for centralDifference for backward compatibility
finiteDifference :: (Double -> Double) -> Double -> Double -> Double
finiteDifference = centralDifference