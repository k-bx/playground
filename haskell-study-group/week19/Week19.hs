module Week19 where

build :: forall a. (forall b. (a -> b -> b) -> b -> b) -> [a]

build :: forall a. forall b. ((a -> b -> b) -> b -> b) -> [a]
build g = g (:) []

map :: (a -> b) -> [a] -> [b]
map :: forall a. forall b. (a -> b) -> [a] -> [b]
map :: forall b. forall a. (a -> b) -> [a] -> [b]

-XExplicitForall
-XTypeApplications

map @Int f xs

-XScopedTypeVariables

f :: forall a b c. a -> b -> c
f a b =
  let x = 10 in
  let y = x + 1 in
  let extract :: b -> c
      extract = undefined
      doSomething :: a -> b -> b
      doSomething = undefined
      andElse :: forall b. b
      andElse x = x
  in extract (doSomething a b)
