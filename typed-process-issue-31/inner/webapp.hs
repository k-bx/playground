#!/usr/bin/env stack
{- stack script
     --resolver=lts-15.0
     --package rio
     --package text
     --package string-class
     --package fsnotify
     --package directory
     --package process
     --package typed-process
     --compile
-}
{-# LANGUAGE OverloadedStrings #-}

import qualified Control.Concurrent.MVar as MVar
import qualified Data.String.Class as S
import qualified Data.Text as T
import RIO
import System.Directory (canonicalizePath)
import System.Exit (ExitCode(..))
import qualified System.FSNotify as FSNotify
import System.Process.Typed

main :: IO ()
main = do
  putStrLn "> starting the webapp"
  threadDelay (20 * 1000000)
