module Differentiation 
    ( 
    -- * Basic differentiation methods
      finiteDifference
    , centralDifference
    , forwardDifference
    -- * Advanced methods
    , richardsonExtrapolation
    , nthOrderCentralDifference
    -- * Automatic step size selection
    , automaticStepSize
    -- * Vector-valued functions
    , vectorCentralDifference
    ) where

import Control.Exception (assert)
import Data.List (transpose)


-- | Numerical differentiation using forward difference
--
-- This function takes a function f, a point x, and a step size h as input,
-- and returns an approximation of the derivative of f at x using forward difference.
-- @
-- forwardDifference f x h = (f(x + h) - f(x)) / h
-- @
--
-- === Example:
--
-- >>> forwardDifference (\x -> x^2) 1 0.0001
-- 2.0001000000089896
forwardDifference :: (Double -> Double) -> Double -> Double -> Double
forwardDifference f x h
  | h <= 0 = error "forwardDifference: step size must be positive"
  | otherwise = (f (x + h) - f x) / h

-- | Numerical differentiation using central difference
--
-- This function takes a function f, a point x, and a step size h as input,
-- and returns an approximation of the derivative of f at x using central difference.
centralDifference :: (Double -> Double) -> Double -> Double -> Double
centralDifference f x h = 
    assert (h > 0) $ (f (x + h) - f (x - h)) / (2 * h)

-- | Numerical differentiation using Richardson extrapolation
--
-- This function takes a function f, a point x, an initial step size h, and the number of iterations n as input,
-- and returns an improved approximation of the derivative of f at x using Richardson extrapolation.
richardsonExtrapolation :: (Double -> Double) -> Double -> Double -> Int -> Double
richardsonExtrapolation f x h n = 
    assert (h > 0 && n > 0) $ go n h
  where
    go 1 h' = centralDifference f x h'
    go k h' = (4 * d2 - d1) / 3
      where
        d1 = go (k-1) h'
        d2 = go (k-1) (h'/2)

-- | Compute nth order derivative using central difference
nthOrderCentralDifference :: Int -> (Double -> Double) -> Double -> Double -> Double
nthOrderCentralDifference n f x h
    | n < 0     = error "Order must be non-negative"
    | n == 0    = f x
    | otherwise = (d1 - d2) / (2 * h)
  where
    d1 = nthOrderCentralDifference (n-1) f (x + h) h
    d2 = nthOrderCentralDifference (n-1) f (x - h) h

-- | Alias for centralDifference for backward compatibility
finiteDifference :: (Double -> Double) -> Double -> Double -> Double
finiteDifference = centralDifference

-- | Vector-valued central difference
-- This function computes the Jacobian matrix for a vector-valued function
--
-- === Example:
--
-- >>> let f [x, y] = [x^2 + y, x*y]
-- >>> vectorCentralDifference f [1, 2] 0.0001
-- [[2.0000000000055511,0.99999999999179465],[2.0000000000248084,1.0000000000248084]]
vectorCentralDifference :: ([Double] -> [Double]) -> [Double] -> Double -> [[Double]]
vectorCentralDifference f x h = 
    let n = length x
        basis i = replicate i 0 ++ [1] ++ replicate (n-i-1) 0
        diff i = 
            let fPlus = f (zipWith (+) x (map (*h) (basis i)))
                fMinus = f (zipWith (-) x (map (*h) (basis i)))
            in zipWith (\a b -> (a - b) / (2*h)) fPlus fMinus
    in transpose $ map diff [0..n-1]

-- | Automatic step size selection
--
-- This function attempts to find an optimal step size for differentiation
-- based on the function and the point of evaluation.
--
-- === Example:
--
-- >>> automaticStepSize (\x -> x^2) 1
-- 2.154434690031884e-6
automaticStepSize :: (Double -> Double) -> Double -> Double
automaticStepSize f x0 = 
    let eps = 1e-8  -- machine epsilon
        scale = max 1 (abs x0)
        fx0 = abs (f x0)
    in cubeRoot (eps * scale / fx0)
  where
    cubeRoot y = y ** (1/3)