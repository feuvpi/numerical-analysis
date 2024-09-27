module Differentiation (finiteDifference) where

-- Numerical differentiation using finite difference
finiteDifference :: (Double -> Double) -> Double -> Double -> Double
finiteDifference f x h = (f (x + h) - f (x - h)) / (2 * h)

