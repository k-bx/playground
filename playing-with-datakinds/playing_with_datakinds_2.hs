{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeFamilies  #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedLists #-}

import           Data.Map           (Map)
import qualified Data.Map           as Map
import           Data.Set           (Set)
import qualified Data.Set           as Set

type L = Map String String

data C = E L | R L deriving (Eq, Ord)

-- | Kind-conversion.
type family ConceptToVal (c :: C) :: * where
  ConceptToVal (E _) = C
  ConceptToVal (R _) = C

data S (e :: C) (r :: C) = Graph (ConceptToVal e) (ConceptToVal r)

type M = S (E '[]) (R '[])
