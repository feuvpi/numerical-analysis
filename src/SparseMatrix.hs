module SparseMatrix (SparseMatrix, getElem, lookupSparse, updateSparse) where

-- Define a data structure to represent a sparse matrix
newtype SparseMatrix = SparseMatrix [(Int, Int, Double)] deriving (Show, Eq) -- (row, column, value)

-- Function to access an element of the sparse matrix
getElem :: SparseMatrix -> Int -> Int -> Double
getElem (SparseMatrix elems) i j = 
    case lookup (i, j) (map (\(r, c, v) -> ((r, c), v)) elems) of
        Just value -> value
        Nothing -> 0.0 -- If there's no defined value, return 0

-- Function to lookup a value in the sparse matrix
lookupSparse :: SparseMatrix -> Int -> Int -> Double
lookupSparse (SparseMatrix []) _ _ = 0 -- If the matrix is empty, return 0
lookupSparse (SparseMatrix ((r, c, v):xs)) row col
    | r == row && c == col = v -- If the row and column match, return the value
    | otherwise = lookupSparse (SparseMatrix xs) row col -- Continue searching in the rest of the matrix

-- Function to update a value in a sparse matrix
updateSparse :: SparseMatrix -> Int -> Int -> Double -> SparseMatrix
updateSparse (SparseMatrix elems) i j value =
    SparseMatrix (filter (\(x, y, _) -> x /= i || y /= j) elems ++ [(i, j, value)])