module Main where

import Data.List (group, genericIndex)

binomial :: Integer -> Integer -> Integer
binomial n k
  | k < 0 || k > n = 0
  | k == 0 || k == n = 1
  | otherwise = binomial (n - 1) k + binomial (n - 1) (k - 1)

pascalRows :: [[Integer]]
pascalRows = iterate nextRow [1]
  where
    nextRow row = zipWith (+) ([0] ++ row) (row ++ [0])

binomial2 :: Integer -> Integer -> Integer
binomial2 n k
  | k < 0 || k > n = 0
  | otherwise = genericIndex (genericIndex pascalRows n) k

mergesort :: Ord a => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs =
  let (left, right) = split xs
  in merge (mergesort left) (mergesort right)

split :: [a] -> ([a], [a])
split [] = ([], [])
split [x] = ([x], [])
split (x:y:rest) =
  let (xs, ys) = split rest
  in (x : xs, y : ys)

merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

de :: Integer -> Integer -> (Integer, Integer, Integer)
de a b =
  let (g, x, y) = egcd a b
  in (x, y, g)

egcd :: Integer -> Integer -> (Integer, Integer, Integer)
egcd a 0 = (abs a, signum a, 0)
egcd a b =
  let (g, x1, y1) = egcd b (a `mod` b)
  in (g, y1, x1 - (a `div` b) * y1)

prime_factors :: Integer -> [Integer]
prime_factors n
  | n < 2 = []
  | otherwise = factor n 2
  where
    factor m p
      | p * p > m = [m]
      | m `mod` p == 0 = p : factor (m `div` p) p
      | otherwise = factor m (p + 1)

totient :: Integer -> Integer
totient n
  | n <= 0 = 0
  | otherwise = sum [1 | k <- [1..n], gcd k n == 1]

totient2 :: Integer -> Integer
totient2 n
  | n <= 0 = 0
  | n == 1 = 1
  | otherwise =
      product [ (p - 1) * p ^ (length grp - 1)
              | grp <- group (prime_factors n)
              , let p = head grp
              ]

primes :: Integer -> [Integer]
primes n
  | n < 2 = []
  | otherwise = filter isPrime [2..n]

isPrime :: Integer -> Bool
isPrime m
  | m < 2 = False
  | m == 2 = True
  | otherwise = null [d | d <- [2..limit], m `mod` d == 0]
  where
    limit = floor (sqrt (fromIntegral m :: Double)) :: Integer

main :: IO ()
main = pure ()
