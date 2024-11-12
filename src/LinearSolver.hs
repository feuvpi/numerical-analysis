module LinearSolver (gaussianEliminationSparse) where

import SparseMatrix (SparseMatrix, getElem, updateSparse)

gaussianEliminationSparse :: SparseMatrix -> [Double] -> Maybe [Double]
gaussianEliminationSparse mat b = do
    let n = length b
    if isInconsistent mat b
    then Nothing  -- Return Nothing if system is inconsistent
    else do
        (mat', b') <- reduce mat b n 0
        backSubstitute mat' b' n

-- Check if system is inconsistent by comparing rows with identical coefficients
isInconsistent :: SparseMatrix -> [Double] -> Bool
isInconsistent mat b =
    let n = length b
        getRow i = [getElem mat i j | j <- [0..n-1]]
        -- Compare each pair of rows
        sameCoeffs i j = getRow i == getRow j
        diffConstants i j = abs (b !! i - b !! j) > 1e-10
    in any (\i -> any (\j -> sameCoeffs i j && diffConstants i j) [i+1..n-1]) [0..n-2]

-- Reduce the sparse matrix to upper triangular form
reduce :: SparseMatrix -> [Double] -> Int -> Int -> Maybe (SparseMatrix, [Double])
reduce mat b n k
  | k >= n = Just (mat, b)
  | otherwise = 
      case abs pivot of
        p | p < 1e-10 -> Nothing  -- Cannot proceed if pivot is too close to zero
        _ -> let (mat'', b'') = foldl eliminateRow (mat, b) [k + 1 .. n - 1]
             in case checkInconsistent mat'' b'' k of
                  True -> Nothing
                  False -> reduce mat'' b'' n (k + 1)
  where
    pivot = getElem mat k k
    eliminateRow (matAcc, bAcc) i =
      let factor = getElem matAcc i k / pivot
          matAcc' = foldl (\m j ->
                      let a_ij = getElem m i j
                          a_kj = getElem m k j
                          value = a_ij - factor * a_kj
                      in if abs value > 1e-10  -- Use tolerance for zero check
                         then updateSparse m i j value
                         else m
                    ) matAcc [k..n-1]
          b_i = bAcc !! i
          b_k = bAcc !! k
          b_i' = b_i - factor * b_k
          bAcc' = replaceNth i b_i' bAcc
      in (matAcc', bAcc')

-- Helper function to check if system becomes inconsistent
checkInconsistent :: SparseMatrix -> [Double] -> Int -> Bool
checkInconsistent mat b k =
    let n = length b
        isZeroRow i = all (\j -> abs (getElem mat i j) < 1e-10) [k..n-1]
        hasNonZeroConstant i = abs (b !! i) > 1e-10
    in any (\i -> isZeroRow i && hasNonZeroConstant i) [k + 1..n-1]

-- Back substitution remains the same as before
backSubstitute :: SparseMatrix -> [Double] -> Int -> Maybe [Double]
backSubstitute mat b n = backSubstitute' (n - 1) []
  where
    backSubstitute' (-1) xs = Just xs
    backSubstitute' i xs =
      if abs (getElem mat i i) < 1e-10
      then Nothing
      else
        let sum_ax = sum [ getElem mat i j * xj 
                        | (j, xj) <- zip [i+1..n-1] xs ]
            xi = (b !! i - sum_ax) / getElem mat i i
        in if isNaN xi || isInfinite xi
           then Nothing
           else backSubstitute' (i - 1) (xi : xs)

-- Helper function to replace an element in a list
replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []  -- Handle empty list case
replaceNth n x xs
  | n < 0 = xs          -- Handle negative index
  | n >= length xs = xs  -- Handle index out of bounds
  | otherwise = go n x xs
  where
    go 0 y (_:ys) = y : ys
    go m y (z:ys) = z : go (m-1) y ys
    go _ _ [] = []      -- Should never reach here due to bounds check
