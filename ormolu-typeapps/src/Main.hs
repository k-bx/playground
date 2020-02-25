{-# LANGUAGE TypeApplications #-}

module Main where

main :: IO ()
main = do
  print @Int 3
  putStrLn "hello world"
