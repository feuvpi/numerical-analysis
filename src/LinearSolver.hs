module LinearSolver (gaussianElimination) where

import Data.List (elemIndex)
import Data.Maybe (fromJust)

-- Gaussian elimination to solve Ax = b
gaussianElimination :: [[Double]] -> [Double] -> [Double]
gaussianElimination a b = backSubstitute (reduce (zipWith (++) a(map (\x -> [x]) b)))

-- Forward elimination (reduction to upper triangular form)
reduce :: [[Double]] -> [[Double]]