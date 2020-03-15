module Main where

data Tri = T1 | T2 | T3

six :: [(Tri, Bool)]
six =
  [ (T1, False),
    (T1, True),
    (T2, False),
    (T2, True),
    (T3, False),
    (T3, True)
  ]

eight :: [Tri -> Bool]
eight =
  [ \t -> case t of
      T1 ->
        False
      T2 ->
        False
      T3 ->
        False,
    \t -> case t of
      T1 ->
        False
      T2 ->
        False
      T3 ->
        True,
    \t -> case t of
      T1 ->
        False
      T2 ->
        True
      T3 ->
        False,
    \t -> case t of
      T1 ->
        False
      T2 ->
        True
      T3 ->
        True,
    \t -> case t of
      T1 ->
        True
      T2 ->
        False
      T3 ->
        False,
    \t -> case t of
      T1 ->
        True
      T2 ->
        False
      T3 ->
        True,
    \t -> case t of
      T1 ->
        True
      T2 ->
        True
      T3 ->
        False,
    \t -> case t of
      T1 ->
        True
      T2 ->
        True
      T3 ->
        True
  ]

main :: IO ()
main = do
  putStrLn "hello world"
