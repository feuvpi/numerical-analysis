module LinearSolver (gaussianEliminationSparse) where

import SparseMatrix (SparseMatrix, getElem, updateSparse)

-- Perform Gaussian elimination on a sparse matrix
gaussianEliminationSparse :: SparseMatrix -> [Double] -> Maybe [Double]
gaussianEliminationSparse mat b = do
    let n = length b
    (mat', b') <- reduce mat b n 0
    backSubstitute mat' b' n

-- Reduce the sparse matrix to upper triangular form
reduce :: SparseMatrix -> [Double] -> Int -> Int -> Maybe (SparseMatrix, [Double])
reduce mat b n k
  | k >= n = Just (mat, b)
  | otherwise = 
      case pivot of
        0 -> Nothing  -- Cannot proceed if pivot is zero
        _ -> reduce mat'' b'' n (k + 1)
  where
    pivot = getElem mat k k
    eliminateRow (matAcc, bAcc) i =
      let factor = getElem matAcc i k / pivot
          matAcc' = foldl (\m j ->
                      let a_ij = getElem m i j
                          a_kj = getElem m k j
                          value = a_ij - factor * a_kj
                      in if value /= 0
                         then updateSparse m i j value
                         else m
                    ) matAcc [k..n-1]
          b_i = bAcc !! i
          b_k = bAcc !! k
          b_i' = b_i - factor * b_k
          bAcc' = replaceNth i b_i' bAcc
      in (matAcc', bAcc')
    (mat'', b'') = foldl eliminateRow (mat, b) [k + 1 .. n - 1]

-- Back substitution
backSubstitute :: SparseMatrix -> [Double] -> Int -> Maybe [Double]
backSubstitute mat b n = backSubstitute' (n - 1) []
  where
    backSubstitute' (-1) xs = Just xs
    backSubstitute' i xs =
      let sum_ax = sum [ getElem mat i j * xj | (j, xj) <- zip [i+1..n-1] xs ]
          xi = (b !! i - sum_ax) / getElem mat i i
      in if getElem mat i i == 0
          then Nothing  -- Cannot divide by zero
          else backSubstitute' (i - 1) (xi : xs)

-- Helper function to replace an element in a list
replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth 0 x (_:xs) = x : xs
replaceNth i x (y:ys) = y : replaceNth (i - 1) x ys
