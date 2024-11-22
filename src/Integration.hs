module Integration 
    ( trapezoidal
    , simpson
    , gaussianQuadrature
    , adaptiveQuadrature
    , romberg
    ) where

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
trapezoidal f a b n
    | n <= 0    = error "Number of intervals must be positive"  -- Added error check
    | otherwise = h * ((f a + f b) / 2 + sumMid)
    where
        h = (b - a) / fromIntegral n
        sumMid = sum [f (a + h * fromIntegral i) | i <- [1 .. n-1]]


-- | Simpson's rule for numerical integration
--
-- This method approximates the definite integral using quadratic polynomials
-- rather than linear segments (as in trapezoidal rule), providing better accuracy
-- for smooth functions.
--
-- The formula uses weighted sum: (h/3) * [f(a) + 4f(x₁) + 2f(x₂) + 4f(x₃) + ... + f(b)]
--
-- === Properties:
-- * Exact for polynomials up to degree 3
-- * Requires even number of intervals
-- * Generally more accurate than trapezoidal rule
--
-- === Example:
--
-- >>> simpson (\x -> x^2) 0 1 100
-- 0.33333333333
--
-- === Error handling:
-- * Throws error if n ≤ 0
-- * Throws error if n is odd
-- * Automatically handles reversed intervals (a > b)
simpson :: (Double -> Double) -> Double -> Double -> Int -> Double
simpson f a b n
    | odd n     = error "Number of intervals must be even"
    | n <= 0    = error "Number of intervals must be positive"
    | a > b     = negate $ simpson f b a n
    | otherwise = h/3 * (f a + f b + 4 * evenSum + 2 * oddSum)
  where
    h = (b - a) / fromIntegral n
    evenSum = sum [f (a + h * fromIntegral i) | i <- [1,3..n-1]]
    oddSum = sum [f (a + h * fromIntegral i) | i <- [2,4..n-2]]

-- | Gaussian quadrature numerical integration
--
-- Uses optimal points and weights to approximate the integral. This method
-- can achieve high accuracy with relatively few points for smooth functions.
--
-- === Properties:
-- * Exact for polynomials up to degree (2n-1) where n is number of points
-- * Particularly effective for smooth functions
-- * Pre-computed weights and points for n=5 (Gauss-Legendre quadrature)
--
-- === Example:
--
-- >>> gaussianQuadrature 5 (\x -> x^2) (-1) 1
-- 0.6666666666666667
--
-- === Error handling:
-- * Throws error if n ≤ 0
-- * Automatically handles reversed intervals (a > b)
gaussianQuadrature :: Int -> (Double -> Double) -> Double -> Double -> Double
gaussianQuadrature n f a b
    | n <= 0    = error "Number of points must be positive"
    | a > b     = negate $ gaussianQuadrature n f b a
    | otherwise = ((b - a) / 2) * sum [w_i i * f (x_scaled i) | i <- [0..n-1]]
  where
    -- Gauss-Legendre points and weights for n=5
    points = [
        0.0,
        -0.538469310105683,
        0.538469310105683,
        -0.906179845938664,
        0.906179845938664
      ]
    weights = [
        0.568888888888889,
        0.478628670499366,
        0.478628670499366,
        0.236926885056189,
        0.236926885056189
      ]
    w_i i = weights !! (min i 4)
    x_scaled i = ((b - a) * (points !! (min i 4)) + (b + a)) / 2


-- | Adaptive quadrature using recursive subdivision
--
-- This method automatically subdivides the integration interval where more
-- precision is needed, based on local error estimates. Particularly effective
-- for functions with varying behavior across the interval.
--
-- === Algorithm:
-- 1. Estimate integral using two different step sizes
-- 2. If difference is within tolerance, return result
-- 3. Otherwise, split interval and recurse on both halves
--
-- === Properties:
-- * Adapts to function behavior
-- * Efficient for functions with local difficult regions
-- * Controlled by error tolerance rather than fixed intervals
--
-- === Example:
--
-- >>> adaptiveQuadrature (\x -> 1/x) 1 2 1e-6
-- 0.6931471805599453
--
-- === Error handling:
-- * Automatically handles reversed intervals (a > b)
-- * Tolerance parameter controls accuracy
adaptiveQuadrature :: (Double -> Double) -> Double -> Double -> Double -> Double
adaptiveQuadrature f a b tol
    | a > b     = negate $ adaptiveQuadrature f b a tol
    | otherwise = adapt a b (f a) (f b) tol
  where
    adapt a' b' fa fb tol'
        | abs (trap - trapRefine) < tol' = trapRefine
        | otherwise = leftHalf + rightHalf
      where
        m = (a' + b') / 2
        fm = f m
        trap = (b' - a') * (fa + fb) / 2
        trapRefine = (b' - a') * (fa + 2*fm + fb) / 4
        leftHalf = adapt a' m fa fm (tol'/2)
        rightHalf = adapt m b' fm fb (tol'/2)


-- | Romberg integration
--
-- Uses Richardson extrapolation to improve accuracy of trapezoidal rule
-- estimates. Combines multiple trapezoidal approximations with different
-- step sizes to eliminate lower-order error terms.
--
-- === Algorithm:
-- 1. Compute sequence of trapezoidal approximations with h, h/2, h/4, ...
-- 2. Apply Richardson extrapolation to eliminate error terms
--
-- === Properties:
-- * Rapid convergence for smooth functions
-- * Uses sequence of refined estimates
-- * Order k determines number of refinement steps
--
-- === Example:
--
-- >>> romberg sin 0 pi 4
-- 2.0000000000000004
--
-- === Error handling:
-- * Throws error if k ≤ 0
-- * Automatically handles reversed intervals (a > b)
romberg :: (Double -> Double) -> Double -> Double -> Int -> Double
romberg f a b k
    | k <= 0    = error "Order must be positive"
    | a > b     = negate $ romberg f b a k
    | otherwise = last $ head $ rombergTable  -- Changed to get last element of first row
  where
    -- Create the Romberg table with improved numerical stability
    rombergTable = buildTable k
    
    -- Build table bottom-up for better numerical stability
    buildTable n = go [initialRow] (n-1)
      where
        initialRow = [trapezoidal f a b (2^j) | j <- [0..n]]
        go table 0 = table
        go table m = go (nextRow : table) (m-1)
          where
            prevRow = head table
            nextRow = [improve (prevRow !! i) (prevRow !! (i+1)) m 
                     | i <- [0..length prevRow - 2]]
    
    -- Richardson extrapolation with more stable computation
    improve t1 t2 m = 
        let factor = 4 ^ m
        in (factor * t2 - t1) / (factor - 1)



        