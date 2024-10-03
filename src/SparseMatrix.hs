module SparseMatrix {
    SparseMatrix,
    lookupSparse,
    updateSparse
} where

-- Type definition for sparse matrix
type SparseMatrix = [(Int, Int, Double)]

-- Function to lookup a value in the sparse matrix
lookupSparse :: SparseMatrix -> Int -> Int -> Double
lookupSparse [] _ _ = 0
lookupSparse ()