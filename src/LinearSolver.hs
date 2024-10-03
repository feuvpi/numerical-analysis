module LinearSolver (gaussianElimination) where

import Data.Sparse.Types
import Data.Sparse.Matrix
import qualified Data.Sparse.Vector as SV
import qualified Data.Vector as V

-- Perform Gaussian elimination on a sparse matrix
gaussianElimination :: (Num a) => SpMatrix a -> SV.SparseVector a -> Maybe (SV.SparseVector a)
gaussianElimination mat b = backSubstitute (reduce (mat, b))

-- Reduce the sparse matrix to upper triangular form
reduce :: (Num a) => (SpMatrix a, SV.SparseVector a) -> Maybe (SpMatrix a, SV.SparseVector a)
reduce (mat, b) = case leadCol of
  Nothing -> Nothing
  Just col -> Just (mat', b')
  where
    leadCol = V.findIndex (== maximum (V.map abs (getNonZeroValues mat))) (getNonZeroValues mat)
    mat' = mapRows (\i row -> if i == col then row else row - (getElem mat i col) * (getRow mat col) / (getElem mat col col)) mat
    b' = SV.mapWithIndex (\i val -> val - (getElem mat i col) * (SV.getElem b col) / (getElem mat col col)) b

-- Back substitution
backSubstitute :: (Num a) => Maybe (SpMatrix a, SV.SparseVector a) -> Maybe (SV.SparseVector a)
backSubstitute Nothing = Nothing
backSubstitute (Just (mat, b)) = Just (SV.generate (SV.length b) (\i -> (SV.getElem b i - sum (zipWith (*) (map (\j -> getElem mat i j) [0..i-1]) (map (\j -> SV.getElem b j) [0..i-1]))) / (getElem mat i i)))
