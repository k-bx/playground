{-# LANGUAGE QuasiQuotes #-}

module Week18 where

import Control.Monad.Trans.State
import Text.RawString.QQ
import Text.Trifecta

-- char :: Char -> Parser Char
-- (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- (>>)  :: Monad m => m a -> m b -> m b
-- (*>) = (>>)
-- (*>) :: f a -> f b -> f b
-- (<*) :: f a -> f b -> f a

ex01 :: StateT Int IO ()
ex01 = do
  put 8

ex02 :: StateT Int IO Int
ex02 = do
  get

stop = unexpected "stop pls"

oneTwo :: Parser Char
oneTwo = char '1' >> char '2'

oneTwo' :: Parser ()
oneTwo' = oneTwo >> stop

testParse :: Parser Char -> IO ()
testParse p =
  print $ parseString p mempty "123"

-- Exercises: Parsing practice
-- 1. implement your own eof
myEof :: Parser (); myEof = undefined
-- 2. Use string to make a Parser that parses “1”, “12”, and “123” out of the example input, respectively.
p123 :: String -> Result Int; p123 = undefined
-- 3. Try writing a Parser that does what string does, but using char.

-- Exercise: Unit of success
-- What we want you to try now is rewriting the final example so it returns the integer that it parses instead of Success ()
-- parseString (integer >> eof) mempty "123"

-- Meta-programming
multiLineString =
  "first line\n"
    ++ "second line\n"
    ++ "third line"

eitherOr :: String
eitherOr =
  [r|
123
abc
456
def
  |]

-- same as
-- "\n" ++
-- "123\n" ++
-- "abc\n" ++
-- "456\n" ++
-- "def\n"

-- myR = ... Data.Text.strip (...)

-- Exercise: Try try
-- Make a parser, using the existing fraction parser plus a new decimal parser, that can parse either decimals or fractions.

-- 24.11 Chapter exercises
