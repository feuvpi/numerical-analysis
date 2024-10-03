module Differentiation (finiteDifference) where

-- | Numerical differentiation using finite difference
--
-- This function takes a function f, a point x, and a step size h as input,
-- and returns an approximation of the derivative of f at x.
--
-- The input function f should be a function that takes a single number as input and returns a number.
-- The input point x should be a number.
-- The input step size h should be a small positive number.
--
-- The function returns a number representing the approximate value of the derivative.
--
-- Example:
--
-- >>> finiteDifference (\x -> x^2) 1 0.001
-- 2.000001
finiteDifference :: (Double -> Double) -> Double -> Double -> Double
finiteDifference f x h = (f (x + h) - f (x - h)) / (2 * h)

