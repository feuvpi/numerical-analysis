module RootFinding (bisection) where

-- Define bisection method
bisection :: (Double -> Double)  -> Double -> Double -> Double -> Maybe Double
bisection f a b tol
    | f a * f b >= 0 = Nothing -- If signs of f(a) and f(b) are the same, no root is guaranteed
    | abs (b-a) < tol = Just mid -- If the interval is smaller the tolerance, return midpoint
    | f mid == 0 = Just mid -- If f(mid) is exactly zero, return mid
    | f a * f mid < 0 = bisection f a mid tol -- Root is in [a, mid]
    | otherwise = bisection f mid b tol -- Root is in [mid, b]
    where 
        mid = (a + b) /2 -- Compute de midpoint