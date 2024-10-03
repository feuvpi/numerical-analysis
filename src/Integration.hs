module Integration (trapezoidal) where

-- | Trapezoidal rule for numerical integration
--
-- This function takes a function f, a lower bound a, an upper bound b, and a number of intervals n as input,
-- and returns an approximation of the definite integral of f from a to b.
--
-- The input function f should be a function that takes a single number as input and returns a number.
-- The input bounds a and b should be numbers.
-- The input number of intervals n should be a positive integer.
--
-- The function returns a number representing the approximate value of the definite integral.
--
-- Example:
--
-- >>> trapezoidal (\x -> x^2) 0 1 100
-- 0.333335
trapezoidal :: (Double -> Double) -> Double -> Double -> Int -> Double
trapezoidal f a b n = h * ((f a + f b) / 2 + sumMid)
    where
        h = (b - a) / fromIntegral n
        sumMid = sum [f (a + h * fromIntegral i) | i <- [1 .. n-1]]

        