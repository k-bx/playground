{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeFamilies #-}

import Data.Array

-- | A concept. Either an element or a relation
data C = E | R

type family ConceptToVal (c :: C) :: * where
  ConceptToVal E = C
  ConceptToVal R = C

type Vertex = Int
type Table a = Array Vertex a
type Graph (e::C) = Table [(ConceptToVal e, Vertex)]
type Labeling a = Vertex -> a

-- | A labeled graph.
-- Taken from https://wiki.haskell.org/The_Monad.Reader/Issue5/Practical_Graph_Handling
data Graph' (v::C) (e::C) = Graph' (Graph e) (Labeling (ConceptToVal v))

type M = Graph' E R
