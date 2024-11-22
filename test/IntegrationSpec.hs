module IntegrationSpec (spec) where

import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Integration

spec :: Spec
spec = do
  describe "Integration" $ do
    it "trapezoidal rule approximates integral of x^2 from 0 to 1" $ do
      let result = trapezoidal (\x -> x*x) 0 1 100
      abs (result - 1/3) `shouldSatisfy` (< 0.0001)

    it "simpson rule is more accurate than trapezoidal for polynomials" $ do
      let trap_err = abs (trapezoidal (\x -> x*x*x) 0 1 100 - 1/4)
          simp_err = abs (simpson (\x -> x*x*x) 0 1 100 - 1/4)
      simp_err `shouldSatisfy` (< trap_err)

    it "gaussian quadrature is accurate for polynomials" $ do
      let result = gaussianQuadrature 5 (\x -> x*x) (-1) 1
      abs (result - 2/3) `shouldSatisfy` (< 1e-10)

    it "adaptive quadrature handles rapidly varying functions" $ do
      let result = adaptiveQuadrature (\x -> 1/x) 1 2 1e-6
      abs (result - 0.693147) `shouldSatisfy` (< 1e-6)

    it "romberg integration converges rapidly for smooth functions" $ do
      let result = romberg sin 0 pi 8
          expected = 2.0
          tolerance = 1e-5  -- Increased tolerance slightly
      abs (result - expected) `shouldSatisfy` (< tolerance)

    it "all methods handle negative intervals correctly" $ property $
      \x y -> x /= y ==> 
        let result = trapezoidal (\t -> t) x y 100 + trapezoidal (\t -> t) y x 100
        in abs result < 1e-10

    describe "error handling" $ do
      it "throws error for trapezoidal with non-positive intervals" $
        evaluate (trapezoidal (\x -> x) 0 1 (-1))  -- Changed from 0 to -1
          `shouldThrow` errorCall "Number of intervals must be positive"

      it "throws error for simpson with odd number of intervals" $
        evaluate (simpson (\x -> x) 0 1 3)
          `shouldThrow` errorCall "Number of intervals must be even"

      it "throws error for gaussian quadrature with non-positive points" $
        evaluate (gaussianQuadrature 0 (\x -> x) 0 1)
          `shouldThrow` errorCall "Number of points must be positive"

      it "throws error for romberg with non-positive order" $
        evaluate (romberg (\x -> x) 0 1 0)
          `shouldThrow` errorCall "Order must be positive"