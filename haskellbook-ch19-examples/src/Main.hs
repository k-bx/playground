{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Environment
import Web.Scotty

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["scotty"] -> mainScotty
    _ -> putStrLn "howdy!"

mainScotty :: IO ()
mainScotty =
  scotty 3000 $ do
    get "/:word" $ do
      beam <- param "word"
      html (mconcat ["<h1>Scotty, ", beam, " me up!</h1>"])
