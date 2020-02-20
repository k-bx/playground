#!/usr/bin/env stack
{- stack script
     --resolver=lts-15.0
     --package process
-}
{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import System.Exit (ExitCode(..))
import qualified System.Process as P

main :: IO ()
main = do
  let cp0 = P.proc "./webapp" []
      pcWorkingDir = Just "./inner"
      cp = cp0 {P.cwd = pcWorkingDir}
  (minH, moutH, merrH, pHandle) <- P.createProcess_ "startProcess" cp
  putStrLn "> started"
  threadDelay (2 * 1000000)
  putStrLn "> exiting"
