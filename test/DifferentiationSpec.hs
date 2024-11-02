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
      
    -- In DifferentiationSpec.hs
    it "forwardDifference approximates x^2' = 2x" $ 
      property $ \x -> abs (forwardDifference (\y -> y ** 2) x 0.00001 - 2 * x) < 0.001  -- Smaller h for improved accuracy

    it "richardsonExtrapolation improves accuracy" $ do
      let f x = x ** 3.0  -- Using ** for floating-point exponentiation
          testPoint = 2.0         -- Explicit Double literal
          h = 0.1
      abs (richardsonExtrapolation f testPoint h 4 - 12.0) `shouldSatisfy` (< 1e-10)

    it "nthOrderCentralDifference computes higher derivatives correctly" $ do
      let f x = x ** 4
          testPoint = 1
          h = 0.0001
      abs (nthOrderCentralDifference 2 f testPoint h - 12) `shouldSatisfy` (< 0.0001)

    it "finiteDifference is an alias for centralDifference" $ do
      property $ \x h -> 
        abs x < 1000 && h > 0.0001 && h < 1 ==>  -- reasonable bounds
        finiteDifference sin x h == centralDifference sin x h

    it "throws an error for non-positive step size" $ do
      evaluate (forwardDifference (\x -> x) 1 (-0.1)) `shouldThrow` anyErrorCall
      evaluate (forwardDifference (\x -> x) 1 0) `shouldThrow` anyErrorCall
      evaluate (centralDifference (\x -> x) 1 (-0.1)) `shouldThrow` anyErrorCall
      evaluate (centralDifference (\x -> x) 1 0) `shouldThrow` anyErrorCall -- Change centralDifference to forwardDifference
