module Main where

-- instance Monad ((->) r) where
--     f >>= k = \ r -> k (f r) r

somereader :: Int -> Int
somereader = do
  x <- (+1)
  y <- (+1)
  z <- (+1)
  pure $ x + y + z

main :: IO ()
main = do
  print $ somereader 1
  -- prints "31"
