module Integration (trapezoidal) where

-- Trapezoidal rule for numerical integration
trapezoidal :: (Double -> Double) -> Double -> Double -> Int -> Double
trapezoidal f a b n = h * ((f a + f b) / 2 + sumMid)
    where
        h = (b - a) / fromIntegral n
        sumMid = sum [f (a + h * fromIntegral i) | i <- [1 .. n-1]]

        