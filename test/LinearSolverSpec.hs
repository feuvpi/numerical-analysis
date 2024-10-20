module LinearSolverSpec (spec) where

import Test.Hspec
import LinearSolver
import SparseMatrix (SparseMatrix) 

spec :: Spec
spec = do
  describe "Gaussian Elimination for Sparse Matrices" $ do
    it "solves a simple system of equations" $ do
      let mat = SparseMatrix [(0,0,1), (0,1,1), (1,0,2), (1,1,1)]
          b = [3, 5]
      case gaussianEliminationSparse mat b of
        Just xs -> xs `shouldBe` [2, 1]
        Nothing -> expectationFailure "The system should have a unique solution."

    it "returns Nothing for an inconsistent system" $ do
      let mat = SparseMatrix [(0,0,1), (0,1,1), (1,0,1), (1,1,1)]
          b = [1, 2]
      gaussianEliminationSparse mat b `shouldBe` Nothing

    -- Add more test cases as needed