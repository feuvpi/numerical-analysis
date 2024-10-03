module RootFinding (bisection) where

-- | Numerical root finding using the bisection method
--
-- This function takes a function f, a lower bound a, an upper bound b, and a tolerance tol as input,
-- and returns an approximation of the root of f in the interval [a, b].
--
-- The input function f should be a function that takes a single number as input and returns a number.
-- The input bounds a and b should be numbers such that f(a) and f(b) have opposite signs.
-- The input tolerance tol should be a small positive number.
--
-- The function returns a number representing the approximate value of the root.
--
-- Example:
--
-- >>> bisection (\x -> x^2 - 2) 0 2 0.001
-- 1.414214
bisection :: (Double -> Double)  -> Double -> Double -> Double -> Maybe Double
bisection f a b tol
    | f a * f b >= 0 = Nothing -- If signs of f(a) and f(b) are the same, no root is guaranteed
    | abs (b-a) < tol = Just mid -- If the interval is smaller the tolerance, return midpoint
    | f mid == 0 = Just mid -- If f(mid) is exactly zero, return mid
    | f a * f mid < 0 = bisection f a mid tol -- Root is in [a, mid]
    | otherwise = bisection f mid b tol -- Root is in [mid, b]
    where 
        mid = (a + b) /2 -- Compute de midpoint