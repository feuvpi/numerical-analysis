module DifferentiationSpec (spec) where

import Test.Hspec
import Test.QuickCheck
import Differentiation
import Control.Exception (evaluate)

spec :: Spec
spec = do
  describe "Differentiation" $ do
    it "centralDifference approximates sin'(x) = cos(x)" $
      property $ \x -> abs (centralDifference sin x 0.0001 - cos x) < 0.0001

    it "forwardDifference approximates x^2' = 2x" $
      property $ \x -> abs (forwardDifference (\y -> y^2) x 0.0001 - 2*x) < 0.0001

    it "richardsonExtrapolation improves accuracy" $ do
      let f x = x^3
          x = 2
          h = 0.1
      abs (richardsonExtrapolation f x h 4 - 12) `shouldSatisfy` (< 1e-10)

    it "nthOrderCentralDifference computes higher derivatives correctly" $ do
      let f x = x^4
          x = 1
          h = 0.0001
      abs (nthOrderCentralDifference 2 f x h - 12) `shouldSatisfy` (< 0.0001)

    it "finiteDifference is an alias for centralDifference" $
      property $ \f x h -> finiteDifference f x h == centralDifference f x h

    it "throws an error for non-positive step size" $
      evaluate (centralDifference sin 0 (-0.1)) `shouldThrow` anyException